<?php

namespace App\Events;

use App\Models\Message;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class MessageSent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $message;
    public $conversationId;

    /**
     * Create a new event instance.
     */
    public function __construct(Message $message, $conversationId)
    {
        $this->message = $message;
        $this->conversationId = $conversationId;
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
        return 'message.sent';
    }

    /**
     * Get the data to broadcast.
     */
    public function broadcastWith(): array
    {
        // Load media if exists
        $mediaItems = [];
        if ($this->message->hasMedia('attachments')) {
            foreach ($this->message->getMedia('attachments') as $media) {
                $mediaItems[] = [
                    'id' => $media->id,
                    'file_name' => $media->file_name,
                    'mime_type' => $media->mime_type,
                    'size' => $media->size,
                    'url' => $media->getFullUrl(),
                ];
            }
        }

        return [
            'id' => $this->message->id,
            'conversation_id' => $this->conversationId,
            'sender_id' => $this->message->sender_id,
            'receiver_id' => $this->message->receiver_id,
            'body' => $this->message->body,
            'type' => $this->message->type,
            'reply_to' => $this->message->reply_to,
            'is_read' => $this->message->is_read,
            'is_delivered' => $this->message->is_delivered,
            'created_at' => $this->message->created_at->toIso8601String(),
            'media' => $mediaItems,
        ];
    }
}
