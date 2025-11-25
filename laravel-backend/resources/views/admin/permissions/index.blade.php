@extends('layouts.admin')

@section('title', 'Permissions')
@section('page-title', 'Permissions Management')
@section('page-description', 'Manage system permissions')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Permissions</h5>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModal">
                    <i class="bi bi-plus-circle"></i> Create Permission
                </button>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Display Name</th>
                            <th>Description</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="permissions-table-body">
                        <tr><td colspan="4" class="text-center py-5"><div class="spinner-border text-primary"></div></td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="createModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Create Permission</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="create-form">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Name (slug)</label>
                        <input type="text" class="form-control" name="name" required>
                        <small class="text-muted">Example: view-users, edit-posts</small>
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
                    <button type="submit" class="btn btn-primary">Create</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    async function loadPermissions() {
        try {
            const response = await apiRequest('/admin/roles/getPermissions');
            if (response.status === 200) {
                const tbody = document.getElementById('permissions-table-body');
                if (!response.data || response.data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="4" class="text-center py-4 text-muted">No permissions found</td></tr>';
                    return;
                }
                tbody.innerHTML = response.data.map(perm => `
                    <tr>
                        <td><span class="badge bg-secondary">${perm.name}</span></td>
                        <td><strong>${perm.display_name}</strong></td>
                        <td>${perm.description || 'N/A'}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary" disabled>
                                <i class="bi bi-eye"></i>
                            </button>
                        </td>
                    </tr>
                `).join('');
            }
        } catch (error) {
            console.error('Error:', error);
        }
    }

    document.getElementById('create-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        try {
            await apiRequest('/admin/roles/createPermission', {
                method: 'POST',
                body: JSON.stringify(Object.fromEntries(formData))
            });
            showToast('Permission created', 'success');
            bootstrap.Modal.getInstance(document.getElementById('createModal')).hide();
            e.target.reset();
            loadPermissions();
        } catch (error) {
            showToast('Failed to create permission', 'danger');
        }
    });

    document.addEventListener('DOMContentLoaded', loadPermissions);
</script>
@endpush


