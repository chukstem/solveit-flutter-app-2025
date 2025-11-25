<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\UserVerification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class VerificationController extends Controller
{
    /**
     * Get verification status for the authenticated user.
     */
    public function getVerificationStatus()
    {
        $user = Auth::user();
        
        return $this->success([
            'verification_status' => $user->getVerificationStatus(),
            'can_perform_verification' => [
                'bvn' => $user->canPerformVerification('bvn'),
                'id_card' => $user->canPerformVerification('id_card'),
                'selfie' => $user->canPerformVerification('selfie'),
            ]
        ], 'Verification status retrieved successfully');
    }

    /**
     * Submit BVN verification.
     */
    public function submitBvnVerification(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'bvn_number' => 'required|string|size:11|regex:/^[0-9]+$/',
            'bvn_first_name' => 'required|string|max:255',
            'bvn_middle_name' => 'nullable|string|max:255',
            'bvn_surname' => 'required|string|max:255',
            'bvn_date_of_birth' => 'required|date|before:today',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = Auth::user();

        // Check if user can perform BVN verification
        if (!$user->canPerformVerification('bvn')) {
            return $this->error('BVN verification is already verified or in progress', 400);
        }

        // Get or create verification record
        $verification = $user->getOrCreateVerification();

        // Update verification with BVN information
        $verification->update([
            'bvn_number' => $request->bvn_number,
            'bvn_first_name' => $request->bvn_first_name,
            'bvn_middle_name' => $request->bvn_middle_name,
            'bvn_surname' => $request->bvn_surname,
            'bvn_date_of_birth' => $request->bvn_date_of_birth,
            'bvn_verification_status' => 'pending',
            'bvn_rejection_reason' => null,
        ]);
 

        return $this->success([
            'verification_status' => $user->getVerificationStatus(),
            'message' => 'BVN verification submitted successfully'
        ], 'BVN verification submitted successfully');
    }

    /**
     * Submit ID Card verification.
     */
    public function submitIdCardVerification(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'id_card_type' => 'required|string|in:national_id,driver_license,passport,voter_card',
            'id_card_number' => 'required|string|max:255',
            'id_card_front_image' => 'required|image|mimes:jpeg,png,jpg|max:5120', // 5MB max
            'id_card_back_image' => 'required|image|mimes:jpeg,png,jpg|max:5120', // 5MB max
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = Auth::user();

        // Check if user can perform ID Card verification
        if (!$user->canPerformVerification('id_card')) {
            return $this->error('ID Card verification is already verified or in progress', 400);
        }

        try {
            // Store the uploaded images
            $frontImagePath = $this->storeVerificationImage($request->file('id_card_front_image'), 'id_cards');
            $backImagePath = $this->storeVerificationImage($request->file('id_card_back_image'), 'id_cards');

            // Get or create verification record
            $verification = $user->getOrCreateVerification();

            // Update verification with ID Card information
            $verification->update([
                'id_card_type' => $request->id_card_type,
                'id_card_number' => $request->id_card_number,
                'id_card_front_image' => $frontImagePath,
                'id_card_back_image' => $backImagePath,
                'id_card_verification_status' => 'pending',
                'id_card_rejection_reason' => null,
            ]);
 

            return $this->success([
                'verification_status' => $user->getVerificationStatus(),
                'message' => 'ID Card verification submitted successfully'
            ], 'ID Card verification submitted successfully');

        } catch (\Exception $e) {
            return $this->error('Failed to upload images: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Submit Selfie verification.
     */
    public function submitSelfieVerification(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'selfie_image' => 'required|image|mimes:jpeg,png,jpg|max:5120', // 5MB max
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = Auth::user();

        // Check if user can perform Selfie verification
        if (!$user->canPerformVerification('selfie')) {
            return $this->error('Selfie verification is already verified or in progress', 400);
        }

        try {
            // Store the uploaded selfie image
            $selfieImagePath = $this->storeVerificationImage($request->file('selfie_image'), 'selfies');

            // Get or create verification record
            $verification = $user->getOrCreateVerification();

            // Update verification with Selfie information
            $verification->update([
                'selfie_image' => $selfieImagePath,
                'selfie_verification_status' => 'pending',
                'selfie_rejection_reason' => null,
            ]);
 

            return $this->success([
                'verification_status' => $user->getVerificationStatus(),
                'message' => 'Selfie verification submitted successfully'
            ], 'Selfie verification submitted successfully');

        } catch (\Exception $e) {
            return $this->error('Failed to upload selfie: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Store verification image and return the path.
     */
    private function storeVerificationImage($file, $folder)
    {
        $filename = Str::uuid() . '.' . $file->getClientOriginalExtension();
        $path = $file->storeAs("verification/{$folder}", $filename, 'public');
        return $path;
    }

    

     

    

    /**
     * Admin: Update verification status (for admin panel).
     */
    public function updateVerificationStatus(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'verification_type' => 'required|in:bvn,id_card,selfie',
            'status' => 'required|in:verified,rejected',
            'rejection_reason' => 'required_if:status,rejected|nullable|string|max:1000',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        // Check if user is admin
        $admin = Auth::user();
        if (!$admin->isAdmin()) {
            return $this->error('Unauthorized. Admin access required.', 403);
        }

        $user = User::findOrFail($request->user_id);
        $verification = $user->getOrCreateVerification();
        $verificationType = $request->verification_type;
        $status = $request->status;

        $updateData = [
            "{$verificationType}_verification_status" => $status,
        ];

        if ($status === 'verified') {
            $updateData["{$verificationType}_verified_at"] = now();
            $updateData["{$verificationType}_rejection_reason"] = null;
        } else {
            $updateData["{$verificationType}_rejection_reason"] = $request->rejection_reason;
        }

        $verification->update($updateData);

        return $this->success([
            'verification_status' => $user->getVerificationStatus(),
            'message' => ucfirst($verificationType) . ' verification status updated successfully'
        ], 'Verification status updated successfully');
    }

    /**
     * Admin: Get all pending verifications.
     */
    public function getPendingVerifications()
    {
        // Check if user is admin
        $admin = Auth::user();
        if (!$admin->isAdmin()) {
            return $this->error('Unauthorized. Admin access required.', 403);
        }

        $users = User::whereHas('verification', function ($query) {
            $query->where('bvn_verification_status', 'pending')
                  ->orWhere('id_card_verification_status', 'pending')
                  ->orWhere('selfie_verification_status', 'pending');
        })->with(['school', 'faculty', 'department', 'level', 'verification'])
          ->get();

        $pendingVerifications = $users->map(function ($user) {
            return [
                'user' => $user->only(['id', 'name', 'email', 'phone', 'school', 'faculty', 'department', 'level']),
                'verification_status' => $user->getVerificationStatus(),
            ];
        });

        return $this->success([
            'pending_verifications' => $pendingVerifications,
            'total_count' => $pendingVerifications->count()
        ], 'Pending verifications retrieved successfully');
    }

    /**
     * Admin: Get all verifications with filtering and pagination.
     */
    public function getAllVerifications(Request $request)
    {
        // Check if user is admin
        $admin = Auth::user();
        if (!$admin->isAdmin()) {
            return $this->error('Unauthorized. Admin access required.', 403);
        }

        $query = User::with(['school', 'faculty', 'department', 'level', 'verification']);

        // Apply filters
        if ($request->has('status')) {
            $status = $request->status;
            $query->whereHas('verification', function ($q) use ($status) {
                $q->where('bvn_verification_status', $status)
                  ->orWhere('id_card_verification_status', $status)
                  ->orWhere('selfie_verification_status', $status);
            });
        }

        if ($request->has('verification_type')) {
            $type = $request->verification_type;
            $query->whereHas('verification', function ($q) use ($type) {
                $q->where("{$type}_verification_status", '!=', 'not_started');
            });
        }

        // Default: Show users with pending verifications if no specific filters
        if (!$request->has('status') && !$request->has('verification_type') && !$request->has('search')) {
            $query->whereHas('verification', function ($q) {
                $q->where('bvn_verification_status', 'pending')
                  ->orWhere('id_card_verification_status', 'pending')
                  ->orWhere('selfie_verification_status', 'pending');
            });
        }

        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        // Pagination
        $perPage = $request->get('per_page', 15);
        $verifications = $query->paginate($perPage);

        $formattedVerifications = $verifications->map(function ($user) {
            return [
                'user' => $user->only(['id', 'name', 'email', 'phone', 'school', 'faculty', 'department', 'level']),
                'verification_status' => $user->getVerificationStatus(),
                'verification_details' => $user->verification ? [
                    'bvn' => [
                        'number' => $user->verification->bvn_number,
                        'first_name' => $user->verification->bvn_first_name,
                        'middle_name' => $user->verification->bvn_middle_name,
                        'surname' => $user->verification->bvn_surname,
                        'date_of_birth' => $user->verification->bvn_date_of_birth,
                        'status' => $user->verification->bvn_verification_status,
                        'rejection_reason' => $user->verification->bvn_rejection_reason,
                        'verified_at' => $user->verification->bvn_verified_at,
                    ],
                    'id_card' => [
                        'type' => $user->verification->id_card_type,
                        'number' => $user->verification->id_card_number,
                        'front_image' => $user->verification->id_card_front_image,
                        'back_image' => $user->verification->id_card_back_image,
                        'status' => $user->verification->id_card_verification_status,
                        'rejection_reason' => $user->verification->id_card_rejection_reason,
                        'verified_at' => $user->verification->id_card_verified_at,
                    ],
                    'selfie' => [
                        'image' => $user->verification->selfie_image,
                        'status' => $user->verification->selfie_verification_status,
                        'rejection_reason' => $user->verification->selfie_rejection_reason,
                        'verified_at' => $user->verification->selfie_verified_at,
                    ],
                ] : null,
            ];
        });

        return $this->success([
            'verifications' => $formattedVerifications,
            'pagination' => [
                'current_page' => $verifications->currentPage(),
                'last_page' => $verifications->lastPage(),
                'per_page' => $verifications->perPage(),
                'total' => $verifications->total(),
                'from' => $verifications->firstItem(),
                'to' => $verifications->lastItem(),
            ]
        ], 'All verifications retrieved successfully');
    }

    /**
     * Admin: Get verification statistics.
     */
    public function getVerificationStats()
    {
        // Check if user is admin
        $admin = Auth::user();
        if (!$admin->isAdmin()) {
            return $this->error('Unauthorized. Admin access required.', 403);
        }

        $stats = [
            'total_users' => User::count(),
            'users_with_verification' => User::whereHas('verification')->count(),
            'bvn_stats' => [
                'pending' => UserVerification::where('bvn_verification_status', 'pending')->count(),
                'verified' => UserVerification::where('bvn_verification_status', 'verified')->count(),
                'rejected' => UserVerification::where('bvn_verification_status', 'rejected')->count(),
            ],
            'id_card_stats' => [
                'pending' => UserVerification::where('id_card_verification_status', 'pending')->count(),
                'verified' => UserVerification::where('id_card_verification_status', 'verified')->count(),
                'rejected' => UserVerification::where('id_card_verification_status', 'rejected')->count(),
            ],
            'selfie_stats' => [
                'pending' => UserVerification::where('selfie_verification_status', 'pending')->count(),
                'verified' => UserVerification::where('selfie_verification_status', 'verified')->count(),
                'rejected' => UserVerification::where('selfie_verification_status', 'rejected')->count(),
            ],
            'fully_verified_users' => User::whereHas('verification', function ($query) {
                $query->where('bvn_verification_status', 'verified')
                      ->where('id_card_verification_status', 'verified')
                      ->where('selfie_verification_status', 'verified');
            })->count(),
        ];

        return $this->success($stats, 'Verification statistics retrieved successfully');
    }

    /**
     * Admin: Bulk update verification statuses.
     */
    public function bulkUpdateVerificationStatus(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'updates' => 'required|array|min:1',
            'updates.*.user_id' => 'required|exists:users,id',
            'updates.*.verification_type' => 'required|in:bvn,id_card,selfie',
            'updates.*.status' => 'required|in:verified,rejected',
            'updates.*.rejection_reason' => 'required_if:updates.*.status,rejected|nullable|string|max:1000',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        // Check if user is admin
        $admin = Auth::user();
        if (!$admin->isAdmin()) {
            return $this->error('Unauthorized. Admin access required.', 403);
        }

        $results = [];
        $successCount = 0;
        $errorCount = 0;

        foreach ($request->updates as $update) {
            try {
                $user = User::findOrFail($update['user_id']);
                $verification = $user->getOrCreateVerification();
                $verificationType = $update['verification_type'];
                $status = $update['status'];

                $updateData = [
                    "{$verificationType}_verification_status" => $status,
                ];

                if ($status === 'verified') {
                    $updateData["{$verificationType}_verified_at"] = now();
                    $updateData["{$verificationType}_rejection_reason"] = null;
                } else {
                    $updateData["{$verificationType}_rejection_reason"] = $update['rejection_reason'] ?? null;
                }

                $verification->update($updateData);
                $successCount++;

                $results[] = [
                    'user_id' => $user->id,
                    'verification_type' => $verificationType,
                    'status' => 'success',
                    'message' => ucfirst($verificationType) . ' verification updated successfully'
                ];
            } catch (\Exception $e) {
                $errorCount++;
                $results[] = [
                    'user_id' => $update['user_id'],
                    'verification_type' => $update['verification_type'],
                    'status' => 'error',
                    'message' => 'Failed to update verification: ' . $e->getMessage()
                ];
            }
        }

        return $this->success([
            'results' => $results,
            'summary' => [
                'total_processed' => count($request->updates),
                'successful' => $successCount,
                'failed' => $errorCount,
            ]
        ], 'Bulk update completed');
    }

    /**
     * Admin: Get verification details for a specific user.
     */
    public function getUserVerificationDetails($userId)
    {
        // Check if user is admin
        $admin = Auth::user();
        if (!$admin->isAdmin()) {
            return $this->error('Unauthorized. Admin access required.', 403);
        }

        $user = User::with(['school', 'faculty', 'department', 'level', 'verification'])->findOrFail($userId);

        $verificationDetails = null;
        if ($user->verification) {
            $verificationDetails = [
                'bvn' => [
                    'number' => $user->verification->bvn_number,
                    'first_name' => $user->verification->bvn_first_name,
                    'middle_name' => $user->verification->bvn_middle_name,
                    'surname' => $user->verification->bvn_surname,
                    'date_of_birth' => $user->verification->bvn_date_of_birth,
                    'status' => $user->verification->bvn_verification_status,
                    'rejection_reason' => $user->verification->bvn_rejection_reason,
                    'verified_at' => $user->verification->bvn_verified_at,
                    'submitted_at' => $user->verification->created_at,
                ],
                'id_card' => [
                    'type' => $user->verification->id_card_type,
                    'number' => $user->verification->id_card_number,
                    'front_image' => $user->verification->id_card_front_image,
                    'back_image' => $user->verification->id_card_back_image,
                    'status' => $user->verification->id_card_verification_status,
                    'rejection_reason' => $user->verification->id_card_rejection_reason,
                    'verified_at' => $user->verification->id_card_verified_at,
                    'submitted_at' => $user->verification->created_at,
                ],
                'selfie' => [
                    'image' => $user->verification->selfie_image,
                    'status' => $user->verification->selfie_verification_status,
                    'rejection_reason' => $user->verification->selfie_rejection_reason,
                    'verified_at' => $user->verification->selfie_verified_at,
                    'submitted_at' => $user->verification->created_at,
                ],
            ];
        }

        return $this->success([
            'user' => $user->only(['id', 'name', 'email', 'phone', 'school', 'faculty', 'department', 'level']),
            'verification_status' => $user->getVerificationStatus(),
            'verification_details' => $verificationDetails,
        ], 'User verification details retrieved successfully');
    }
}
