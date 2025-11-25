@extends('layouts.admin')

@section('title', 'Edit Forum')

@section('content')
<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 mb-0">Edit Forum</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="/admin/forums">Forums</a></li>
                    <li class="breadcrumb-item active">Edit Forum</li>
                </ol>
            </nav>
        </div>
        <a href="/admin/forums" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i> Back to Forums
        </a>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-body">
                    <form id="edit-forum-form">
                        <div class="mb-3">
                            <label class="form-label">Forum Name *</label>
                            <input type="text" class="form-control" id="name" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" id="description" rows="4"></textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Max Members</label>
                                    <input type="number" class="form-control" id="max_members" min="2">
                                    <small class="text-muted">Leave empty for unlimited</small>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="is_active">
                                <label class="form-check-label" for="is_active">
                                    Active Forum
                                </label>
                            </div>
                            <small class="text-muted">Inactive forums cannot be accessed by members</small>
                        </div>

                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="is_public">
                                <label class="form-check-label" for="is_public">
                                    Public Forum
                                </label>
                            </div>
                            <small class="text-muted">Public forums are visible to all users</small>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4">
                            <a href="/admin/forums" class="btn btn-secondary">Cancel</a>
                            <button type="button" class="btn btn-danger" onclick="deleteForum()">
                                <i class="bi bi-trash me-2"></i> Delete Forum
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-lg me-2"></i> Update Forum
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm mb-3">
                <div class="card-header bg-light">
                    <h6 class="mb-0">Forum Information</h6>
                </div>
                <div class="card-body" id="forum-info">
                    <div class="d-flex justify-content-center">
                        <div class="spinner-border spinner-border-sm text-primary" role="status"></div>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-light">
                    <h6 class="mb-0">Quick Stats</h6>
                </div>
                <div class="card-body" id="forum-stats">
                    <div class="d-flex justify-content-center">
                        <div class="spinner-border spinner-border-sm text-primary" role="status"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const forumId = window.location.pathname.split('/')[3];
    let currentForum = null;

    async function loadForum() {
        try {
            const response = await apiRequest(`/admin/forums/${forumId}`);
            
            if (response.status === 200) {
                currentForum = response.data;
                populateForm(currentForum);
                displayForumInfo(currentForum);
                displayStats(currentForum);
            } else {
                showToast('Failed to load forum', 'error');
                setTimeout(() => window.location.href = '/admin/forums', 2000);
            }
        } catch (error) {
            console.error('Error:', error);
            showToast('Failed to load forum', 'error');
        }
    }

    function populateForm(forum) {
        document.getElementById('name').value = forum.name || '';
        document.getElementById('description').value = forum.description || '';
        document.getElementById('max_members').value = forum.max_members || '';
        document.getElementById('is_active').checked = forum.is_active || false;
        document.getElementById('is_public').checked = forum.is_public || false;
    }

    function displayForumInfo(forum) {
        document.getElementById('forum-info').innerHTML = `
            <div class="mb-2">
                <small class="text-muted">Created by:</small><br>
                <strong>${forum.creator?.name || 'Unknown'}</strong>
            </div>
            <div class="mb-2">
                <small class="text-muted">Category:</small><br>
                <strong>${forum.category?.name || 'Uncategorized'}</strong>
            </div>
            <div class="mb-2">
                <small class="text-muted">Created:</small><br>
                <strong>${new Date(forum.created_at).toLocaleString()}</strong>
            </div>
            ${forum.updated_at !== forum.created_at ? `
                <div class="mb-2">
                    <small class="text-muted">Last updated:</small><br>
                    <strong>${new Date(forum.updated_at).toLocaleString()}</strong>
                </div>
            ` : ''}
        `;
    }

    function displayStats(forum) {
        const members = forum.members || [];
        const adminCount = members.filter(m => m.role === 'admin').length;
        const moderatorCount = members.filter(m => m.role === 'moderator').length;

        document.getElementById('forum-stats').innerHTML = `
            <div class="d-flex justify-content-between mb-2">
                <span>Total Members</span>
                <strong>${members.length}</strong>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span>Admins</span>
                <strong>${adminCount}</strong>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span>Moderators</span>
                <strong>${moderatorCount}</strong>
            </div>
            <div class="d-flex justify-content-between">
                <span>Regular Members</span>
                <strong>${members.length - adminCount - moderatorCount}</strong>
            </div>
        `;
    }

    document.getElementById('edit-forum-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const formData = {
            name: document.getElementById('name').value,
            description: document.getElementById('description').value,
            max_members: document.getElementById('max_members').value || null,
            is_active: document.getElementById('is_active').checked,
            is_public: document.getElementById('is_public').checked
        };

        try {
            const response = await apiRequest(`/admin/forums/${forumId}`, 'PUT', formData);
            
            if (response.status === 200) {
                showToast('Forum updated successfully!', 'success');
                setTimeout(() => window.location.href = '/admin/forums', 1500);
            } else {
                showToast(response.message || 'Failed to update forum', 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            showToast('Failed to update forum', 'error');
        }
    });

    async function deleteForum() {
        if (confirm('Are you sure you want to delete this forum? This action cannot be undone.')) {
            try {
                const response = await apiRequest(`/admin/forums/${forumId}`, 'DELETE');
                
                if (response.status === 200) {
                    showToast('Forum deleted successfully!', 'success');
                    setTimeout(() => window.location.href = '/admin/forums', 1500);
                } else {
                    showToast(response.message || 'Failed to delete forum', 'error');
                }
            } catch (error) {
                console.error('Error:', error);
                showToast('Failed to delete forum', 'error');
            }
        }
    }

    // Load forum on page load
    document.addEventListener('DOMContentLoaded', loadForum);
</script>
@endsection


