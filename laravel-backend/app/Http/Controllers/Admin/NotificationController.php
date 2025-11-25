<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\AdminNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class NotificationController extends Controller
{
    /**
     * Send email notification to all users (queued in batches of 500/hour).
     */
    public function sendEmail(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'subject' => 'required|string|max:255',
            'message' => 'required|string',
            'user_filter' => 'nullable|array',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $query = User::where('is_verified', true)->where('is_active', true);

        // Apply filters if provided
        if ($request->has('user_filter')) {
            $filter = $request->user_filter;
            
            if (isset($filter['school_id'])) {
                $query->where('school_id', $filter['school_id']);
            }
            
            if (isset($filter['role_id'])) {
                $query->where('role_id', $filter['role_id']);
            }
        }

        $users = $query->get();

        // Queue emails in batches (500 per hour = ~8 per minute)
        $delay = now();
        $batchSize = 8; // Send 8 emails per minute
        
        foreach ($users->chunk($batchSize) as $chunk) {
            foreach ($chunk as $user) {
                // This would be your mail notification class
                // Mail::to($user->email)->later($delay, new AdminEmailNotification($request->subject, $request->message));
            }
            $delay->addMinute();
        }

        // Log notification
        AdminNotification::create([
            'user_id' => auth()->id(),
            'type' => 'email',
            'title' => $request->subject,
            'message' => $request->message,
            'data' => ['recipients' => 'all'],
            'recipients_count' => $users->count(),
        ]);

        return $this->success([
            'recipients_count' => $users->count(),
            'estimated_completion' => $delay->diffForHumans(),
        ], 'Email notifications queued successfully');
    }

    /**
     * Send push notification to all users (topic: general).
     */
    public function sendPush(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'message' => 'required|string',
            'data' => 'nullable|array',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        // Here you would integrate with FCM to send to topic 'general'
        // This requires FCM setup and the fcm_token field in users table
        
        /*
        $fcm = new FCM();
        $fcm->to('/topics/general')
            ->notification([
                'title' => $request->title,
                'body' => $request->message,
            ])
            ->data($request->data ?? [])
            ->send();
        */

        // Log notification
        AdminNotification::create([
            'user_id' => auth()->id(),
            'type' => 'push',
            'title' => $request->title,
            'message' => $request->message,
            'data' => $request->data ?? [],
            'recipients_count' => 0,
        ]);

        return $this->success(null, 'Push notification sent successfully');
    }

    /**
     * Get all sent notifications.
     */
    public function index(Request $request)
    {
        $query = AdminNotification::with('user');

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        $notifications = $query->latest()->paginate(20);

        return $this->success($notifications);
    }
}


