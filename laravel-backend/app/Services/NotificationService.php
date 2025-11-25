<?php

namespace App\Services;

use App\Models\User;
use App\Models\AdminNotification;
use GuzzleHttp\Client;
use Illuminate\Support\Facades\Log;

class NotificationService
{
    private $client;
    private $accessToken;

    public function __construct()
    {
        $this->client = new Client();
    }

    /**
     * Send topic-based push notification to a specific user
     */
    public function sendTopicNotification(int $userId, string $title, string $message, array $data = [])
    {
        try {
            // Check if user is online - if online, don't send notification
            $user = User::find($userId);
            if (!$user || $user->is_online) {
                return false;
            }

            $topic = "user_{$userId}";
            $accessToken = $this->getAccessToken();
            
            $url = 'https://fcm.googleapis.com/v1/projects/' . env('FIREBASE_PROJECT_ID') . '/messages:send';

            $messagePayload = [
                'message' => [
                    'topic' => $topic,
                    'notification' => [
                        'title' => $title,
                        'body' => $message,
                    ],
                    'data' => array_merge($data, [
                        'type' => $data['type'] ?? 'general',
                        'timestamp' => now()->toISOString(),
                    ]),
                    'android' => [
                        'priority' => 'high',
                        'notification' => [
                            'sound' => 'default',
                            'channel_id' => 'default',
                        ],
                    ],
                    'apns' => [
                        'headers' => [
                            'apns-priority' => '10',
                        ],
                        'payload' => [
                            'aps' => [
                                'sound' => 'default',
                                'badge' => 1,
                            ],
                        ],
                    ],
                ],
            ];

            $response = $this->client->post($url, [
                'headers' => [
                    'Authorization' => 'Bearer ' . $accessToken,
                    'Content-Type' => 'application/json',
                ],
                'json' => $messagePayload,
                'timeout' => 15,
            ]);

            // Log the notification
            $this->logNotification($userId, $title, $message, $data, true);

            return json_decode((string) $response->getBody(), true);
        } catch (\Throwable $e) {
            Log::error('Failed to send topic notification', [
                'user_id' => $userId,
                'title' => $title,
                'message' => $message,
                'error' => $e->getMessage(),
            ]);

            $this->logNotification($userId, $title, $message, $data, false, $e->getMessage());
            return false;
        }
    }

    /**
     * Send chat message notification
     */
    public function sendChatNotification(int $receiverId, int $senderId, string $message, int $conversationId = null)
    {
        $sender = User::find($senderId);
        if (!$sender) return false;

        $title = "New message from {$sender->name}";
        $data = [
            'type' => 'chat',
            'sender_id' => $senderId,
            'sender_name' => $sender->name,
            'conversation_id' => $conversationId,
            'action' => 'open_chat',
        ];

        return $this->sendTopicNotification($receiverId, $title, $message, $data);
    }

    /**
     * Send forum message notification
     */
    public function sendForumMessageNotification(int $forumId, int $senderId, string $message)
    {
        $sender = User::find($senderId);
        $forum = \App\Models\Forum::find($forumId);
        
        if (!$sender || !$forum) return false;

        // Get all forum members except the sender
        $members = \App\Models\ForumMember::where('forum_id', $forumId)
            ->where('user_id', '!=', $senderId)
            ->where('muted', false)
            ->pluck('user_id');

        $title = "New message in {$forum->name}";
        $data = [
            'type' => 'forum_message',
            'forum_id' => $forumId,
            'forum_name' => $forum->name,
            'sender_id' => $senderId,
            'sender_name' => $sender->name,
            'action' => 'open_forum',
        ];

        $sentCount = 0;
        foreach ($members as $memberId) {
            if ($this->sendTopicNotification($memberId, $title, $message, $data)) {
                $sentCount++;
            }
        }

        return $sentCount;
    }

    /**
     * Send post comment notification
     */
    public function sendPostCommentNotification(int $postId, int $commenterId, string $comment)
    {
        $commenter = User::find($commenterId);
        $post = \App\Models\Post::find($postId);
        
        if (!$commenter || !$post || $post->user_id === $commenterId) return false;

        $title = "New comment on your post";
        $data = [
            'type' => 'post_comment',
            'post_id' => $postId,
            'post_title' => $post->title,
            'commenter_id' => $commenterId,
            'commenter_name' => $commenter->name,
            'action' => 'open_post',
        ];

        return $this->sendTopicNotification($post->user_id, $title, $comment, $data);
    }

    /**
     * Send post like notification
     */
    public function sendPostLikeNotification(int $postId, int $likerId)
    {
        $liker = User::find($likerId);
        $post = \App\Models\Post::find($postId);
        
        if (!$liker || !$post || $post->user_id === $likerId) return false;

        $title = "{$liker->name} liked your post";
        $data = [
            'type' => 'post_like',
            'post_id' => $postId,
            'post_title' => $post->title,
            'liker_id' => $likerId,
            'liker_name' => $liker->name,
            'action' => 'open_post',
        ];

        return $this->sendTopicNotification($post->user_id, $title, $post->title, $data);
    }

    /**
     * Send comment like notification
     */
    public function sendCommentLikeNotification(int $commentId, int $likerId)
    {
        $liker = User::find($likerId);
        $comment = \App\Models\Comment::find($commentId);
        
        if (!$liker || !$comment || $comment->user_id === $likerId) return false;

        $title = "{$liker->name} liked your comment";
        $data = [
            'type' => 'comment_like',
            'comment_id' => $commentId,
            'post_id' => $comment->post_id,
            'liker_id' => $likerId,
            'liker_name' => $liker->name,
            'action' => 'open_post',
        ];

        return $this->sendTopicNotification($comment->user_id, $title, $comment->body, $data);
    }

    /**
     * Send forum join notification
     */
    public function sendForumJoinNotification(int $forumId, int $newMemberId)
    {
        $newMember = User::find($newMemberId);
        $forum = \App\Models\Forum::find($forumId);
        
        if (!$newMember || !$forum) return false;

        // Get all forum members except the new member
        $members = \App\Models\ForumMember::where('forum_id', $forumId)
            ->where('user_id', '!=', $newMemberId)
            ->pluck('user_id');

        $title = "{$newMember->name} joined {$forum->name}";
        $data = [
            'type' => 'forum_join',
            'forum_id' => $forumId,
            'forum_name' => $forum->name,
            'new_member_id' => $newMemberId,
            'new_member_name' => $newMember->name,
            'action' => 'open_forum',
        ];

        $sentCount = 0;
        foreach ($members as $memberId) {
            if ($this->sendTopicNotification($memberId, $title, "A new member has joined the forum", $data)) {
                $sentCount++;
            }
        }

        return $sentCount;
    }

    /**
     * Send reply like notification
     */
    public function sendReplyLikeNotification(int $replyId, int $likerId)
    {
        $liker = User::find($likerId);
        $reply = \App\Models\ForumMessage::find($replyId);
        
        if (!$liker || !$reply || $reply->user_id === $likerId) return false;

        $title = "{$liker->name} liked your reply";
        $data = [
            'type' => 'reply_like',
            'reply_id' => $replyId,
            'forum_id' => $reply->forum_id,
            'liker_id' => $likerId,
            'liker_name' => $liker->name,
            'action' => 'open_forum',
        ];

        return $this->sendTopicNotification($reply->user_id, $title, $reply->message, $data);
    }

    /**
     * Get Firebase access token
     */
    private function getAccessToken(): string
    {
        if ($this->accessToken) {
            return $this->accessToken;
        }

        $serviceAccountKeyFile = strtolower('/home/solveit/backend.solve-it.com.ng/' . env('APP_DOMAIN') . '/storage/app/public/firebase.json');
        $jwtJson = json_decode(file_get_contents($serviceAccountKeyFile), true);
        $now = time();
        $token = [
            'iss' => $jwtJson['client_email'],
            'scope' => 'https://www.googleapis.com/auth/cloud-platform https://www.googleapis.com/auth/firebase.messaging',
            'aud' => 'https://oauth2.googleapis.com/token',
            'iat' => $now,
            'exp' => $now + 3600,
        ];

        $assertion = $this->jwtEncode($token, $jwtJson['private_key']);

        $response = $this->client->post('https://oauth2.googleapis.com/token', [
            'form_params' => [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $assertion,
            ],
            'timeout' => 15,
        ]);

        $body = json_decode((string) $response->getBody(), true);
        $this->accessToken = $body['access_token'];
        
        return $this->accessToken;
    }

    /**
     * Encode JWT token
     */
    private function jwtEncode(array $payload, string $privateKey): string
    {
        $header = $this->base64UrlEncode(json_encode(['alg' => 'RS256', 'typ' => 'JWT']));
        $payload = $this->base64UrlEncode(json_encode($payload));
        $data = $header . '.' . $payload;

        openssl_sign($data, $signature, $privateKey, 'SHA256');
        $signature = $this->base64UrlEncode($signature);

        return $data . '.' . $signature;
    }

    /**
     * Base64 URL encode
     */
    private function base64UrlEncode(string $data): string
    {
        return str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($data));
    }

    /**
     * Log notification to admin notifications
     */
    private function logNotification(int $userId, string $title, string $message, array $data, bool $success, string $error = null)
    {
        AdminNotification::create([
            'user_id' => $userId,
            'type' => 'topic_push',
            'title' => $title,
            'message' => $message,
            'data' => $data,
            'recipients_count' => 1,
            'delivered_count' => $success ? 1 : 0,
            'failed_count' => $success ? 0 : 1,
            'error_message' => $error,
        ]);
    }
}

