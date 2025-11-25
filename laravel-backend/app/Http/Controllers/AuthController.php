<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\School;
use App\Models\Role;
use App\Mail\ResetPasswordMail;
use App\Mail\VerifyEmailMail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    /**
     * Create a new AuthController instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth:sanctum', ['except' => ['login', 'register', 'verifyEmail', 'resendCode', 'forgotPassword', 'resetPassword']]);
    }

    /**
     * Login user and create token.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required_without:phone|email',
            'phone' => 'required_without:email|string',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $credentials = $request->only(['email', 'phone', 'password']);

        // If phone is provided, find user by phone
        if (isset($credentials['phone'])) {
            $user = User::where('phone', $credentials['phone'])->first();
            if ($user) {
                $credentials['email'] = $user->email;
                unset($credentials['phone']);
            }
        }

        if (!Auth::attempt($credentials)) {
            return $this->error('Invalid credentials', 401);
        }

        $user = Auth::user();
        $token = $user->createToken('auth-token')->plainTextToken;

        $message = 'Login successful';
        
        // Check if user is not verified and needs a new verification code
        if (!$user->is_verified) {
            // Check if verification code has expired or doesn't exist
            if (!$user->verification_code || 
                !$user->verification_code_expires_at || 
                $user->verification_code_expires_at < now()) {
                
                // Generate new verification code
                $newVerificationCode = rand(100000, 999999);
                $user->update([
                    'verification_code' => $newVerificationCode,
                    'verification_code_expires_at' => now()->addMinutes(30),
                ]);

                $message = 'Login successful. A new verification code has been sent to your email.';
                
                // Temporarily disabled - email service causing timeouts
                // In production, you should enable this to send the code via email
                $this->sendVerificationEmail($user);
            } else {
                $this->sendVerificationEmail($user);
                $message = 'Login successful. Please verify your email to continue.';
            }
        }

        // Update last login
        $user->update(['last_login_at' => now()]);

        return $this->success([
            'user' => $user->load(['school', 'faculty', 'department', 'level', 'role']),
            'access_token' => $token,
            'token_type' => 'Bearer',
        ], $message);
    }

    /**
     * Register a new user.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'role_id' => 'required|integer|exists:roles,id',
            'school_id' => 'required|integer|exists:schools,id',
            'faculty_id' => 'nullable|integer|exists:faculties,id',
            'department_id' => 'nullable|integer|exists:departments,id',
            'level_id' => 'nullable|integer|exists:levels,id',
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'required|string|max:20|unique:users',
            'gender' => 'required|string|in:male,female',
            'dob' => 'required|date|before:today',
            'password' => 'required|string|min:8|confirmed',
            'matric_number' => 'nullable|string|max:50',
            'interests' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        try {
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'phone' => $request->phone,
                'password' => Hash::make($request->password),
                'dob' => $request->dob,
                'gender' => $request->gender,
                'school_id' => $request->school_id,
                'faculty_id' => $request->faculty_id,
                'department_id' => $request->department_id,
                'level_id' => $request->level_id,
                'role_id' => $request->role_id,
                'matric_number' => $request->matric_number,
                'interests' => $request->interests,
                'code' => Str::random(10),
                'user_category' => $this->getUserCategory($request->role_id),
                'verification_code' => rand(100000, 999999),
                'verification_code_expires_at' => now()->addMinutes(30),
            ]);

            // Create token for new user
            $token = $user->createToken('auth-token')->plainTextToken;

            // Assign role (if Spatie Permission is configured)
            try {
                $role = Role::find($request->role_id);
                if ($role) {
                    $user->assignRole($role->name);
                }
            } catch (\Exception $e) {
                \Log::warning('Role assignment failed during registration: ' . $e->getMessage());
            }
            
            $this->sendVerificationEmail($user);

            $response = $this->success([
                'user' => $user->load(['school', 'faculty', 'department', 'level', 'role']),
                'access_token' => $token,
                'token_type' => 'Bearer',
            ], 'Registration successful');

            return $response;
        } catch (\Exception $e) {
            \Log::error('Registration failed: ' . $e->getMessage());
            return $this->error('Registration failed. Please try again.', 500);
        }
    }

    /**
     * Get the authenticated User.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function me()
    {
        $user = Auth::user();
        return $this->success($user->load(['school', 'faculty', 'department', 'level', 'role']));
    }

    /**
     * Log the user out (Revoke the token).
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout()
    {
        Auth::user()->currentAccessToken()->delete();
        return $this->success(null, 'Successfully logged out');
    }

    /**
     * Revoke all tokens (logout from all devices).
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function logoutAll()
    {
        Auth::user()->tokens()->delete();
        return $this->success(null, 'Successfully logged out from all devices');
    }

    /**
     * Verify user email.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function verifyEmail(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'verification_code' => 'required|string|size:6',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = User::where('email', $request->email)
            ->where('verification_code', $request->verification_code)
            ->where('verification_code_expires_at', '>', now())
            ->first();

        if (!$user) {
            return $this->error('Invalid or expired verification code', 400);
        }

        $user->update([
            'is_verified' => true,
            'verification_code' => null,
            'verification_code_expires_at' => null,
        ]);

        return $this->success($user, 'Email verified successfully');
    }

    /**
     * Resend verification code.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function resendCode(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
        ]);

        if ($validator->fails()) {
            Log::error($request->all());
            return $this->validationError($validator->errors());
        }

        $user = User::where('email', $request->email)->first();

        if ($user->is_verified) {
            return $this->error('Email already verified', 400);
        }

        // Generate a 6-digit numeric verification code
        $user->update([
            'verification_code' => rand(100000, 999999),
            'verification_code_expires_at' => now()->addMinutes(30),
        ]);

        $this->sendVerificationEmail($user);

        return $this->success(null, 'Verification code sent successfully');
    }

    /**
     * Send forgot password email.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function forgotPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = User::where('email', $request->email)->first();
        $resetCode = Str::random(6);

        $user->update([
            'verification_code' => $resetCode,
            'verification_code_expires_at' => now()->addMinutes(30),
        ]);

        Mail::to($user->email)->send(new ResetPasswordMail($user, $resetCode));

        return $this->success(null, 'Password reset code sent to your email');
    }

    /**
     * Reset password.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
            'verification_code' => 'required|string|size:6',
            'password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = User::where('email', $request->email)
            ->where('verification_code', $request->verification_code)
            ->where('verification_code_expires_at', '>', now())
            ->first();

        if (!$user) {
            return $this->error('Invalid or expired reset code', 400);
        }

        $user->update([
            'password' => Hash::make($request->password),
            'verification_code' => null,
            'verification_code_expires_at' => null,
        ]);

        return $this->success(null, 'Password reset successfully');
    }

    /**
     * Get all users or students.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getAllUsers(Request $request)
    {
        $isStudent = $request->boolean('is_student', false);
        
        $query = User::with(['school', 'faculty', 'department', 'level', 'role']);
        
        if ($isStudent) {
            $query->where('user_category', 'student');
        }

        $users = $query->paginate(20);

        return $this->success($users);
    }

    /**
     * Get user profile.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getUserProfile($id)
    {
        $user = User::with(['school', 'faculty', 'department', 'level', 'role'])
            ->find($id);

        if (!$user) {
            return $this->notFound('User not found');
        }

        return $this->success($user);
    }

    /**
     * Get user category based on role.
     */
    private function getUserCategory($roleId)
    {
        $role = Role::find($roleId);
        return $role ? strtolower($role->name) : 'student';
    }

    /**
     * Send verification email.
     */
    private function sendVerificationEmail($user)
    {
        try{
            Mail::to($user->email)->queue(new VerifyEmailMail($user));
        }catch(Exception $e){
            \Log::warning('Failed to send verification email: ' . $e->getMessage());
        }
    }

    /**
     * Get user's forums (forums they are a member of)
     */
    public function getUserForums()
    {
        $userId = auth()->id();
         
        
        $forumMembers = \App\Models\ForumMember::where('user_id', $userId)->get();
         
        $forums = \App\Models\ForumMember::with(['forum' => function($query) {
            $query->with(['creator', 'category', 'members' => function($memberQuery) {
                // Get first 3 members with their user data
                // Load all necessary user fields so the accessor works
                $memberQuery->with('user')
                           ->limit(3);
            }])
            ->withCount('members');
        }])
        ->where('user_id', $userId)
        ->get()
        ->filter(function ($forumMember) {
            // Filter out null forums
            return $forumMember->forum !== null;
        })
        ->map(function ($forumMember) {
            $forum = $forumMember->forum;
            
            // Get member avatars (max 3)
            $memberAvatars = $forum->members->map(function($member) {
                // The user is already loaded via eager loading
                $user = $member->user;
                return [
                    'id' => $user->id ?? null,
                    'name' => $user->name ?? 'Unknown',
                    'avatar_url' => $user ? $user->avatar_url : null, // Uses the accessor
                ];
            })->take(3)->values();
            
            return [
                'id' => $forum->id,
                'name' => $forum->name,
                'description' => $forum->description,
                'member_count' => $forum->members_count,
                'role' => $forumMember->role,
                'member_avatars' => $memberAvatars, // ✅ Added member avatars
                'category' => $forum->category ? [
                    'id' => $forum->category->id,
                    'name' => $forum->category->name,
                ] : null,
            ];
        })
        ->values(); // Re-index array after filter
 
        
        return $this->success($forums);
    }

    /**
     * Update user's level
     */
    public function updateLevel(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'level_id' => 'required|integer|exists:levels,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = auth()->user();
        $user->update(['level_id' => $request->level_id]);

        return $this->success(
            $user->load(['school', 'faculty', 'department', 'level', 'role']),
            'Level updated successfully'
        );
    }

    /**
     * Refresh user profile (get updated user data)
     */
    public function refreshProfile()
    {
        $user = auth()->user();
        return $this->success(
            $user->load(['school', 'faculty', 'department', 'level', 'role'])
        );
    }

    /**
     * Get user settings
     */
    public function getSettings()
    {
        $user = auth()->user();
        
        // Get or create user settings
        $settings = $user->settings()->firstOrCreate(
            ['user_id' => $user->id],
            [
                'notify_new_articles' => true,
                'notify_orders' => true,
                'notify_services' => true,
                'notify_transactions' => true,
                'notify_marketplace' => true,
                'notify_forums' => true,
                'email_new_articles' => true,
                'email_orders' => true,
                'email_services' => true,
            ]
        );

        return $this->success($settings);
    }

    /**
     * Update user settings
     */
    public function updateSettings(Request $request)
    {
        $validated = $request->validate([
            'notify_new_articles' => 'sometimes|boolean',
            'notify_orders' => 'sometimes|boolean',
            'notify_services' => 'sometimes|boolean',
            'notify_transactions' => 'sometimes|boolean',
            'notify_marketplace' => 'sometimes|boolean',
            'notify_forums' => 'sometimes|boolean',
            'email_new_articles' => 'sometimes|boolean',
            'email_orders' => 'sometimes|boolean',
            'email_services' => 'sometimes|boolean',
        ]);

        $user = auth()->user();
        
        // Get or create user settings
        $settings = $user->settings()->firstOrCreate(
            ['user_id' => $user->id]
        );

        // Update settings
        $settings->update($validated);

        return $this->success($settings, 'Settings updated successfully');
    }

    /**
     * Delete user account (soft delete by prefixing email and phone)
     */
    public function deleteAccount(Request $request)
    {
        $validated = $request->validate([
            'password' => 'required|string',
            'deletion_reason' => 'required|string',
        ]);

        $user = auth()->user();

        // Verify password
        if (!Hash::check($validated['password'], $user->password)) {
            return $this->error('Invalid password', 401);
        }

        try {
            // Soft delete by prefixing email and phone with "deleted@"
            if ($user->email && !str_starts_with($user->email, 'deleted@')) {
                $user->email = 'deleted@' . $user->email;
            }
            
            if ($user->phone && !str_starts_with($user->phone, 'deleted@')) {
                $user->phone = 'deleted@' . $user->phone;
            }
            
            // Mark as deleted and save reason
            $user->is_deleted = true;
            $user->deleted_at = now();
            $user->deletion_reason = $validated['deletion_reason'];
            $user->save();

            // Revoke all tokens
            $user->tokens()->delete();

            return $this->success(null, 'Account deleted successfully');
        } catch (\Exception $e) {
            \Log::error('Account deletion error: ' . $e->getMessage());
            return $this->error('Failed to delete account', 500);
        }
    }

    /**
     * Update user avatar
     */
    public function updateAvatar(Request $request)
    {
        $validated = $request->validate([
            'avatar' => 'required|image|mimes:jpeg,png,jpg,gif|max:5120', // 5MB max
        ]);

        $user = auth()->user();

        try {
            // Delete old avatar if exists
            $user->clearMediaCollection('avatar');

            // Add new avatar
            $user->addMediaFromRequest('avatar')
                ->toMediaCollection('avatar');

            // Reload user with updated avatar
            $user->refresh();

            return $this->success(
                $user->load(['school', 'faculty', 'department', 'level', 'role']),
                'Avatar updated successfully'
            );
        } catch (\Exception $e) {
            \Log::error('Avatar upload error: ' . $e->getMessage());
            return $this->error('Failed to upload avatar: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Delete user avatar
     */
    public function deleteAvatar()
    {
        $user = auth()->user();

        try {
            // Delete avatar
            $user->clearMediaCollection('avatar');

            // Reload user
            $user->refresh();

            return $this->success(
                $user->load(['school', 'faculty', 'department', 'level', 'role']),
                'Avatar deleted successfully'
            );
        } catch (\Exception $e) {
            \Log::error('Avatar delete error: ' . $e->getMessage());
            return $this->error('Failed to delete avatar: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Change user password
     */
    public function changePassword(Request $request)
    {
        $validated = $request->validate([
            'current_password' => 'required|string',
            'new_password' => 'required|string|min:8|confirmed',
        ]);

        $user = auth()->user();

        // Verify current password
        if (!Hash::check($validated['current_password'], $user->password)) {
            return $this->error('Current password is incorrect', 401);
        }

        // Check if new password is same as current
        if (Hash::check($validated['new_password'], $user->password)) {
            return $this->error('New password must be different from current password', 400);
        }

        try {
            // Update password
            $user->password = Hash::make($validated['new_password']);
            $user->save();

            // Revoke all tokens except current
            $currentToken = $user->currentAccessToken();
            $user->tokens()->where('id', '!=', $currentToken->id)->delete();

            return $this->success(null, 'Password changed successfully');
        } catch (\Exception $e) {
            \Log::error('Password change error: ' . $e->getMessage());
            return $this->error('Failed to change password', 500);
        }
    }

    /**
     * Update user's FCM token for push notifications
     */
    public function updateFcmToken(Request $request)
    {
        $validated = $request->validate([
            'fcm_token' => 'required|string',
        ]);

        try {
            $user = auth()->user();
            $user->fcm_token = $validated['fcm_token'];
            $user->save();

            \Log::info('FCM token updated for user: ' . $user->id);

            return $this->success(null, 'FCM token updated successfully');
        } catch (\Exception $e) {
            \Log::error('FCM token update error: ' . $e->getMessage());
            return $this->error('Failed to update FCM token', 500);
        }
    }
}