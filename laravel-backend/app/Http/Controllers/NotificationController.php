<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    /**
     * Get all notifications for authenticated user
     */
    public function index(Request $request)
    {
        $userId = auth()->id();
        $perPage = $request->get('per_page', 20);

        $notifications = Notification::where('user_id', $userId)
            ->orderBy('created_at', 'desc')
            ->paginate($perPage);

        return $this->success($notifications);
    }

    /**
     * Get unread notifications count
     */
    public function unreadCount()
    {
        $userId = auth()->id();
        $count = Notification::where('user_id', $userId)
            ->unread()
            ->count();

        return $this->success(['unread_count' => $count]);
    }

    /**
     * Mark notification as read
     */
    public function markAsRead($id)
    {
        $userId = auth()->id();
        
        $notification = Notification::where('user_id', $userId)
            ->find($id);

        if (!$notification) {
            return $this->notFound('Notification not found');
        }

        $notification->markAsRead();

        return $this->success(['message' => 'Notification marked as read']);
    }

    /**
     * Mark all notifications as read
     */
    public function markAllAsRead()
    {
        $userId = auth()->id();

        Notification::where('user_id', $userId)
            ->unread()
            ->update([
                'is_read' => true,
                'read_at' => now(),
            ]);

        return $this->success(['message' => 'All notifications marked as read']);
    }

    /**
     * Delete notification
     */
    public function destroy($id)
    {
        $userId = auth()->id();
        
        $notification = Notification::where('user_id', $userId)
            ->find($id);

        if (!$notification) {
            return $this->notFound('Notification not found');
        }

        $notification->delete();

        return $this->success(['message' => 'Notification deleted']);
    }

    /**
     * Delete all notifications
     */
    public function deleteAll()
    {
        $userId = auth()->id();

        Notification::where('user_id', $userId)->delete();

        return $this->success(['message' => 'All notifications deleted']);
    }

    /**
     * Create a notification (for testing/admin)
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'nullable|exists:users,id',
            'type' => 'required|string',
            'title' => 'required|string',
            'message' => 'required|string',
            'icon' => 'nullable|string',
            'icon_color' => 'nullable|string',
            'data' => 'nullable|array',
        ]);

        // If no user_id provided, use authenticated user
        $validated['user_id'] = $validated['user_id'] ?? auth()->id();

        $notification = Notification::create($validated);

        return $this->success($notification, 'Notification created successfully');
    }
}
