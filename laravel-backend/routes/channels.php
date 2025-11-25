<?php

use Illuminate\Support\Facades\Broadcast;
 
Broadcast::channel('conversation.{userIds}', function ($user, $userIds) {
    \Log::info('Presence channel authorization attempt (dot format)', [
        'user_id' => $user->id,
        'user_ids_param' => $userIds,
    ]);
    
    // Check if this is the new deterministic format (userId1_userId2)
    if (strpos($userIds, '_') !== false) {
        // New deterministic format
        $ids = explode('_', $userIds);
        
        if (count($ids) !== 2) {
            \Log::warning('Invalid user IDs format', ['user_ids' => $userIds]);
            return false;
        }
        
        $userId1 = (int) $ids[0];
        $userId2 = (int) $ids[1];
        
        // Check if current user is one of the two participants
        if ($user->id === $userId1 || $user->id === $userId2) {
            \Log::info('Presence channel authorization SUCCESS (deterministic)', [
                'user_id' => $user->id,
                'channel_user_ids' => [$userId1, $userId2],
            ]);
            
            // Return user info for presence channel
            return [
                'id' => $user->id,
                'name' => $user->name,
                'avatar_url' => $user->avatar_url ?? '',
            ];
        }
        
        \Log::warning('Presence channel authorization FAILED - user not in channel', [
            'user_id' => $user->id,
            'channel_user_ids' => [$userId1, $userId2],
        ]);
        
        return false;
    }
    
    // Legacy format: conversation ID
    $conversationId = $userIds; // In legacy format, this is the conversation ID
    
    \Log::info('Using legacy conversation ID format', [
        'user_id' => $user->id,
        'conversation_id' => $conversationId,
    ]);
    
    // Check if user is a participant in this conversation
    // Uses the conversation_participants pivot table
    $conversation = \App\Models\Conversation::find($conversationId);
    
    if (!$conversation) {
        \Log::warning('Presence channel authorization FAILED - conversation not found', [
            'user_id' => $user->id,
            'conversation_id' => $conversationId,
        ]);
        return false;
    }
    
    $isParticipant = $conversation->participants()->where('users.id', $user->id)->exists();
    
    if ($isParticipant) {
        \Log::info('Presence channel authorization SUCCESS (legacy)', [
            'user_id' => $user->id,
            'conversation_id' => $conversationId,
        ]);
        
        // Return user info for presence channel
        return [
            'id' => $user->id,
            'name' => $user->name,
            'avatar_url' => $user->avatar_url ?? '',
        ];
    }
    
    \Log::warning('Presence channel authorization FAILED - user not a participant', [
        'user_id' => $user->id,
        'conversation_id' => $conversationId,
    ]);
    
    return false;
});

// Additional route for clients that convert dots to underscores
Broadcast::channel('conversation_{userIds}', function ($user, $userIds) {
    \Log::info('Presence channel authorization attempt (underscore format)', [
        'user_id' => $user->id,
        'user_ids_param' => $userIds,
    ]);
    
    // Check if this is the new deterministic format (userId1_userId2)
    if (strpos($userIds, '_') !== false) {
        // New deterministic format
        $ids = explode('_', $userIds);
        
        if (count($ids) !== 2) {
            \Log::warning('Invalid user IDs format', ['user_ids' => $userIds]);
            return false;
        }
        
        $userId1 = (int) $ids[0];
        $userId2 = (int) $ids[1];
        
        // Check if current user is one of the two participants
        if ($user->id === $userId1 || $user->id === $userId2) {
            \Log::info('Presence channel authorization SUCCESS (deterministic)', [
                'user_id' => $user->id,
                'channel_user_ids' => [$userId1, $userId2],
            ]);
            
            // Return user info for presence channel
            return [
                'id' => $user->id,
                'name' => $user->name,
                'avatar_url' => $user->avatar_url ?? '',
            ];
        }
        
        \Log::warning('Presence channel authorization FAILED - user not in channel', [
            'user_id' => $user->id,
            'channel_user_ids' => [$userId1, $userId2],
        ]);
        
        return false;
    }
    
    // Legacy format: conversation ID
    $conversationId = $userIds; // In legacy format, this is the conversation ID
    
    \Log::info('Using legacy conversation ID format', [
        'user_id' => $user->id,
        'conversation_id' => $conversationId,
    ]);
    
    // Check if user is a participant in this conversation
    // Uses the conversation_participants pivot table
    $conversation = \App\Models\Conversation::find($conversationId);
    
    if (!$conversation) {
        \Log::warning('Presence channel authorization FAILED - conversation not found', [
            'user_id' => $user->id,
            'conversation_id' => $conversationId,
        ]);
        return false;
    }
    
    $isParticipant = $conversation->participants()->where('users.id', $user->id)->exists();
    
    if ($isParticipant) {
        \Log::info('Presence channel authorization SUCCESS (legacy)', [
            'user_id' => $user->id,
            'conversation_id' => $conversationId,
        ]);
        
        // Return user info for presence channel
        return [
            'id' => $user->id,
            'name' => $user->name,
            'avatar_url' => $user->avatar_url ?? '',
        ];
    }
    
    \Log::warning('Presence channel authorization FAILED - user not a participant', [
        'user_id' => $user->id,
        'conversation_id' => $conversationId,
    ]);
    
    return false;
});

// Private channel for individual users
// Note: Laravel strips the 'private-' prefix when checking authorization
Broadcast::channel('App.Models.User.{userId}', function ($user, $userId) {
    \Log::info('Private user channel authorization attempt', [
        'authenticated_user_id' => $user->id,
        'requested_user_id' => $userId,
    ]);
    
    $authorized = (int) $user->id === (int) $userId;
    
    if ($authorized) {
        \Log::info('Private user channel authorization SUCCESS');
    } else {
        \Log::warning('Private user channel authorization FAILED');
    }
    
    return $authorized;
});

// Presence channel for forums
// Note: Laravel strips the 'presence-' prefix when checking authorization
Broadcast::channel('forum.{forumId}', function ($user, $forumId) {
    \Log::info('Forum presence channel authorization attempt', [
        'user_id' => $user->id,
        'forum_id' => $forumId,
    ]);
    
    // Check if user is a member of this forum
    $forum = \App\Models\Forum::find($forumId);
    
    if (!$forum) {
        \Log::warning('Forum presence channel authorization FAILED - forum not found', [
            'user_id' => $user->id,
            'forum_id' => $forumId,
        ]);
        return false;
    }
    
    // Check if user is a member (adjust this based on your forum membership logic)
    $isMember = $forum->members()->where('users.id', $user->id)->exists();
    
    if ($isMember) {
        \Log::info('Forum presence channel authorization SUCCESS', [
            'user_id' => $user->id,
            'forum_id' => $forumId,
        ]);
        
        // Return user info for presence channel
        return [
            'id' => $user->id,
            'name' => $user->name,
            'avatar_url' => $user->avatar_url ?? '',
        ];
    }
    
    \Log::warning('Forum presence channel authorization FAILED - user not a member', [
        'user_id' => $user->id,
        'forum_id' => $forumId,
    ]);
    
    return false;
});

 
