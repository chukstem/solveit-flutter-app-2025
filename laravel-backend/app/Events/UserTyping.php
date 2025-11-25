<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class UserTyping implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $userId;
    public $userName;
    public $conversationId;
    public $isTyping;

    /**
     * Create a new event instance.
     */
    public function __construct($userId, $userName, $conversationId, $isTyping = true)
    {
        $this->userId = $userId;
        $this->userName = $userName;
        $this->conversationId = $conversationId;
        $this->isTyping = $isTyping;
    }

    /**
     * Get the channels the event should broadcast on.
     */
    public function broadcastOn(): array
    {
        // Get the conversation participants to determine the correct channel name
        $conversation = \App\Models\Conversation::with('participants')->find($this->conversationId);
        
        if (!$conversation || $conversation->participants->count() !== 2) {
            return [];
        }
        
        // Get user IDs and sort them for deterministic channel name
        $userIds = $conversation->participants->pluck('id')->sort()->values()->toArray();
        
        if (count($userIds) === 2) {
            $channelName = 'conversation.' . $userIds[0] . '_' . $userIds[1];
            return [
                new PresenceChannel($channelName),
            ];
        }
        
        return [];
    }

    /**
     * The event's broadcast name.
     */
    public function broadcastAs(): string
    {
        return 'user.typing';
    }

    /**
     * Get the data to broadcast.
     */
    public function broadcastWith(): array
    {
        return [
            'user_id' => $this->userId,
            'user_name' => $this->userName,
            'conversation_id' => $this->conversationId,
            'is_typing' => $this->isTyping,
            'timestamp' => now()->toIso8601String(),
        ];
    }
}

