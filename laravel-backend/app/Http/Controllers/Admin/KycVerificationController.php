<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class KycVerificationController extends Controller
{
    /**
     * Display KYC verification management page.
     */
    public function index()
    {
        return view('admin.kyc.verifications');
    }

    /**
     * Display user verification details page.
     */
    public function viewUserDetails($userId)
    {
        $user = User::with(['school', 'faculty', 'department', 'level', 'verification'])
                   ->findOrFail($userId);

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

        return view('admin.kyc.details', [
            'user' => $user,
            'verificationStatus' => $user->getVerificationStatus(),
            'verificationDetails' => $verificationDetails,
        ]);
    }
}
