@extends('layouts.admin')

@section('title', 'Roles & Permissions')
@section('page-title', 'Roles & Permissions')
@section('page-description', 'Manage user roles and permissions')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Roles</h5>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#assignRoleModal">
                        <i class="bi bi-person-gear"></i> Assign Role to User
                    </button>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createRoleModal">
                        <i class="bi bi-plus-circle"></i> Create Role
                    </button>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Role Name</th>
                            <th>Display Name</th>
                            <th>Description</th>
                            <th>Users</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="roles-table-body">
                        <tr><td colspan="5" class="text-center py-5"><div class="spinner-border text-primary"></div></td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Users in Role Modal -->
<div class="modal fade" id="roleUsersModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="roleUsersTitle">Users in Role</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Email</th>
                                <th>School</th>
                                <th>Joined</th>
                            </tr>
                        </thead>
                        <tbody id="role-users-body">
                            <tr><td colspan="4" class="text-center py-4"><div class="spinner-border text-primary"></div></td></tr>
                        </tbody>
                    </table>
                </div>
                <div class="d-flex justify-content-between align-items-center border-top pt-3">
                    <div class="small text-muted" id="role-users-info"></div>
                    <div class="btn-group btn-group-sm" role="group" aria-label="Pagination">
                        <button class="btn btn-outline-secondary" id="role-users-prev" disabled>Prev</button>
                        <button class="btn btn-outline-secondary" id="role-users-next" disabled>Next</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
</div>
<!-- Create Role Modal -->
<div class="modal fade" id="createRoleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Create New Role</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="create-role-form">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Role Name (slug)</label>
                        <input type="text" class="form-control" name="name" required>
                        <small class="text-muted">Example: super-admin, moderator</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Display Name</label>
                        <input type="text" class="form-control" name="display_name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Role</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Role Modal -->
<div class="modal fade" id="editRoleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Role</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="edit-role-form">
                <input type="hidden" id="edit-role-id">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Role Name (slug)</label>
                        <input type="text" class="form-control" id="edit-role-name" required>
                        <small class="text-muted">Example: super-admin, moderator</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Display Name</label>
                        <input type="text" class="form-control" id="edit-role-display_name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" id="edit-role-description" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Role</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Assign Role Modal -->
<div class="modal fade" id="assignRoleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Assign Role to User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="assign-role-form">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">User ID or Email</label>
                        <input type="text" class="form-control" name="user_identifier" placeholder="e.g. 123 or user@example.com" required>
                        <small class="text-muted">We'll resolve email to user ID automatically.</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select class="form-select" name="role_id" id="assign-role-select" required></select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Assign</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    let allRoles = [];

    async function loadRoles() {
        try {
            const response = await apiRequest('/admin/roles/getRoles');
            if (response.status === 200) {
                allRoles = response.data;
                renderRoles(response.data);
                populateAssignRoleSelect(response.data);
            }
        } catch (error) {
            document.getElementById('roles-table-body').innerHTML = 
                '<tr><td colspan="5" class="text-center py-4 text-danger">Failed to load roles</td></tr>';
        }
    }

    function renderRoles(roles) {
        const tbody = document.getElementById('roles-table-body');
        if (!roles || roles.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center py-4 text-muted">No roles found</td></tr>';
            return;
        }

        tbody.innerHTML = roles.map(role => `
            <tr>
                <td>
                    <a href="/admin/roles/${role.id}/users" class="text-decoration-none">
                        <span class="badge bg-primary">${role.name}</span>
                    </a>
                </td>
                <td>
                    <a href="/admin/roles/${role.id}/users" class="fw-semibold">
                        ${role.display_name}
                    </a>
                </td>
                <td>${role.description || 'N/A'}</td>
                <td>
                    <a href="/admin/roles/${role.id}/users" class="text-decoration-none">
                        <span class="badge bg-info">${role.users_count || 0} users</span>
                    </a>
                </td>
                <td>
                    <div class="btn-group btn-group-sm">
                        <button class="btn btn-outline-warning" onclick="editRole(${role.id})">
                            <i class="bi bi-pencil"></i>
                        </button>
                        <button class="btn btn-outline-danger" onclick="deleteRole(${role.id})">
                            <i class="bi bi-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
        `).join('');
    }

    function populateAssignRoleSelect(roles) {
        const select = document.getElementById('assign-role-select');
        if (!select) return;
        select.innerHTML = '<option value="">Select role</option>' + roles.map(r => `<option value="${r.id}">${r.display_name || r.name}</option>`).join('');
    }

    // Quick helpers to make/remove admin by user id
    async function makeAdmin(userId) {
        try {
            const adminRole = allRoles.find(r => r.name === 'admin');
            if (!adminRole) { showToast('Admin role not found', 'danger'); return; }
            await assignRoleToUser(userId, adminRole.id);
            showToast('User made admin', 'success');
        } catch (e) { showToast('Failed to make admin', 'danger'); }
    }
    async function removeAdmin(userId) {
        try {
            // Fallback: assign default role (first role) or show message
            const defaultRole = allRoles.find(r => r.name !== 'admin');
            if (!defaultRole) { showToast('No non-admin role to assign', 'warning'); return; }
            await assignRoleToUser(userId, defaultRole.id);
            showToast('Admin role removed', 'success');
        } catch (e) { showToast('Failed to remove admin', 'danger'); }
    }

    async function assignRoleToUser(userIdentifier, roleId) {
        // Resolve user id if identifier looks like email
        let payload = { user_id: null, role_id: roleId };
        if (/^\d+$/.test(String(userIdentifier))) {
            payload.user_id = Number(userIdentifier);
        } else {
            // Resolve via a small API call using existing public endpoint
            const users = await apiRequest('/user/getAllUsers');
            const match = (users.data?.data || []).find(u => u.email === userIdentifier);
            if (!match) throw new Error('User not found');
            payload.user_id = match.id;
        }
        await apiRequest('/admin/roles/assignRole', { method: 'POST', body: JSON.stringify(payload) });
    }

    document.getElementById('create-role-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);

        try {
            await apiRequest('/admin/roles/createRole', {
                method: 'POST',
                body: JSON.stringify(data)
            });
            showToast('Role created successfully', 'success');
            bootstrap.Modal.getInstance(document.getElementById('createRoleModal')).hide();
            e.target.reset();
            loadRoles();
        } catch (error) {
            showToast('Failed to create role', 'danger');
        }
    });

    function editRole(id) {
        const role = allRoles.find(r => r.id === id);
        if (!role) return;

        document.getElementById('edit-role-id').value = role.id;
        document.getElementById('edit-role-name').value = role.name || '';
        document.getElementById('edit-role-display_name').value = role.display_name || '';
        document.getElementById('edit-role-description').value = role.description || '';

        new bootstrap.Modal(document.getElementById('editRoleModal')).show();
    }

    document.getElementById('edit-role-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const id = document.getElementById('edit-role-id').value;
        const data = {
            name: document.getElementById('edit-role-name').value,
            display_name: document.getElementById('edit-role-display_name').value,
            description: document.getElementById('edit-role-description').value
        };

        try {
            await apiRequest(`/admin/roles/${id}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            });
            showToast('Role updated successfully', 'success');
            bootstrap.Modal.getInstance(document.getElementById('editRoleModal')).hide();
            loadRoles();
        } catch (error) {
            showToast('Failed to update role', 'danger');
        }
    });

    async function deleteRole(id) {
        if (!confirm('Are you sure you want to delete this role?')) return;
        try {
            await apiRequest(`/admin/roles/${id}`, { method: 'DELETE' });
            showToast('Role deleted successfully', 'success');
            loadRoles();
        } catch (error) {
            showToast(error.message || 'Failed to delete role', 'danger');
        }
    }

    document.getElementById('assign-role-form')?.addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const userIdentifier = formData.get('user_identifier');
        const roleId = formData.get('role_id');
        try {
            await assignRoleToUser(userIdentifier, roleId);
            showToast('Role assigned', 'success');
            bootstrap.Modal.getInstance(document.getElementById('assignRoleModal')).hide();
            e.target.reset();
        } catch (err) {
            showToast(err.message || 'Failed to assign role', 'danger');
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        loadRoles();
        // If navigated with #assign, open the Assign Role modal automatically
        if (window.location.hash === '#assign') {
            const modalEl = document.getElementById('assignRoleModal');
            if (modalEl) new bootstrap.Modal(modalEl).show();
        }
    });

    // Show users in a role (with basic pagination)
    let currentRoleId = null;
    let currentRolePage = 1;
    let currentRoleName = '';

    async function showRoleUsers(roleId, roleName, page = 1) {
        currentRoleId = roleId;
        currentRolePage = page;
        currentRoleName = roleName || '';

        const modal = new bootstrap.Modal(document.getElementById('roleUsersModal'));
        document.getElementById('roleUsersTitle').textContent = `Users in ${roleName}`;
        const body = document.getElementById('role-users-body');
        const info = document.getElementById('role-users-info');
        const prevBtn = document.getElementById('role-users-prev');
        const nextBtn = document.getElementById('role-users-next');

        body.innerHTML = '<tr><td colspan="4" class="text-center py-4"><div class="spinner-border text-primary"></div></td></tr>';
        info.textContent = '';
        prevBtn.disabled = true;
        nextBtn.disabled = true;

        modal.show();

        try {
            const params = new URLSearchParams({ page: String(page), role_id: String(roleId) });
            const response = await apiRequest(`/admin/users?${params}`);
            if (response.status === 200) {
                const data = response.data;
                const users = data.data || [];

                if (users.length === 0) {
                    body.innerHTML = '<tr><td colspan="4" class="text-center py-4 text-muted">No users in this role</td></tr>';
                } else {
                    body.innerHTML = users.map(u => `
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <img src="${u.avatar_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(u.name)}&background=6366f1&color=fff`}" width="36" height="36" class="rounded-circle" alt="${u.name}">
                                    <div>
                                        <div class="fw-semibold">${u.name}</div>
                                        <small class="text-muted">ID: ${u.id}</small>
                                    </div>
                                </div>
                            </td>
                            <td>${u.email}</td>
                            <td>${u.school ? u.school.name : 'N/A'}</td>
                            <td>${new Date(u.created_at).toLocaleDateString()}</td>
                        </tr>
                    `).join('');
                }

                // Update info and pagination
                info.textContent = `Showing ${data.from || 0} - ${data.to || 0} of ${data.total || users.length}`;
                prevBtn.disabled = !(data.prev_page_url || data.current_page > 1);
                nextBtn.disabled = !(data.next_page_url || (data.current_page < data.last_page));

                prevBtn.onclick = () => { if (data.current_page > 1) showRoleUsers(roleId, roleName, data.current_page - 1); };
                nextBtn.onclick = () => { if (data.current_page < data.last_page) showRoleUsers(roleId, roleName, data.current_page + 1); };
            }
        } catch (e) {
            body.innerHTML = '<tr><td colspan="4" class="text-center py-4 text-danger">Failed to load users</td></tr>';
        }
    }
</script>
@endpush

