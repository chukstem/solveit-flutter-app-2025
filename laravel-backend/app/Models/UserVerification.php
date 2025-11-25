<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserVerification extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'user_id',
        // BVN Verification fields
        'bvn_number',
        'bvn_first_name',
        'bvn_middle_name',
        'bvn_surname',
        'bvn_date_of_birth',
        'bvn_verification_status',
        'bvn_rejection_reason',
        'bvn_verified_at',
        // ID Card Verification fields
        'id_card_type',
        'id_card_number',
        'id_card_front_image',
        'id_card_back_image',
        'id_card_verification_status',
        'id_card_rejection_reason',
        'id_card_verified_at',
        // Selfie Verification fields
        'selfie_image',
        'selfie_verification_status',
        'selfie_rejection_reason',
        'selfie_verified_at',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'bvn_date_of_birth' => 'date',
            'bvn_verified_at' => 'datetime',
            'id_card_verified_at' => 'datetime',
            'selfie_verified_at' => 'datetime',
        ];
    }

    /**
     * Get the user that owns the verification.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Check if BVN is verified.
     */
    public function isBvnVerified()
    {
        return $this->bvn_verification_status === 'verified';
    }

    /**
     * Check if ID Card is verified.
     */
    public function isIdCardVerified()
    {
        return $this->id_card_verification_status === 'verified';
    }

    /**
     * Check if Selfie is verified.
     */
    public function isSelfieVerified()
    {
        return $this->selfie_verification_status === 'verified';
    }

    /**
     * Check if all verifications are complete.
     */
    public function isFullyVerified()
    {
        return $this->isBvnVerified() && $this->isIdCardVerified() && $this->isSelfieVerified();
    }

    /**
     * Get verification status summary.
     */
    public function getVerificationStatus()
    {
        return [
            'bvn' => [
                'status' => $this->bvn_verification_status,
                'verified_at' => $this->bvn_verified_at,
                'rejection_reason' => $this->bvn_rejection_reason,
                'is_verified' => $this->isBvnVerified(),
            ],
            'id_card' => [
                'status' => $this->id_card_verification_status,
                'verified_at' => $this->id_card_verified_at,
                'rejection_reason' => $this->id_card_rejection_reason,
                'is_verified' => $this->isIdCardVerified(),
            ],
            'selfie' => [
                'status' => $this->selfie_verification_status,
                'verified_at' => $this->selfie_verified_at,
                'rejection_reason' => $this->selfie_rejection_reason,
                'is_verified' => $this->isSelfieVerified(),
            ],
            'is_fully_verified' => $this->isFullyVerified(),
        ];
    }

    /**
     * Check if user can perform new verification for a specific type.
     */
    public function canPerformVerification($type)
    {
        switch ($type) {
            case 'bvn':
                return $this->bvn_verification_status === 'not_started' || $this->bvn_verification_status === 'rejected';
            case 'id_card':
                return $this->id_card_verification_status === 'not_started' || $this->id_card_verification_status === 'rejected';
            case 'selfie':
                return $this->selfie_verification_status === 'not_started' || $this->selfie_verification_status === 'rejected';
            default:
                return false;
        }
    }

    /**
     * Get or create verification record for a user.
     */
    public static function getOrCreateForUser($userId)
    {
        return static::firstOrCreate(
            ['user_id' => $userId],
            [
                'bvn_verification_status' => 'not_started',
                'id_card_verification_status' => 'not_started',
                'selfie_verification_status' => 'not_started',
            ]
        );
    }
}
