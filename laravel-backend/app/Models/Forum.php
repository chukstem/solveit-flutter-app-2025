<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class Forum extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia;

    protected $fillable = [
        'name',
        'description',
        'created_by',
        'category_id',
        'level_id',
        'is_active',
        'is_public',
        'max_members',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'is_public' => 'boolean',
        'max_members' => 'integer',
    ];

    /**
     * Boot the model.
     */
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($forum) {
            if (empty($forum->code)) {
                $forum->code = static::generateUniqueCode();
            }
        });
    }

    /**
     * Generate a unique 12-character code.
     */
    private static function generateUniqueCode()
    {
        do {
            // Generate random 12-character alphanumeric code (uppercase)
            $code = strtoupper(substr(str_shuffle('ABCDEFGHJKLMNPQRSTUVWXYZ23456789'), 0, 12));
        } while (static::where('code', $code)->exists());

        return $code;
    }

    /**
     * Get the creator of the forum.
     */
    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Get the category of the forum.
     */
    public function category()
    {
        return $this->belongsTo(\App\Models\Category::class, 'category_id');
    }

    /**
     * Get the level of the forum.
     */
    public function level()
    {
        return $this->belongsTo(Level::class, 'level_id');
    }

    /**
     * Get all members of the forum.
     */
    public function members()
    {
        return $this->hasMany(ForumMember::class);
    }

    /**
     * Get all messages in the forum.
     */
    public function messages()
    {
        return $this->hasMany(ForumMessage::class);
    }

    /**
     * Get the latest message in the forum.
     */
    public function latestMessage()
    {
        return $this->hasOne(ForumMessage::class)->latestOfMany();
    }

    /**
     * Get member count.
     */
    public function getMemberCountAttribute()
    {
        return $this->members()->count();
    }

    /**
     * Get unread count for a specific user.
     */
    public function getUnreadCount($userId)
    {
        $member = $this->members()->where('user_id', $userId)->first();
        
        if (!$member) {
            return 0;
        }

        return $this->messages()
            ->where('created_at', '>', $member->last_read_at ?? $member->created_at)
            ->where('user_id', '!=', $userId)
            ->count();
    }

    /**
     * Check if user is a member.
     */
    public function isMember($userId)
    {
        return $this->members()->where('user_id', $userId)->exists();
    }

    /**
     * Check if user is admin or moderator.
     */
    public function canModerate($userId)
    {
        return $this->members()
            ->where('user_id', $userId)
            ->whereIn('role', ['admin', 'moderator'])
            ->exists();
    }

    /**
     * Check if user is an admin of the forum.
     */
    public function isAdmin($userId)
    {
        return $this->members()
            ->where('user_id', $userId)
            ->where('role', 'admin')
            ->exists();
    }

    /**
     * Check if user is a moderator of the forum.
     */
    public function isModerator($userId)
    {
        return $this->members()
            ->where('user_id', $userId)
            ->where('role', 'moderator')
            ->exists();
    }

    /**
     * Check if user can edit the forum.
     * Admins and moderators can edit.
     */
    public function canEdit($userId)
    {
        return $this->isAdmin($userId) || $this->isModerator($userId);
    }

    /**
     * Check if user can delete the forum.
     * Only admins can delete.
     */
    public function canDelete($userId)
    {
        return $this->isAdmin($userId);
    }

    /**
     * Check if user can remove a specific member.
     * - Admins can remove anyone (including moderators)
     * - Moderators can only remove regular members
     */
    public function canRemoveMember($userId, $targetRole)
    {
        if ($this->isAdmin($userId)) {
            return true; // Admins can remove anyone
        }
        
        if ($this->isModerator($userId)) {
            return $targetRole === 'member'; // Moderators can only remove members
        }
        
        return false;
    }

    /**
     * Check if user can manage moderators (assign/remove).
     * Only admins can manage moderators.
     */
    public function canManageModerators($userId)
    {
        return $this->isAdmin($userId);
    }

    /**
     * Check if user can manage admins (assign/remove).
     * Only admins can manage other admins.
     */
    public function canManageAdmins($userId)
    {
        return $this->isAdmin($userId);
    }

    /**
     * Register media collections for the forum.
     */
    public function registerMediaCollections(): void
    {
        $this->addMediaCollection('cover')
            ->singleFile()
            ->acceptsMimeTypes(['image/jpeg', 'image/png', 'image/gif', 'image/webp']);
    }

    /**
     * Register media conversions for the forum.
     */
    public function registerMediaConversions(Media $media = null): void
    {
        $this->addMediaConversion('thumb')
            ->width(300)
            ->height(300)
            ->sharpen(10);

        $this->addMediaConversion('banner')
            ->width(1200)
            ->height(400)
            ->sharpen(10);
    }

    /**
     * Get the forum's cover image URL.
     */
    public function getCoverImageAttribute()
    {
        return $this->getFirstMediaUrl('cover');
    }

    /**
     * Get the forum's cover thumbnail URL.
     */
    public function getCoverThumbAttribute()
    {
        return $this->getFirstMediaUrl('cover', 'thumb');
    }
}

