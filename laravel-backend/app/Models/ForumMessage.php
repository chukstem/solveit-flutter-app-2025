<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class ForumMessage extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia;

    protected $fillable = [
        'forum_id',
        'user_id',
        'message',
        'reply_to_id',
        'is_edited',
        'edited_at',
    ];

    protected $casts = [
        'is_edited' => 'boolean',
        'edited_at' => 'datetime',
    ];

    /**
     * Get the forum.
     */
    public function forum()
    {
        return $this->belongsTo(Forum::class);
    }

    /**
     * Get the user who sent the message.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the message this is replying to.
     */
    public function replyTo()
    {
        return $this->belongsTo(ForumMessage::class, 'reply_to_id');
    }

    /**
     * Get replies to this message.
     */
    public function replies()
    {
        return $this->hasMany(ForumMessage::class, 'reply_to_id');
    }

    /**
     * Register media collections for the forum message.
     */
    public function registerMediaCollections(): void
    {
        $this->addMediaCollection('media')
            ->acceptsMimeTypes([
                'image/jpeg', 'image/png', 'image/gif', 'image/webp',
                'video/mp4', 'video/avi', 'video/mov', 'video/webm',
                'audio/mp3', 'audio/wav', 'audio/ogg', 'audio/aac',
                'application/pdf', 'application/msword',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                'text/plain'
            ]);
    }

    /**
     * Register media conversions for the forum message.
     */
    public function registerMediaConversions(Media $media = null): void
    {
        if ($media && $media->mime_type && str_starts_with($media->mime_type, 'image/')) {
            $this->addMediaConversion('thumb')
                ->width(200)
                ->height(200)
                ->sharpen(10);

            $this->addMediaConversion('preview')
                ->width(800)
                ->height(600)
                ->sharpen(10);
        }
    }

    /**
     * Get the message's media files.
     */
    public function getMediaFilesAttribute()
    {
        return $this->getMedia('media');
    }

    /**
     * Get media type based on the first media file.
     */
    public function getMediaTypeAttribute()
    {
        $media = $this->getMedia('media')->first();
        
        if (!$media) {
            return null;
        }

        $mimeType = $media->mime_type;
        
        if (str_starts_with($mimeType, 'image/')) {
            return 'image';
        } elseif (str_starts_with($mimeType, 'video/')) {
            return 'video';
        } elseif (str_starts_with($mimeType, 'audio/')) {
            return 'audio';
        } elseif (in_array($mimeType, ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'text/plain'])) {
            return 'document';
        }

        return 'file';
    }
}












