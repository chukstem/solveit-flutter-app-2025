<?php

namespace App\Observers;

use App\Models\Comment;
use App\Services\NotificationService;

class CommentObserver
{
    protected $notificationService;

    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    /**
     * Handle the Comment "created" event.
     */
    public function created(Comment $comment)
    {
        // Send notification when a new comment is created
        if ($comment->post && $comment->post->user_id !== $comment->user_id) {
            $this->notificationService->sendPostCommentNotification(
                $comment->post_id,
                $comment->user_id,
                $comment->body
            );
        }
    }
}

