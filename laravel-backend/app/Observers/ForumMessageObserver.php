<?php

namespace App\Observers;

use App\Models\ForumMessage;
use App\Services\NotificationService;

class ForumMessageObserver
{
    protected $notificationService;

    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    /**
     * Handle the ForumMessage "created" event.
     */
    public function created(ForumMessage $forumMessage)
    {
        // Send notification when a new forum message is created
        $this->notificationService->sendForumMessageNotification(
            $forumMessage->forum_id,
            $forumMessage->user_id,
            $forumMessage->message
        );
    }
}

