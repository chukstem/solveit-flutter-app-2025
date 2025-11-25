<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Role;
use App\Models\Permission;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class RoleController extends Controller
{
    /**
     * Get all roles.
     */
    public function index()
    {
        $roles = Role::with('permissions')
            ->withCount('users')
            ->get();
        return $this->success($roles);
    }

    /**
     * Create a new role.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255|unique:roles',
            'display_name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'permissions' => 'nullable|array',
            'permissions.*' => 'exists:permissions,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $role = Role::create($request->only(['name', 'display_name', 'description']));

        if ($request->has('permissions')) {
            $role->permissions()->attach($request->permissions);
        }

        return $this->success($role->load('permissions'), 'Role created successfully');
    }

    /**
     * Update role.
     */
    public function update(Request $request, $id)
    {
        $role = Role::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255|unique:roles,name,' . $id,
            'display_name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'permissions' => 'nullable|array',
            'permissions.*' => 'exists:permissions,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $role->update($request->only(['name', 'display_name', 'description']));

        if ($request->has('permissions')) {
            $role->permissions()->sync($request->permissions);
        }

        return $this->success($role->load('permissions'), 'Role updated successfully');
    }

    /**
     * Delete role.
     */
    public function destroy($id)
    {
        $role = Role::findOrFail($id);
        
        // Check if role has users
        if ($role->users()->count() > 0) {
            return $this->error('Cannot delete role with active users', 400);
        }

        $role->delete();

        return $this->success(null, 'Role deleted successfully');
    }

    /**
     * Get all permissions.
     */
    public function getPermissions()
    {
        $permissions = Permission::all();
        return $this->success($permissions);
    }

    /**
     * Create a new permission.
     */
    public function storePermission(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255|unique:permissions',
            'display_name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $permission = Permission::create($request->all());

        return $this->success($permission, 'Permission created successfully');
    }

    /**
     * Assign role to user.
     */
    public function assignRole(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'role_id' => 'required|exists:roles,id',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = User::findOrFail($request->user_id);
        $user->role_id = $request->role_id;
        $user->save();

        return $this->success($user->load('role'), 'Role assigned successfully');
    }
}


