<?php

namespace Database\Seeders;

use App\Models\Notification;
use App\Models\User;
use Illuminate\Database\Seeder;

class NotificationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Get first user (or create if none exists)
        $user = User::first();
        
        if (!$user) {
            echo "No users found. Please create a user first.\n";
            return;
        }

        $notifications = [
            [
                'user_id' => $user->id,
                'type' => 'post_like',
                'title' => 'MalvinNice',
                'message' => 'liked your post about "How to solve mathematical problems"',
                'icon' => 'favorite',
                'icon_color' => '#E91E63',
                'data' => [
                    'post_id' => 1,
                    'user_id' => 2,
                ],
                'is_read' => false,
                'created_at' => now(),
            ],
            [
                'user_id' => $user->id,
                'type' => 'post_comment',
                'title' => 'JohnDoe',
                'message' => 'commented on your post: "Great explanation! Very helpful."',
                'icon' => 'comment',
                'icon_color' => '#2196F3',
                'data' => [
                    'post_id' => 1,
                    'comment_id' => 5,
                    'user_id' => 3,
                ],
                'is_read' => false,
                'created_at' => now()->subHours(2),
            ],
            [
                'user_id' => $user->id,
                'type' => 'follow',
                'title' => 'SarahSmith',
                'message' => 'started following you',
                'icon' => 'person_add',
                'icon_color' => '#4CAF50',
                'data' => [
                    'user_id' => 4,
                ],
                'is_read' => false,
                'created_at' => now()->subHours(5),
            ],
            [
                'user_id' => $user->id,
                'type' => 'post_reply',
                'title' => 'AlexBrown',
                'message' => 'replied to your comment',
                'icon' => 'reply',
                'icon_color' => '#FF9800',
                'data' => [
                    'post_id' => 2,
                    'comment_id' => 10,
                    'user_id' => 5,
                ],
                'is_read' => true,
                'read_at' => now()->subHours(3),
                'created_at' => now()->subDay(),
            ],
            [
                'user_id' => $user->id,
                'type' => 'mention',
                'title' => 'EmmaWilson',
                'message' => 'mentioned you in a post',
                'icon' => 'alternate_email',
                'icon_color' => '#9C27B0',
                'data' => [
                    'post_id' => 3,
                    'user_id' => 6,
                ],
                'is_read' => true,
                'read_at' => now()->subDay(),
                'created_at' => now()->subDays(2),
            ],
            [
                'user_id' => $user->id,
                'type' => 'system',
                'title' => 'System Update',
                'message' => 'New features are now available! Check out the latest updates.',
                'icon' => 'notification_important',
                'icon_color' => '#FF5722',
                'data' => [
                    'version' => '2.0.0',
                    'url' => '/updates',
                ],
                'is_read' => false,
                'created_at' => now()->subDays(3),
            ],
            [
                'user_id' => $user->id,
                'type' => 'post_like',
                'title' => 'MichaelJones',
                'message' => 'and 5 others liked your post',
                'icon' => 'favorite',
                'icon_color' => '#E91E63',
                'data' => [
                    'post_id' => 4,
                    'user_ids' => [7, 8, 9, 10, 11],
                ],
                'is_read' => false,
                'created_at' => now()->subDays(4),
            ],
            [
                'user_id' => $user->id,
                'type' => 'achievement',
                'title' => 'Achievement Unlocked!',
                'message' => 'You received 100 likes on your posts',
                'icon' => 'emoji_events',
                'icon_color' => '#FFC107',
                'data' => [
                    'achievement' => '100_likes',
                ],
                'is_read' => false,
                'created_at' => now()->subDays(5),
            ],
            [
                'user_id' => $user->id,
                'type' => 'marketplace',
                'title' => 'New Product Available',
                'message' => 'A seller posted a new product you might be interested in',
                'icon' => 'storefront',
                'icon_color' => '#FF9800',
                'data' => [
                    'product_id' => 15,
                ],
                'is_read' => true,
                'read_at' => now()->subDays(4),
                'created_at' => now()->subDays(6),
            ],
            [
                'user_id' => $user->id,
                'type' => 'service',
                'title' => 'Service Request',
                'message' => 'Someone requested your tutoring service',
                'icon' => 'business_center',
                'icon_color' => '#9C27B0',
                'data' => [
                    'service_id' => 8,
                    'user_id' => 12,
                ],
                'is_read' => false,
                'created_at' => now()->subDays(7),
            ],
        ];

        foreach ($notifications as $notification) {
            Notification::create($notification);
        }

        echo "Seeded " . count($notifications) . " test notifications for user: {$user->name}\n";
    }
}

