<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserSetting extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'notify_new_articles',
        'notify_orders',
        'notify_services',
        'notify_transactions',
        'notify_marketplace',
        'notify_forums',
        'email_new_articles',
        'email_orders',
        'email_services',
    ];

    protected $casts = [
        'notify_new_articles' => 'boolean',
        'notify_orders' => 'boolean',
        'notify_services' => 'boolean',
        'notify_transactions' => 'boolean',
        'notify_marketplace' => 'boolean',
        'notify_forums' => 'boolean',
        'email_new_articles' => 'boolean',
        'email_orders' => 'boolean',
        'email_services' => 'boolean',
    ];

    /**
     * Get the user that owns the settings.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}

