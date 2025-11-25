@extends('layouts.admin')

@section('title', 'Forums Management')
@section('page-title', 'Forums Management')
@section('page-description', 'Manage all forums, members, and settings')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Forums List</h5>
                <div class="search-bar">
                    <i class="bi bi-search"></i>
                    <input type="text" class="form-control" id="search-input" placeholder="Search forums...">
                </div>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Forum Name</th>
                            <th>Creator</th>
                            <th>Members</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="forums-table-body">
                        <tr>
                            <td colspan="7" class="text-center py-5">
                                <div class="spinner-border text-primary"></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    async function loadForums() {
        try {
            const response = await apiRequest('/admin/forums');
            if (response.status === 200) {
                renderForums(response.data.data);
            }
        } catch (error) {
            document.getElementById('forums-table-body').innerHTML = 
                '<tr><td colspan="7" class="text-center py-4 text-danger">Failed to load forums</td></tr>';
        }
    }

    function renderForums(forums) {
        const tbody = document.getElementById('forums-table-body');
        if (!forums || forums.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center py-4 text-muted">No forums found</td></tr>';
            return;
        }

        tbody.innerHTML = forums.map(forum => `
            <tr>
                <td><strong>${forum.name}</strong></td>
                <td>${forum.creator ? forum.creator.name : 'N/A'}</td>
                <td><span class="badge bg-primary">${forum.members_count || 0} members</span></td>
                <td>${forum.category ? forum.category.name : 'N/A'}</td>
                <td>
                    <span class="badge bg-${forum.is_active ? 'success' : 'danger'}">
                        ${forum.is_active ? 'Active' : 'Inactive'}
                    </span>
                </td>
                <td>${new Date(forum.created_at).toLocaleDateString()}</td>
                <td>
                    <div class="btn-group btn-group-sm">
                        <a href="/admin/forums/${forum.id}" class="btn btn-outline-primary">
                            <i class="bi bi-eye"></i>
                        </a>
                        <a href="/admin/forums/${forum.id}/edit" class="btn btn-outline-warning">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <button class="btn btn-outline-danger" onclick="deleteForum(${forum.id})">
                            <i class="bi bi-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
        `).join('');
    }

    async function deleteForum(id) {
        if (!confirm('Are you sure you want to delete this forum?')) return;
        try {
            await apiRequest(`/admin/forums/${id}`, { method: 'DELETE' });
            showToast('Forum deleted successfully', 'success');
            loadForums();
        } catch (error) {
            showToast('Failed to delete forum', 'danger');
        }
    }

    document.getElementById('search-input').addEventListener('input', function(e) {
        clearTimeout(this.searchTimeout);
        this.searchTimeout = setTimeout(() => loadForums(), 500);
    });

    document.addEventListener('DOMContentLoaded', loadForums);
</script>
@endpush


