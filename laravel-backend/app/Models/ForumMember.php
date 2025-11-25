<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ForumMember extends Model
{
    use HasFactory;

    protected $fillable = [
        'forum_id',
        'user_id',
        'role',
        'muted',
        'last_read_at',
    ];

    protected $casts = [
        'muted' => 'boolean',
        'last_read_at' => 'datetime',
    ];

    /**
     * Get the forum.
     */
    public function forum()
    {
        return $this->belongsTo(Forum::class);
    }

    /**
     * Get the user.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Mark forum as read.
     */
    public function markAsRead()
    {
        $this->update(['last_read_at' => now()]);
    }
}

