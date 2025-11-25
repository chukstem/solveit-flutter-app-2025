<?php

namespace App\Listeners;

use App\Events\MessageSent;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Facades\Notification;
use App\Notifications\NewMessageNotification;

class SendMessageNotification implements ShouldQueue
{
    use InteractsWithQueue;

    /**
     * Create the event listener.
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     */
    public function handle(MessageSent $event): void
    {
        $message = $event->message;
        $receiver = $message->receiver;

        // Send push notification if user is not online
        if (!$this->isUserOnline($receiver->id)) {
            $receiver->notify(new NewMessageNotification($message));
        }
    }

    /**
     * Check if user is online.
     */
    private function isUserOnline($userId)
    {
        // This would typically check Redis or database for online status
        // For now, we'll return false to always send notifications
        return false;
    }
}
