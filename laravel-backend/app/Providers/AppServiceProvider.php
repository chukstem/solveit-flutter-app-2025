<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Schema;
use Spatie\Permission\PermissionServiceProvider;
use App\Models\Message;
use App\Models\ForumMessage;
use App\Models\Comment;
use App\Models\ForumMember;
use App\Models\Reaction;
use App\Observers\MessageObserver;
use App\Observers\ForumMessageObserver;
use App\Observers\CommentObserver;
use App\Observers\ForumMemberObserver;
use App\Observers\ReactionObserver;
use App\Services\NotificationService;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Set default string length for MySQL
        Schema::defaultStringLength(191);
        
        // Register Spatie Permission
        $this->app->register(PermissionServiceProvider::class);
        
        // Register Laravel Sanctum
        $this->app->register(\Laravel\Sanctum\SanctumServiceProvider::class);

        // Register model observers for automatic notifications
        $this->registerObservers();
    }

    /**
     * Register model observers
     */
    private function registerObservers(): void
    {
        $notificationService = $this->app->make(NotificationService::class);

        Message::observe(new MessageObserver($notificationService));
        ForumMessage::observe(new ForumMessageObserver($notificationService));
        Comment::observe(new CommentObserver($notificationService));
        ForumMember::observe(new ForumMemberObserver($notificationService));
        Reaction::observe(new ReactionObserver($notificationService));
    }
}
