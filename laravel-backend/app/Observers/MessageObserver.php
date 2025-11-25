<?php

namespace App\Observers;

use App\Models\Message;
use App\Services\NotificationService;

class MessageObserver
{
    protected $notificationService;

    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    /**
     * Handle the Message "created" event.
     */
    public function created(Message $message)
    {
        // Send notification when a new message is created
        if ($message->receiver_id && $message->sender_id !== $message->receiver_id) {
            $this->notificationService->sendChatNotification(
                $message->receiver_id,
                $message->sender_id,
                $message->body,
                $message->conversation_id
            );
        }
    }
}

