<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Laravel\Sanctum\PersonalAccessToken;

class BroadcastingAuthController extends Controller
{
    /**
     * Authenticate broadcasting channels for API token-based requests.
     * 
     * Standard Broadcast::routes() uses stateful middleware which doesn't work 
     * with Bearer token authentication. This custom endpoint handles both 
     * Authorization header tokens and query string tokens.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function authenticate(Request $request)
    {
        // Log the incoming request for debugging
        Log::info('Broadcasting auth request', [
            'all_input' => $request->all(),
            'query_params' => $request->query(),
            'channel_name' => $request->input('channel_name'),
            'socket_id' => $request->input('socket_id'),
            'has_auth_header' => $request->hasHeader('Authorization'),
            'auth_header' => $request->header('Authorization') ? 'Bearer ***' : 'none',
            'has_token_query' => $request->has('token'),
            'token_query_length' => $request->query('token') ? strlen($request->query('token')) : 0,
        ]);
        
        // Get the authenticated user via Sanctum token
        $user = $this->getAuthenticatedUser($request);
        
        if (!$user) {
            Log::warning('Broadcasting auth failed - no user authenticated', [
                'has_auth_header' => $request->hasHeader('Authorization'),
                'has_token_query' => $request->has('token'),
                'token_query_length' => $request->query('token') ? strlen($request->query('token')) : 0,
                'all_query_params' => $request->query(),
            ]);
            return response()->json(['error' => 'Unauthenticated'], 401);
        }
        
        Log::info('Broadcasting auth - user authenticated', ['user_id' => $user->id, 'user_name' => $user->name]);
        
        // Get channel name and socket ID from request
        $channelName = $request->input('channel_name');
        $socketId = $request->input('socket_id');
        
        // Handle pusher_client_fixed format where data comes as JSON string key
        if (!$channelName || !$socketId) {
            $allInput = $request->all();
            
            // Check if the first key is a JSON string containing the data
            if (!empty($allInput)) {
                $firstKey = array_key_first($allInput);
                
                if (is_string($firstKey) && str_starts_with($firstKey, '{')) {
                    try {
                        $decodedData = json_decode($firstKey, true);
                        
                        if (is_array($decodedData)) {
                            $channelName = $decodedData['channel_name'] ?? $channelName;
                            $socketId = $decodedData['socket_id'] ?? $socketId;
                            
                            $originalChannelName = $channelName;
                            $originalSocketId = $socketId;
                            
                            // Fix pusher_client_fixed format: Convert underscores to dots
                            // Pusher expects dots but pusher_client_fixed sends underscores
                            
                            // Convert socket_id: xxxx_yyyy -> xxxx.yyyy
                            if ($socketId && strpos($socketId, '_') !== false && strpos($socketId, '.') === false) {
                                $parts = explode('_', $socketId);
                                if (count($parts) === 2) {
                                    $socketId = $parts[0] . '.' . $parts[1];
                                }
                            }
                            
                            // Convert channel_name: presence-conversation_16_21 -> presence-conversation.16_21
                            // Only convert the last underscore (the one between user IDs)
                            if ($channelName && preg_match('/^(presence-conversation)_(\d+_\d+)$/', $channelName, $matches)) {
                                $channelName = $matches[1] . '.' . $matches[2];
                            }
                            
                            // Log conversions if any were made
                            if ($channelName !== $originalChannelName || $socketId !== $originalSocketId) {
                                Log::info('Broadcasting auth - converted pusher_client_fixed format', [
                                    'original_channel' => $originalChannelName,
                                    'converted_channel' => $channelName,
                                    'original_socket_id' => $originalSocketId,
                                    'converted_socket_id' => $socketId,
                                ]);
                            }
                            
                            Log::info('Broadcasting auth - extracted params from JSON key', [
                                'channel_name' => $channelName,
                                'socket_id' => $socketId,
                            ]);
                            
                            // Update request with proper params for broadcast manager
                            $request->merge([
                                'channel_name' => $channelName,
                                'socket_id' => $socketId,
                            ]);
                        }
                    } catch (\Exception $e) {
                        Log::warning('Broadcasting auth - failed to parse JSON key', [
                            'error' => $e->getMessage(),
                            'key' => $firstKey,
                        ]);
                    }
                }
            }
        }
        
        if (!$channelName || !$socketId) {
            Log::warning('Broadcasting auth failed - missing parameters', [
                'has_channel_name' => !empty($channelName),
                'has_socket_id' => !empty($socketId),
                'all_input' => $request->all(),
            ]);
            return response()->json(['error' => 'Missing channel_name or socket_id'], 400);
        }
        
        Log::info('Broadcasting auth - attempting channel authorization', [
            'user_id' => $user->id,
            'channel' => $channelName,
            'socket_id' => $socketId,
        ]);
        
        // Use Broadcast facade to authorize the channel
        try {
            // Temporarily authenticate the user for broadcasting
            auth()->setUser($user);
            
            // Get the broadcasting manager
            $broadcast = app(\Illuminate\Broadcasting\BroadcastManager::class);
            
        // Authorize the channel using Laravel's channel authorization
        $response = $broadcast->auth($request);
        
        // Check if response is a Response object or array (for presence channels)
        if (is_array($response)) {
            Log::info('Broadcasting auth SUCCESS (array response)', [
                'user_id' => $user->id,
                'channel' => $channelName,
                'has_auth' => isset($response['auth']),
                'has_channel_data' => isset($response['channel_data']),
                'response_keys' => array_keys($response),
            ]);
            return response()->json($response);
        }
        
        Log::info('Broadcasting auth SUCCESS', [
            'user_id' => $user->id,
            'channel' => $channelName,
            'response_status' => $response->status(),
        ]);
        
        return $response;
        } catch (\Exception $e) {
            Log::error('Broadcasting auth error', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
                'user_id' => $user->id ?? 'N/A',
                'channel' => $channelName ?? 'N/A',
            ]);
            return response()->json(['error' => 'Authorization failed: ' . $e->getMessage()], 403);
        }
    }
    
    /**
     * Get authenticated user from request.
     * Tries Authorization header first, then falls back to query string token.
     *
     * @param Request $request
     * @return \App\Models\User|null
     */
    private function getAuthenticatedUser(Request $request)
    {
        $tokenString = null;
        
        // Try to get token from Authorization header first
        if ($request->hasHeader('Authorization')) {
            $authHeader = $request->header('Authorization');
            Log::info('Broadcasting auth - raw header received', [
                'header_length' => strlen($authHeader),
                'header_starts_with_bearer' => str_starts_with($authHeader, 'Bearer '),
                'first_20_chars' => substr($authHeader, 0, 20),
            ]);
            
            // Extract token from "Bearer {token}" format
            if (str_starts_with($authHeader, 'Bearer ')) {
                $tokenString = substr($authHeader, 7); // Remove "Bearer " prefix
                $tokenString = trim($tokenString); // Remove any whitespace
                Log::info('Broadcasting auth - extracted token from header', [
                    'token_length' => strlen($tokenString),
                    'token_prefix' => substr($tokenString, 0, 10) . '...',
                    'contains_pipe' => strpos($tokenString, '|') !== false,
                ]);
            } else {
                Log::warning('Broadcasting auth - header does not start with "Bearer "', [
                    'header_value' => $authHeader
                ]);
            }
        } else {
            Log::info('Broadcasting auth - no Authorization header present');
        }
        
        // If no token from header, try query string
        if (!$tokenString && $request->has('token')) {
            $tokenString = $request->query('token');
            // URL decode the token in case it's encoded
            $tokenString = urldecode($tokenString);
            $tokenString = trim($tokenString); // Remove any whitespace
            Log::info('Broadcasting auth - using token from query string', [
                'token_length' => strlen($tokenString ?? ''),
                'token_prefix' => substr($tokenString ?? '', 0, 10) . '...',
                'contains_pipe' => strpos($tokenString ?? '', '|') !== false,
                'raw_query_token' => $request->query('token'),
            ]);
        }
        
        // If we have a token string, validate it with Sanctum
        if ($tokenString) {
            Log::info('Broadcasting auth - attempting to find token', [
                'token_format' => strpos($tokenString, '|') !== false ? 'id|hash' : 'unknown',
                'token_length' => strlen($tokenString),
            ]);
            
            $token = PersonalAccessToken::findToken($tokenString);
            
            if ($token) {
                Log::info('Broadcasting auth - token found in database', [
                    'token_id' => $token->id,
                    'tokenable_type' => $token->tokenable_type,
                    'tokenable_id' => $token->tokenable_id,
                ]);
                
                // Check if token is expired or revoked
                if ($token->can('*')) {
                    $user = $token->tokenable;
                    Log::info('Broadcasting auth - user authenticated successfully', [
                        'user_id' => $user->id,
                        'user_name' => $user->name,
                    ]);
                    return $user;
                } else {
                    Log::warning('Broadcasting auth - token found but not valid/expired', [
                        'token_id' => $token->id,
                    ]);
                }
            } else {
                Log::warning('Broadcasting auth - token not found in database', [
                    'token_prefix' => substr($tokenString, 0, 10) . '...',
                    'token_length' => strlen($tokenString),
                    'token_format' => strpos($tokenString, '|') !== false ? 'id|hash' : 'unknown',
                ]);
            }
        } else {
            Log::warning('Broadcasting auth - no token provided in header or query', [
                'has_query_params' => count($request->query()) > 0,
                'query_params' => array_keys($request->query()),
            ]);
        }
        
        return null;
    }
}

