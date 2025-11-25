@extends('layouts.admin')

@section('title', 'User Details')
@section('page-title', 'User Details')
@section('page-description', 'View user profile and metadata')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="card p-4 shadow-sm">
            <div class="d-flex align-items-center gap-3 mb-4">
                <img id="user-avatar" src="https://ui-avatars.com/api/?name=User&background=6366f1&color=fff" width="90" height="90" class="rounded-circle border" alt="User">
                <div>
                    <h4 id="user-name" class="mb-1">Loading...</h4>
                    <div class="text-muted" id="user-email">&nbsp;</div>
                    <div class="mt-1" id="user-badges"></div>
                </div>
                <div class="ms-auto">
                    <a href="/admin/users" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left"></i> Back</a>
                    <a id="edit-link" href="#" class="btn btn-primary btn-sm"><i class="bi bi-pencil"></i> Edit</a>
                </div>
            </div>

            <div class="row g-3">
                <div class="col-lg-4">
                    <div class="border rounded p-3">
                        <h6 class="mb-3">Profile</h6>
                        <table class="table mb-0">
                            <tr><th>ID</th><td id="user-id">-</td></tr>
                            <tr><th>Phone</th><td id="user-phone">-</td></tr>
                            <tr><th>Role</th><td id="user-role">-</td></tr>
                            <tr><th>Status</th><td id="user-status">-</td></tr>
                            <tr><th>Joined</th><td id="user-created">-</td></tr>
                            <tr><th>Last Login</th><td id="user-last-login">-</td></tr>
                        </table>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="border rounded p-3">
                        <h6 class="mb-3">School Info</h6>
                        <table class="table mb-0">
                            <tr><th>School</th><td id="user-school">-</td></tr>
                            <tr><th>Faculty</th><td id="user-faculty">-</td></tr>
                            <tr><th>Department</th><td id="user-department">-</td></tr>
                            <tr><th>Level</th><td id="user-level">-</td></tr>
                        </table>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="border rounded p-3">
                        <h6 class="mb-3">Activity</h6>
                        <table class="table mb-0">
                            <tr><th>Posts</th><td id="user-posts-count">0</td></tr>
                            <tr><th>Products</th><td id="user-products-count">0</td></tr>
                            <tr><th>Services</th><td id="user-services-count">0</td></tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    const userId = {{ (int)($id ?? 0) }};

    async function loadUser() {
        try {
            const response = await apiRequest(`/admin/users/${userId}`);
            if (response.status === 200) {
                const u = response.data;
                document.getElementById('user-avatar').src = u.avatar_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(u.name)}&background=6366f1&color=fff`;
                document.getElementById('user-name').textContent = u.name || '-';
                document.getElementById('user-email').textContent = u.email || '-';
                document.getElementById('user-id').textContent = u.id;
                document.getElementById('user-phone').textContent = u.phone || 'N/A';
                document.getElementById('user-role').innerHTML = u.role ? `<span class="badge bg-info">${u.role.display_name || u.role.name}</span>` : 'User';
                document.getElementById('user-status').innerHTML = u.is_deleted ? '<span class="badge bg-danger">Deleted</span>' : (!u.is_active ? '<span class="badge bg-warning">Blocked</span>' : (u.is_verified ? '<span class="badge bg-success">Verified</span>' : '<span class="badge bg-secondary">Unverified</span>'));
                document.getElementById('user-created').textContent = u.created_at ? new Date(u.created_at).toLocaleString() : '-';
                document.getElementById('user-last-login').textContent = u.last_login_at ? new Date(u.last_login_at).toLocaleString() : 'Never';
                document.getElementById('user-school').textContent = u.school ? u.school.name : 'N/A';
                document.getElementById('user-faculty').textContent = u.faculty ? u.faculty.name : 'N/A';
                document.getElementById('user-department').textContent = u.department ? u.department.name : 'N/A';
                document.getElementById('user-level').textContent = u.level ? u.level.name : 'N/A';
                document.getElementById('edit-link').href = `/admin/users/${u.id}/edit`;

                // Badges under header
                const badges = [];
                if (u.role) badges.push(`<span class="badge bg-primary">${u.role.display_name || u.role.name}</span>`);
                badges.push(u.is_verified ? '<span class="badge bg-success">Verified</span>' : '<span class="badge bg-secondary">Unverified</span>');
                if (!u.is_active) badges.push('<span class="badge bg-warning">Blocked</span>');
                if (u.is_deleted) badges.push('<span class="badge bg-danger">Deleted</span>');
                document.getElementById('user-badges').innerHTML = badges.join(' ');

                // Activity counts if loaded
                document.getElementById('user-posts-count').textContent = (u.posts?.length ?? 0);
                document.getElementById('user-products-count').textContent = (u.products?.length ?? 0);
                document.getElementById('user-services-count').textContent = (u.services?.length ?? 0);
            }
        } catch (e) {
            showToast('Failed to load user', 'danger');
        }
    }

    document.addEventListener('DOMContentLoaded', loadUser);
</script>
@endpush


