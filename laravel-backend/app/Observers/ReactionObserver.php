<?php

namespace App\Observers;

use App\Models\Reaction;
use App\Models\Post;
use App\Models\Comment;
use App\Models\ForumMessage;
use App\Services\NotificationService;

class ReactionObserver
{
    protected $notificationService;

    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    /**
     * Handle the Reaction "created" event.
     */
    public function created(Reaction $reaction)
    {
        // Only send notifications for 'like' reactions
        if ($reaction->type !== 'like') {
            return;
        }

        $reactionable = $reaction->reactionable;

        if ($reactionable instanceof Post) {
            // Send post like notification
            if ($reactionable->user_id !== $reaction->user_id) {
                $this->notificationService->sendPostLikeNotification(
                    $reactionable->id,
                    $reaction->user_id
                );
            }
        } elseif ($reactionable instanceof Comment) {
            // Send comment like notification
            if ($reactionable->user_id !== $reaction->user_id) {
                $this->notificationService->sendCommentLikeNotification(
                    $reactionable->id,
                    $reaction->user_id
                );
            }
        } elseif ($reactionable instanceof ForumMessage) {
            // Send reply like notification
            if ($reactionable->user_id !== $reaction->user_id) {
                $this->notificationService->sendReplyLikeNotification(
                    $reactionable->id,
                    $reaction->user_id
                );
            }
        }
    }
}

