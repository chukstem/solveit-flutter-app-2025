@extends('layouts.admin')

@section('title', 'Users Management')
@section('page-title', 'Users Management')
@section('page-description', 'Manage all registered users and their information')

@section('content')
<div class="row g-4">
    <!-- Filter Cards -->
    <div class="col-md-6 col-xl-3">
        <div class="stat-card" role="button" onclick="filterUsers('all')">
            <div class="stat-icon primary">
                <i class="bi bi-people"></i>
            </div>
            <div class="stat-value" id="all-users-count">0</div>
            <div class="stat-label">All Users</div>
        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="stat-card" role="button" onclick="filterUsers('verified')">
            <div class="stat-icon success">
                <i class="bi bi-check-circle"></i>
            </div>
            <div class="stat-value" id="verified-users-count">0</div>
            <div class="stat-label">Verified</div>
        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="stat-card" role="button" onclick="filterUsers('blocked')">
            <div class="stat-icon warning">
                <i class="bi bi-x-circle"></i>
            </div>
            <div class="stat-value" id="blocked-users-count">0</div>
            <div class="stat-label">Blocked</div>
        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="stat-card" role="button" onclick="filterUsers('deleted')">
            <div class="stat-icon danger">
                <i class="bi bi-trash"></i>
            </div>
            <div class="stat-value" id="deleted-users-count">0</div>
            <div class="stat-label">Deleted</div>
        </div>
    </div>

    <!-- Users Table -->
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Users List</h5>
                <div class="d-flex gap-2">
                    <div class="search-bar">
                        <i class="bi bi-search"></i>
                        <input type="text" class="form-control" id="search-input" placeholder="Search users...">
                    </div>
                    <select class="form-select" id="school-filter" style="width: 200px;">
                        <option value="">All Schools</option>
                    </select>
                    <select class="form-select" id="role-filter" style="width: 200px;">
                        <option value="">All Roles</option>
                    </select>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>School</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Joined</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="users-table-body">
                        <tr>
                            <td colspan="8" class="text-center py-5">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="p-3 border-top">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="text-muted small">
                        Showing <span id="showing-from">0</span> to <span id="showing-to">0</span> of <span id="total-users">0</span> users
                    </div>
                    <nav>
                        <ul class="pagination pagination-sm mb-0" id="pagination">
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- User Details Modal -->
<div class="modal fade" id="userModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">User Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="userModalBody">
                <div class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    let currentPage = 1;
    let currentFilter = 'all';
    let currentSearch = '';
    let currentSchool = '';
    let currentRole = '';

    // Load Users
    async function loadUsers(page = 1) {
        const params = new URLSearchParams({
            page: page,
            status: currentFilter === 'all' ? '' : currentFilter,
            search: currentSearch,
            school_id: currentSchool,
            role_id: currentRole
        });

        try {
            const response = await apiRequest(`/admin/users?${params}`);
            if (response.status === 200) {
                renderUsers(response.data);
                updatePagination(response.data);
            }
        } catch (error) {
            console.error('Error loading users:', error);
            document.getElementById('users-table-body').innerHTML = 
                `<tr><td colspan="8" class="text-center py-4 text-danger">Failed to load users</td></tr>`;
        }
    }

    // Render Users
    function renderUsers(data) {
        const tbody = document.getElementById('users-table-body');
        
        if (!data.data || data.data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" class="text-center py-4 text-muted">No users found</td></tr>';
            return;
        }

        tbody.innerHTML = data.data.map(user => `
            <tr>
                <td>
                    <div class="d-flex align-items-center gap-3">
                        <img src="${user.avatar_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(user.name)}&background=6366f1&color=fff`}" 
                             width="40" height="40" class="rounded-circle" alt="${user.name}">
                        <div>
                            <div class="fw-semibold">${user.name}</div>
                            <small class="text-muted">${user.matric_number || 'N/A'}</small>
                        </div>
                    </div>
                </td>
                <td>${user.email}</td>
                <td>${user.phone || 'N/A'}</td>
                <td>${user.school ? user.school.name : 'N/A'}</td>
                <td><span class="badge bg-info">${user.role ? user.role.display_name : 'User'}</span></td>
                <td>
                    ${user.is_deleted ? '<span class="badge bg-danger">Deleted</span>' : 
                      !user.is_active ? '<span class="badge bg-warning">Blocked</span>' : 
                      user.is_verified ? '<span class="badge bg-success">Verified</span>' : 
                      '<span class="badge bg-secondary">Unverified</span>'}
                </td>
                <td>${new Date(user.created_at).toLocaleDateString()}</td>
                <td>
                    <div class="btn-group btn-group-sm">
                        <a class="btn btn-outline-primary" href="/admin/users/${user.id}" title="View">
                            <i class="bi bi-eye"></i>
                        </a>
                        <a href="/admin/users/${user.id}/edit" class="btn btn-outline-warning" title="Edit">
                            <i class="bi bi-pencil"></i>
                        </a>
                        ${user.is_deleted ? 
                            `<button class="btn btn-outline-success" onclick="restoreUser(${user.id})" title="Restore">
                                <i class="bi bi-arrow-counterclockwise"></i>
                            </button>` :
                            `<button class="btn btn-outline-${user.is_active ? 'warning' : 'success'}" onclick="toggleUserStatus(${user.id})" title="${user.is_active ? 'Block' : 'Activate'}">
                                <i class="bi bi-${user.is_active ? 'x-circle' : 'check-circle'}"></i>
                            </button>
                            <button class="btn btn-outline-danger" onclick="deleteUser(${user.id})" title="Delete">
                                <i class="bi bi-trash"></i>
                            </button>`
                        }
                    </div>
                </td>
            </tr>
        `).join('');

        // Update showing info
        document.getElementById('showing-from').textContent = data.from || 0;
        document.getElementById('showing-to').textContent = data.to || 0;
        document.getElementById('total-users').textContent = data.total || 0;
    }

    // Update Pagination
    function updatePagination(data) {
        const pagination = document.getElementById('pagination');
        const pages = [];

        for (let i = 1; i <= data.last_page; i++) {
            pages.push(`
                <li class="page-item ${i === data.current_page ? 'active' : ''}">
                    <a class="page-link" href="#" onclick="loadUsers(${i}); return false;">${i}</a>
                </li>
            `);
        }

        pagination.innerHTML = pages.join('');
        currentPage = data.current_page;
    }

    // Filter Users
    function filterUsers(status) {
        currentFilter = status;
        currentPage = 1;
        loadUsers();
    }

    // View User
    async function viewUser(userId) {
        const modal = new bootstrap.Modal(document.getElementById('userModal'));
        const modalBody = document.getElementById('userModalBody');
        
        modalBody.innerHTML = '<div class="text-center py-5"><div class="spinner-border text-primary"></div></div>';
        modal.show();

        try {
            const response = await apiRequest(`/admin/users/${userId}`);
            if (response.status === 200) {
                const user = response.data;
                modalBody.innerHTML = `
                    <div class="row g-4">
                        <div class="col-md-4 text-center">
                            <img src="${user.avatar_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(user.name)}&background=6366f1&color=fff`}" 
                                 class="rounded-circle mb-3" width="120" height="120" alt="${user.name}">
                            <h5>${user.name}</h5>
                            <p class="text-muted">${user.email}</p>
                        </div>
                        <div class="col-md-8">
                            <h6 class="mb-3">User Information</h6>
                            <table class="table">
                                <tr><th>Phone:</th><td>${user.phone || 'N/A'}</td></tr>
                                <tr><th>Matric Number:</th><td>${user.matric_number || 'N/A'}</td></tr>
                                <tr><th>School:</th><td>${user.school ? user.school.name : 'N/A'}</td></tr>
                                <tr><th>Faculty:</th><td>${user.faculty ? user.faculty.name : 'N/A'}</td></tr>
                                <tr><th>Department:</th><td>${user.department ? user.department.name : 'N/A'}</td></tr>
                                <tr><th>Level:</th><td>${user.level ? user.level.name : 'N/A'}</td></tr>
                                <tr><th>Role:</th><td>${user.role ? user.role.display_name : 'User'}</td></tr>
                                <tr><th>Status:</th><td>
                                    ${user.is_deleted ? '<span class="badge bg-danger">Deleted</span>' : 
                                      !user.is_active ? '<span class="badge bg-warning">Blocked</span>' : 
                                      user.is_verified ? '<span class="badge bg-success">Verified</span>' : 
                                      '<span class="badge bg-secondary">Unverified</span>'}
                                </td></tr>
                                <tr><th>Joined:</th><td>${new Date(user.created_at).toLocaleString()}</td></tr>
                                <tr><th>Last Login:</th><td>${user.last_login_at ? new Date(user.last_login_at).toLocaleString() : 'Never'}</td></tr>
                            </table>
                        </div>
                    </div>
                `;
            }
        } catch (error) {
            modalBody.innerHTML = '<div class="alert alert-danger">Failed to load user details</div>';
        }
    }

    // Toggle User Status
    async function toggleUserStatus(userId) {
        if (!confirm('Are you sure you want to change this user\'s status?')) return;

        try {
            const response = await apiRequest(`/admin/users/${userId}/toggle-status`, { method: 'POST' });
            if (response.status === 200) {
                showToast('User status updated successfully', 'success');
                loadUsers(currentPage);
                loadStats();
            }
        } catch (error) {
            showToast('Failed to update user status', 'danger');
        }
    }

    // Delete User
    async function deleteUser(userId) {
        if (!confirm('Are you sure you want to delete this user? This action can be reversed later.')) return;

        try {
            const response = await apiRequest(`/admin/users/${userId}`, { method: 'DELETE' });
            if (response.status === 200) {
                showToast('User deleted successfully', 'success');
                loadUsers(currentPage);
                loadStats();
            }
        } catch (error) {
            showToast('Failed to delete user', 'danger');
        }
    }

    // Restore User
    async function restoreUser(userId) {
        if (!confirm('Are you sure you want to restore this user?')) return;

        try {
            const response = await apiRequest(`/admin/users/${userId}/restore`, { method: 'POST' });
            if (response.status === 200) {
                showToast('User restored successfully', 'success');
                loadUsers(currentPage);
                loadStats();
            }
        } catch (error) {
            showToast('Failed to restore user', 'danger');
        }
    }

    // Load Statistics
    async function loadStats() {
        try {
            const response = await apiRequest('/admin/dashboard');
            if (response.status === 200) {
                const stats = response.data;
                document.getElementById('all-users-count').textContent = stats.total_users;
                document.getElementById('verified-users-count').textContent = stats.verified_users;
                document.getElementById('blocked-users-count').textContent = stats.blocked_users;
                document.getElementById('deleted-users-count').textContent = stats.deleted_users;
            }
        } catch (error) {
            console.error('Error loading stats:', error);
        }
    }

    // Load Schools and Roles for Filters
    async function loadFilters() {
        try {
            // Load schools
            const schoolsResponse = await apiRequest('/admin/school/getSchoolElements?elementType=School');
            if (schoolsResponse.status === 200) {
                const schoolSelect = document.getElementById('school-filter');
                schoolsResponse.data.forEach(school => {
                    const option = document.createElement('option');
                    option.value = school.id;
                    option.textContent = school.name;
                    schoolSelect.appendChild(option);
                });
            }

            // Load roles
            const rolesResponse = await apiRequest('/admin/roles/getRoles');
            if (rolesResponse.status === 200) {
                const roleSelect = document.getElementById('role-filter');
                rolesResponse.data.forEach(role => {
                    const option = document.createElement('option');
                    option.value = role.id;
                    option.textContent = role.display_name;
                    roleSelect.appendChild(option);
                });
            }
        } catch (error) {
            console.error('Error loading filters:', error);
        }
    }

    // Search Input
    document.getElementById('search-input').addEventListener('input', function(e) {
        clearTimeout(this.searchTimeout);
        this.searchTimeout = setTimeout(() => {
            currentSearch = e.target.value;
            currentPage = 1;
            loadUsers();
        }, 500);
    });

    // School Filter
    document.getElementById('school-filter').addEventListener('change', function(e) {
        currentSchool = e.target.value;
        currentPage = 1;
        loadUsers();
    });

    // Role Filter
    document.getElementById('role-filter').addEventListener('change', function(e) {
        currentRole = e.target.value;
        currentPage = 1;
        loadUsers();
    });

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
        loadUsers();
        loadStats();
        loadFilters();
    });
</script>
@endpush


