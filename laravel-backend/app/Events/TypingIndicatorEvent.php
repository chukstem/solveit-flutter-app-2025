<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class TypingIndicatorEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $userId;
    public $userName;
    public $isTyping;
    public $conversationId;

    /**
     * Create a new event instance.
     */
    public function __construct($userId, $userName, $isTyping, $conversationId)
    {
        $this->userId = $userId;
        $this->userName = $userName;
        $this->isTyping = $isTyping;
        $this->conversationId = $conversationId;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        // Get the other user ID from the conversation
        $otherUserId = $this->getOtherUserId();
        
        if ($otherUserId) {
            // Create deterministic channel name
            $sortedIds = [$this->userId, $otherUserId];
            sort($sortedIds);
            $channelName = 'conversation.' . $sortedIds[0] . '_' . $sortedIds[1];
            
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
            'is_typing' => $this->isTyping,
            'conversation_id' => $this->conversationId,
        ];
    }

    /**
     * Get the other user ID from the conversation
     */
    private function getOtherUserId()
    {
        // You'll need to implement this based on your conversation logic
        // For now, return null - you'll need to query your database
        return null;
    }
}





