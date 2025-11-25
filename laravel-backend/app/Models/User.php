<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

class User extends Authenticatable implements HasMedia
{
    use HasFactory, Notifiable, HasApiTokens, HasRoles, InteractsWithMedia;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'phone',
        'password',
        'dob',
        'gender',
        'school_id',
        'faculty_id',
        'department_id',
        'level_id',
        'role_id',
        'matric_number',
        'code',
        'user_category',
        'interests',
        'is_verified',
        'verification_code',
        'verification_code_expires_at',
        'last_login_at',
        'last_seen_at',
        'is_active',
        'deletion_reason',
        'deleted_at',
        'is_deleted',
        'fcm_token',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'verification_code',
    ];

    /**
     * The accessors to append to the model's array form.
     *
     * @var array
     */
    protected $appends = [
        'avatar_url',
        'is_online',
        'is_fully_verified',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'dob' => 'date',
            'verification_code_expires_at' => 'datetime',
            'last_login_at' => 'datetime',
            'last_seen_at' => 'datetime',
            'is_verified' => 'boolean',
            'is_active' => 'boolean',
            'deleted_at' => 'datetime',
            'is_deleted' => 'boolean',
        ];
    }

    /**
     * Get the school that the user belongs to.
     */
    public function school()
    {
        return $this->belongsTo(School::class);
    }

    /**
     * Get the faculty that the user belongs to.
     */
    public function faculty()
    {
        return $this->belongsTo(Faculty::class);
    }

    /**
     * Get the department that the user belongs to.
     */
    public function department()
    {
        return $this->belongsTo(Department::class);
    }

    /**
     * Get the level that the user belongs to.
     */
    public function level()
    {
        return $this->belongsTo(Level::class);
    }

    /**
     * Get the role that the user belongs to.
     */
    public function role()
    {
        return $this->belongsTo(Role::class);
    }

    /**
     * Get the posts created by the user.
     */
    public function posts()
    {
        return $this->hasMany(Post::class);
    }

    /**
     * Get the comments created by the user.
     */
    public function comments()
    {
        return $this->hasMany(Comment::class);
    }

    /**
     * Get the reactions created by the user.
     */
    public function reactions()
    {
        return $this->hasMany(Reaction::class);
    }

    /**
     * Get the products created by the user.
     */
    public function products()
    {
        return $this->hasMany(Product::class);
    }

    /**
     * Get the services created by the user.
     */
    public function services()
    {
        return $this->hasMany(Service::class);
    }

    /**
     * Get the messages sent by the user.
     */
    public function sentMessages()
    {
        return $this->hasMany(Message::class, 'sender_id');
    }

    /**
     * Get the messages received by the user.
     */
    public function receivedMessages()
    {
        return $this->hasMany(Message::class, 'receiver_id');
    }

    /**
     * Get the user's settings.
     */
    public function settings()
    {
        return $this->hasOne(UserSetting::class);
    }

    /**
     * Register media collections for the user.
     */
    public function registerMediaCollections(): void
    {
        $this->addMediaCollection('avatar')
            ->singleFile()
            ->acceptsMimeTypes(['image/jpeg', 'image/png', 'image/gif']);
    }

    /**
     * Register media conversions for the user.
     */
    public function registerMediaConversions(Media $media = null): void
    {
        $this->addMediaConversion('thumb')
            ->width(150)
            ->height(150)
            ->sharpen(10);

        $this->addMediaConversion('medium')
            ->width(300)
            ->height(300)
            ->sharpen(10);
    }

    /**
     * Get the user's avatar URL.
     */
    public function getAvatarUrlAttribute()
    {
        return $this->getFirstMediaUrl('avatar', 'thumb') ?: 
               'https://ui-avatars.com/api/?name=' . urlencode($this->name) . '&background=83074E&color=fff';
    }

    /**
     * Check if user is online.
     * User is considered online if they were active within the last 5 minutes.
     */
    public function getIsOnlineAttribute()
    {
        if (!$this->last_seen_at) {
            return false;
        }

        return $this->last_seen_at->greaterThan(now()->subMinutes(5));
    }

    /**
     * Update user's last seen timestamp.
     */
    public function updateLastSeen()
    {
        $this->update(['last_seen_at' => now()]);
    }

    /**
     * Check if user is a student.
     */
    public function isStudent()
    {
        return $this->user_category === 'student';
    }

    /**
     * Check if user is a staff.
     */
    public function isStaff()
    {
        return $this->user_category === 'staff';
    }

    /**
     * Check if user is a lecturer.
     */
    public function isLecturer()
    {
        return $this->user_category === 'lecturer';
    }

    /**
     * Check if user is an admin.
     */
    public function isAdmin()
    {
        return $this->user_category === 'admin';
    }

    /**
     * Get the posts saved/bookmarked by the user.
     */
    public function savedPosts()
    {
        return $this->belongsToMany(Post::class, 'saved_posts', 'user_id', 'post_id')
            ->withTimestamps();
    }

    /**
     * Get the user's verification record.
     */
    public function verification()
    {
        return $this->hasOne(UserVerification::class);
    }

    /**
     * Check if BVN is verified.
     */
    public function isBvnVerified()
    {
        return $this->verification?->isBvnVerified() ?? false;
    }

    /**
     * Check if ID Card is verified.
     */
    public function isIdCardVerified()
    {
        return $this->verification?->isIdCardVerified() ?? false;
    }

    /**
     * Check if Selfie is verified.
     */
    public function isSelfieVerified()
    {
        return $this->verification?->isSelfieVerified() ?? false;
    }

    /**
     * Check if all verifications are complete.
     */
    public function isFullyVerified()
    {
        return $this->verification?->isFullyVerified() ?? false;
    }

    /**
     * Get verification status summary.
     */
    public function getVerificationStatus()
    {
        if (!$this->verification) {
            return [
                'bvn' => [
                    'status' => 'not_started',
                    'verified_at' => null,
                    'rejection_reason' => null,
                    'is_verified' => false,
                ],
                'id_card' => [
                    'status' => 'not_started',
                    'verified_at' => null,
                    'rejection_reason' => null,
                    'is_verified' => false,
                ],
                'selfie' => [
                    'status' => 'not_started',
                    'verified_at' => null,
                    'rejection_reason' => null,
                    'is_verified' => false,
                ],
                'is_fully_verified' => false,
            ];
        }

        return $this->verification->getVerificationStatus();
    }

    /**
     * Check if user can perform new verification for a specific type.
     */
    public function canPerformVerification($type)
    {
        if (!$this->verification) {
            return true; // Can perform if no verification record exists
        }

        return $this->verification->canPerformVerification($type);
    }

    /**
     * Get or create verification record for this user.
     */
    public function getOrCreateVerification()
    {
        return $this->verification ?? UserVerification::getOrCreateForUser($this->id);
    }

    /**
     * Get the is_fully_verified attribute.
     */
    public function getIsFullyVerifiedAttribute()
    {
        return $this->isFullyVerified();
    }
}