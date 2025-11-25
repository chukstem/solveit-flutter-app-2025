<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class WhisperReceived implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $userId;
    public $userName;
    public $conversationId;
    public $eventType;
    public $data;

    /**
     * Create a new event instance.
     */
    public function __construct($userId, $userName, $conversationId, $eventType, $data = [])
    {
        $this->userId = $userId;
        $this->userName = $userName;
        $this->conversationId = $conversationId;
        $this->eventType = $eventType;
        $this->data = $data;
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
        return 'whisper.received';
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
            'event_type' => $this->eventType,
            'data' => $this->data,
            'timestamp' => now()->toIso8601String(),
        ];
    }
}




