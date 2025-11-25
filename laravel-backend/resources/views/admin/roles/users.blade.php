@extends('layouts.admin')

@section('title', 'Role Users')
@section('page-title', 'Users in Role')
@section('page-description', 'Browse users assigned to this role')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Users in Role</h5>
                <a href="{{ route('admin.roles.index') }}" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left"></i> Back to Roles
                </a>
            </div>
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
                        <tr><td colspan="4" class="text-center py-5"><div class="spinner-border text-primary"></div></td></tr>
                    </tbody>
                </table>
            </div>
            <div class="p-3 border-top d-flex justify-content-between align-items-center">
                <div class="small text-muted" id="role-users-info">Showing 0 - 0 of 0</div>
                <nav>
                    <ul class="pagination pagination-sm mb-0" id="pagination"></ul>
                </nav>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    const roleId = {{ (int)($id ?? 0) }};
    let currentPage = 1;

    async function loadRoleUsers(page = 1) {
        const body = document.getElementById('role-users-body');
        const info = document.getElementById('role-users-info');
        const params = new URLSearchParams({ page: String(page), role_id: String(roleId) });
        try {
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
                                    <a href="/admin/users/${u.id}">
                                        <img src="${u.avatar_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(u.name)}&background=6366f1&color=fff`}" width="36" height="36" class="rounded-circle" alt="${u.name}">
                                    </a>
                                    <div>
                                        <a href="/admin/users/${u.id}" class="fw-semibold text-decoration-none">${u.name}</a>
                                        <small class="text-muted">ID: ${u.id}</small>
                                    </div>
                                </div>
                            </td>
                            <td><a href="/admin/users/${u.id}" class="text-decoration-none">${u.email}</a></td>
                            <td>${u.school ? u.school.name : 'N/A'}</td>
                            <td>${new Date(u.created_at).toLocaleDateString()}</td>
                        </tr>
                    `).join('');
                }
                info.textContent = `Showing ${data.from || 0} - ${data.to || 0} of ${data.total || users.length}`;
                renderPagination(data);
                currentPage = data.current_page || page;
            }
        } catch (e) {
            body.innerHTML = '<tr><td colspan="4" class="text-center py-4 text-danger">Failed to load users</td></tr>';
        }
    }

    function renderPagination(data) {
        const pagination = document.getElementById('pagination');
        const pages = [];
        const last = data.last_page || 1;
        const current = data.current_page || 1;
        for (let i = 1; i <= last; i++) {
            pages.push(`
                <li class="page-item ${i === current ? 'active' : ''}">
                    <a class="page-link" href="#" onclick="loadRoleUsers(${i}); return false;">${i}</a>
                </li>
            `);
        }
        pagination.innerHTML = pages.join('');
    }

    document.addEventListener('DOMContentLoaded', function() {
        loadRoleUsers();
    });
</script>
@endpush


