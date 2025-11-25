<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class Post extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia;

    protected $fillable = [
        'user_id',
        'school_id',
        'news_category_id',
        'title',
        'excerpt',
        'body',
        'tags',
        'faculties',
        'departments',
        'levels',
        'interests',
        'students',
        'staffs',
        'lecturers',
        'users',
        'featured',
        'enable_comments',
        'enable_reactions',
        'code',
        'is_published',
    ];

    protected $casts = [
        'featured' => 'boolean',
        'enable_comments' => 'boolean',
        'enable_reactions' => 'boolean',
        'is_published' => 'boolean',
        'students' => 'integer',
        'staffs' => 'integer',
        'lecturers' => 'integer',
        'users' => 'integer',
    ];

    /**
     * Get the user that owns the post.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the school that owns the post.
     */
    public function school()
    {
        return $this->belongsTo(School::class);
    }

    /**
     * Get the category that owns the post.
     */
    public function category()
    {
        return $this->belongsTo(PostCategory::class, 'news_category_id');
    }

    /**
     * Get the comments for the post.
     */
    public function comments()
    {
        return $this->hasMany(Comment::class);
    }

    /**
     * Get the reactions for the post.
     */
    public function reactions()
    {
        return $this->morphMany(Reaction::class, 'reactionable');
    }

    /**
     * Register media collections for the post.
     */
    public function registerMediaCollections(): void
    {
        $this->addMediaCollection('media')
            ->acceptsMimeTypes(['image/jpeg', 'image/png', 'image/gif', 'video/mp4']);

        $this->addMediaCollection('video')
            ->singleFile()
            ->acceptsMimeTypes(['video/mp4', 'video/avi', 'video/mov']);
    }

    /**
     * Register media conversions for the post.
     */
    public function registerMediaConversions(Media $media = null): void
    {
        $this->addMediaConversion('thumb')
            ->width(300)
            ->height(200)
            ->sharpen(10);

        $this->addMediaConversion('medium')
            ->width(600)
            ->height(400)
            ->sharpen(10);
    }

    /**
     * Get the post's media URL.
     */
    public function getMediaUrlAttribute()
    {
        return $this->getFirstMediaUrl('media');
    }

    /**
     * Get the post's video URL.
     */
    public function getVideoUrlAttribute()
    {
        return $this->getFirstMediaUrl('video');
    }

    /**
     * Get the post's thumbnail URL.
     */
    public function getThumbnailUrlAttribute()
    {
        return $this->getFirstMediaUrl('media', 'thumb');
    }
}
















