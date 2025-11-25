<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class Service extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia;

    protected $fillable = [
        'user_id',
        'category_id',
        'name',
        'description',
        'price',
        'duration',
        'location',
        'is_available',
        'is_featured',
        'views_count',
        'bookings_count',
        'rating',
        'reviews_count',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'is_available' => 'boolean',
        'is_featured' => 'boolean',
        'views_count' => 'integer',
        'bookings_count' => 'integer',
        'rating' => 'decimal:2',
        'reviews_count' => 'integer',
    ];

    /**
     * Get the user that owns the service.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the category that owns the service.
     */
    public function category()
    {
        return $this->belongsTo(ServiceCategory::class, 'category_id');
    }

    /**
     * Get the bookings for the service.
     */
    public function bookings()
    {
        return $this->hasMany(ServiceBooking::class);
    }

    /**
     * Get the ratings for the service.
     */
    public function ratings()
    {
        return $this->hasMany(ServiceRating::class);
    }

    /**
     * Get the payments for the service.
     */
    public function payments()
    {
        return $this->hasMany(ServicePayment::class);
    }

    /**
     * Register media collections for the service.
     */
    public function registerMediaCollections(): void
    {
        $this->addMediaCollection('images')
            ->acceptsMimeTypes(['image/jpeg', 'image/png', 'image/gif']);
    }

    /**
     * Register media conversions for the service.
     */
    public function registerMediaConversions(Media $media = null): void
    {
        $this->addMediaConversion('thumb')
            ->width(200)
            ->height(200)
            ->sharpen(10);

        $this->addMediaConversion('medium')
            ->width(400)
            ->height(400)
            ->sharpen(10);
    }

    /**
     * Get the service's images.
     */
    public function getImagesAttribute()
    {
        return $this->getMedia('images');
    }

    /**
     * Get the service's thumbnail.
     */
    public function getThumbnailAttribute()
    {
        return $this->getFirstMediaUrl('images', 'thumb');
    }
}
