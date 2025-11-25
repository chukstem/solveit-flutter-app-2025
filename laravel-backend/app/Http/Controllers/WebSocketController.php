<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Events\UserOnline;
use App\Events\UserOffline;

class WebSocketController extends Controller
{
    /**
     * Handle user going online.
     */
    public function userOnline(Request $request)
    {
        $user = Auth::user();
        
        // Update last activity
        $user->update(['last_login_at' => now()]);
        
        // Broadcast online event
        broadcast(new UserOnline($user));
        
        return $this->success(['status' => 'online'], 'User is now online');
    }

    /**
     * Handle user going offline.
     */
    public function userOffline(Request $request)
    {
        $user = Auth::user();
        
        // Broadcast offline event
        broadcast(new UserOffline($user));
        
        return $this->success(['status' => 'offline'], 'User is now offline');
    }

    /**
     * Get online users for a school.
     */
    public function getOnlineUsers(Request $request)
    {
        $user = Auth::user();
        
        // This would typically be stored in Redis or database
        // For now, we'll return a mock response
        $onlineUsers = [
            [
                'id' => 1,
                'name' => 'John Doe',
                'avatar' => 'https://ui-avatars.com/api/?name=John+Doe&background=83074E&color=fff',
                'last_seen' => now()->subMinutes(5)->toISOString(),
            ],
            [
                'id' => 2,
                'name' => 'Jane Smith',
                'avatar' => 'https://ui-avatars.com/api/?name=Jane+Smith&background=83074E&color=fff',
                'last_seen' => now()->subMinutes(2)->toISOString(),
            ],
        ];
        
        return $this->success($onlineUsers);
    }

    /**
     * Join a presence channel.
     */
    public function joinChannel(Request $request)
    {
        $validator = \Validator::make($request->all(), [
            'channel' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = Auth::user();
        $channel = $request->channel;

        // Validate channel access
        if (!$this->canAccessChannel($user, $channel)) {
            return $this->forbidden('You do not have access to this channel');
        }

        return $this->success([
            'channel' => $channel,
            'user' => $user,
            'timestamp' => now()->toISOString(),
        ], 'Successfully joined channel');
    }

    /**
     * Leave a presence channel.
     */
    public function leaveChannel(Request $request)
    {
        $validator = \Validator::make($request->all(), [
            'channel' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = Auth::user();
        $channel = $request->channel;

        return $this->success([
            'channel' => $channel,
            'user' => $user,
            'timestamp' => now()->toISOString(),
        ], 'Successfully left channel');
    }

    /**
     * Check if user can access a channel.
     */
    private function canAccessChannel($user, $channel)
    {
        // Check for private channels
        if (str_starts_with($channel, 'private-')) {
            return true; // Add your logic here
        }

        // Check for presence channels
        if (str_starts_with($channel, 'presence-')) {
            return true; // Add your logic here
        }

        // Check for school channels
        if (str_starts_with($channel, 'school.')) {
            $schoolId = str_replace('school.', '', $channel);
            return $user->school_id == $schoolId;
        }

        // Check for user channels
        if (str_starts_with($channel, 'user.')) {
            $userId = str_replace('user.', '', $channel);
            return $user->id == $userId;
        }

        // Check for conversation channels
        if (str_starts_with($channel, 'conversation.')) {
            $conversationId = str_replace('conversation.', '', $channel);
            return $user->conversations()->where('conversation_id', $conversationId)->exists();
        }

        // Public channels
        return in_array($channel, ['posts', 'marketplace', 'products', 'users']);
    }
}
