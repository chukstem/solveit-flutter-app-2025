<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\School;
use App\Models\Post;
use App\Models\PostCategory;
use App\Models\User;
use App\Models\Forum;
use App\Models\Product;
use App\Models\Service;
use App\Models\UserVerification;

class DashboardController extends Controller
{
    /**
     * Get dashboard statistics.
     */
    public function getStats()
    {
        $stats = [
            'total_users' => User::count(),
            'total_schools' => School::count(),
            'total_posts' => Post::count(),
            'total_categories' => PostCategory::count(),
            'total_forums' => Forum::count(),
            'total_products' => Product::count(),
            'total_services' => Service::count(),
            'verified_users' => User::where('is_verified', true)->count(),
            'blocked_users' => User::where('is_active', false)->count(),
            'deleted_users' => User::where('is_deleted', true)->count(),
            'pending_kyc' => User::whereHas('verification', function ($query) {
                $query->where('bvn_verification_status', 'pending')
                      ->orWhere('id_card_verification_status', 'pending')
                      ->orWhere('selfie_verification_status', 'pending');
            })->count(),
            'recent_users' => User::latest()->take(5)->get(['id', 'name', 'email', 'created_at']),
            'recent_posts' => Post::with('user')->latest()->take(5)->get(['id', 'title', 'user_id', 'created_at']),
        ];

        return $this->success($stats);
    }
}


