<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    /**
     * Get all users with filters.
     */
    public function index(Request $request)
    {
        $query = User::with(['school', 'faculty', 'department', 'level', 'role']);

        // Apply filters (only when non-empty)
        if ($request->filled('status')) {
            switch ($request->status) {
                case 'verified':
                    $query->where('is_verified', true);
                    break;
                case 'unverified':
                    $query->where('is_verified', false);
                    break;
                case 'active':
                    $query->where('is_active', true)->where('is_deleted', false);
                    break;
                case 'blocked':
                    $query->where('is_active', false);
                    break;
                case 'deleted':
                    $query->where('is_deleted', true);
                    break;
            }
        }

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%")
                  ->orWhere('matric_number', 'like', "%{$search}%");
            });
        }

        if ($request->filled('school_id')) {
            $query->where('school_id', $request->school_id);
        }

        if ($request->filled('role_id')) {
            $query->where('role_id', $request->role_id);
        }

        $users = $query->latest()->paginate(20);

        return $this->success($users);
    }

    /**
     * Get a single user.
     */
    public function show($id)
    {
        $user = User::with(['school', 'faculty', 'department', 'level', 'role', 'posts', 'products', 'services'])
            ->findOrFail($id);

        return $this->success($user);
    }

    /**
     * Update user details.
     */
    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|unique:users,email,' . $id,
            'phone' => 'sometimes|string|unique:users,phone,' . $id,
            'school_id' => 'sometimes|exists:schools,id',
            'faculty_id' => 'sometimes|exists:faculties,id',
            'department_id' => 'sometimes|exists:departments,id',
            'level_id' => 'sometimes|exists:levels,id',
            'role_id' => 'sometimes|exists:roles,id',
            'is_verified' => 'sometimes|boolean',
            'is_active' => 'sometimes|boolean',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user->update($request->all());

        return $this->success($user->load(['school', 'faculty', 'department', 'level', 'role']), 'User updated successfully');
    }

    /**
     * Block/Unblock user.
     */
    public function toggleStatus($id)
    {
        $user = User::findOrFail($id);
        $user->is_active = !$user->is_active;
        $user->save();

        $status = $user->is_active ? 'activated' : 'blocked';
        return $this->success($user, "User {$status} successfully");
    }

    /**
     * Delete user permanently.
     */
    public function destroy($id)
    {
        $user = User::findOrFail($id);
        $user->is_deleted = true;
        $user->deleted_at = now();
        $user->email = 'deleted@' . $user->id . '_' . $user->email;
        $user->phone = 'deleted@' . $user->id . '_' . $user->phone;
        $user->save();

        return $this->success(null, 'User deleted successfully');
    }

    /**
     * Restore deleted user.
     */
    public function restore($id)
    {
        $user = User::findOrFail($id);
        $user->is_deleted = false;
        $user->deleted_at = null;
        // Remove 'deleted@' prefix
        $user->email = preg_replace('/^deleted@\d+_/', '', $user->email);
        $user->phone = preg_replace('/^deleted@\d+_/', '', $user->phone);
        $user->save();

        return $this->success($user, 'User restored successfully');
    }
}


