<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AdminNotification;
use App\Services\NotificationService;
use GuzzleHttp\Client;
use Illuminate\Http\Request;

class FcmController extends Controller
{
    /**
     * Send a push notification to an FCM topic using the HTTP v1 API.
     */
    public function sendPush(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'message' => 'required|string',
            'topic' => 'required|string',
        ]);

        try {
            $serviceAccountKeyFile = strtolower('/home/solveit/backend.solve-it.com.ng/' . env('APP_DOMAIN') . '/storage/app/public/firebase.json');
            $accessToken = $this->getAccessToken($serviceAccountKeyFile);

            $cleanBody = strip_tags(str_replace('</p>', ', ', $validated['message']));
            $url = 'https://fcm.googleapis.com/v1/projects/' . env('FIREBASE_PROJECT_ID') . '/messages:send';

            $message = [
                'message' => [
                    'topic' => $validated['topic'],
                    'notification' => [
                        'title' => $validated['title'],
                        'body' => $cleanBody,
                    ],
                    'android' => [ 'priority' => 'high' ],
                    'apns' => [ 'headers' => [ 'apns-priority' => '10' ] ],
                ],
            ];

            $client = new Client();
            $response = $client->post($url, [
                'headers' => [
                    'Authorization' => 'Bearer ' . $accessToken,
                    'Content-Type'  => 'application/json',
                ],
                'json' => $message,
                'timeout' => 15,
            ]);

            // Log admin notification
            AdminNotification::create([
                'user_id' => auth()->id(),
                'type' => 'push',
                'title' => $validated['title'],
                'message' => $validated['message'],
                'data' => [ 'topic' => $validated['topic'] ],
                'recipients_count' => 0,
                'delivered_count' => 0,
                'failed_count' => 0,
            ]);

            return $this->success([
                'fcm_response' => json_decode((string) $response->getBody(), true)
            ], 'Push notification sent');
        } catch (\Throwable $e) {
            return $this->error('Failed to send push notification: ' . $e->getMessage(), 500);
        }
    }

    private function getAccessToken(string $serviceAccountKeyFile): string
    {
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

        $client = new Client();
        $response = $client->post('https://oauth2.googleapis.com/token', [
            'form_params' => [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $assertion,
            ],
            'timeout' => 15,
        ]);

        $body = json_decode((string) $response->getBody(), true);
        return $body['access_token'];
    }

    private function jwtEncode(array $payload, string $privateKey): string
    {
        $header = $this->base64UrlEncode(json_encode(['alg' => 'RS256', 'typ' => 'JWT']));
        $payload = $this->base64UrlEncode(json_encode($payload));
        $data = $header . '.' . $payload;

        openssl_sign($data, $signature, $privateKey, 'SHA256');
        $signature = $this->base64UrlEncode($signature);

        return $data . '.' . $signature;
    }

    private function base64UrlEncode(string $data): string
    {
        return str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($data));
    }

    /**
     * Send chat message notification
     */
    public function sendChatNotification(Request $request)
    {
        $validated = $request->validate([
            'receiver_id' => 'required|integer|exists:users,id',
            'sender_id' => 'required|integer|exists:users,id',
            'message' => 'required|string',
            'conversation_id' => 'nullable|integer|exists:conversations,id',
        ]);

        $notificationService = new NotificationService();
        $result = $notificationService->sendChatNotification(
            $validated['receiver_id'],
            $validated['sender_id'],
            $validated['message'],
            $validated['conversation_id'] ?? null
        );

        if ($result) {
            return $this->success(['sent' => true], 'Chat notification sent successfully');
        }

        return $this->error('Failed to send chat notification', 500);
    }

    /**
     * Send forum message notification
     */
    public function sendForumMessageNotification(Request $request)
    {
        $validated = $request->validate([
            'forum_id' => 'required|integer|exists:forums,id',
            'sender_id' => 'required|integer|exists:users,id',
            'message' => 'required|string',
        ]);

        $notificationService = new NotificationService();
        $sentCount = $notificationService->sendForumMessageNotification(
            $validated['forum_id'],
            $validated['sender_id'],
            $validated['message']
        );

        return $this->success(['sent_count' => $sentCount], "Forum message notification sent to {$sentCount} members");
    }

    /**
     * Send post comment notification
     */
    public function sendPostCommentNotification(Request $request)
    {
        $validated = $request->validate([
            'post_id' => 'required|integer|exists:posts,id',
            'commenter_id' => 'required|integer|exists:users,id',
            'comment' => 'required|string',
        ]);

        $notificationService = new NotificationService();
        $result = $notificationService->sendPostCommentNotification(
            $validated['post_id'],
            $validated['commenter_id'],
            $validated['comment']
        );

        if ($result) {
            return $this->success(['sent' => true], 'Post comment notification sent successfully');
        }

        return $this->error('Failed to send post comment notification', 500);
    }

    /**
     * Send post like notification
     */
    public function sendPostLikeNotification(Request $request)
    {
        $validated = $request->validate([
            'post_id' => 'required|integer|exists:posts,id',
            'liker_id' => 'required|integer|exists:users,id',
        ]);

        $notificationService = new NotificationService();
        $result = $notificationService->sendPostLikeNotification(
            $validated['post_id'],
            $validated['liker_id']
        );

        if ($result) {
            return $this->success(['sent' => true], 'Post like notification sent successfully');
        }

        return $this->error('Failed to send post like notification', 500);
    }

    /**
     * Send comment like notification
     */
    public function sendCommentLikeNotification(Request $request)
    {
        $validated = $request->validate([
            'comment_id' => 'required|integer|exists:comments,id',
            'liker_id' => 'required|integer|exists:users,id',
        ]);

        $notificationService = new NotificationService();
        $result = $notificationService->sendCommentLikeNotification(
            $validated['comment_id'],
            $validated['liker_id']
        );

        if ($result) {
            return $this->success(['sent' => true], 'Comment like notification sent successfully');
        }

        return $this->error('Failed to send comment like notification', 500);
    }

    /**
     * Send forum join notification
     */
    public function sendForumJoinNotification(Request $request)
    {
        $validated = $request->validate([
            'forum_id' => 'required|integer|exists:forums,id',
            'new_member_id' => 'required|integer|exists:users,id',
        ]);

        $notificationService = new NotificationService();
        $sentCount = $notificationService->sendForumJoinNotification(
            $validated['forum_id'],
            $validated['new_member_id']
        );

        return $this->success(['sent_count' => $sentCount], "Forum join notification sent to {$sentCount} members");
    }

    /**
     * Send reply like notification
     */
    public function sendReplyLikeNotification(Request $request)
    {
        $validated = $request->validate([
            'reply_id' => 'required|integer|exists:forum_messages,id',
            'liker_id' => 'required|integer|exists:users,id',
        ]);

        $notificationService = new NotificationService();
        $result = $notificationService->sendReplyLikeNotification(
            $validated['reply_id'],
            $validated['liker_id']
        );

        if ($result) {
            return $this->success(['sent' => true], 'Reply like notification sent successfully');
        }

        return $this->error('Failed to send reply like notification', 500);
    }

    /**
     * Send custom topic notification to a specific user
     */
    public function sendUserTopicNotification(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|integer|exists:users,id',
            'title' => 'required|string|max:255',
            'message' => 'required|string',
            'data' => 'nullable|array',
        ]);

        $notificationService = new NotificationService();
        $result = $notificationService->sendTopicNotification(
            $validated['user_id'],
            $validated['title'],
            $validated['message'],
            $validated['data'] ?? []
        );

        if ($result) {
            return $this->success(['sent' => true], 'Topic notification sent successfully');
        }

        return $this->error('Failed to send topic notification', 500);
    }
}









