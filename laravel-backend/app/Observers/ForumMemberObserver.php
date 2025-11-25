<?php

namespace App\Observers;

use App\Models\ForumMember;
use App\Services\NotificationService;

class ForumMemberObserver
{
    protected $notificationService;

    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    /**
     * Handle the ForumMember "created" event.
     */
    public function created(ForumMember $forumMember)
    {
        // Send notification when a new member joins a forum
        $this->notificationService->sendForumJoinNotification(
            $forumMember->forum_id,
            $forumMember->user_id
        );
    }
}

