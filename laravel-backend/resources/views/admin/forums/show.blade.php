@extends('layouts.admin')

@section('title', 'View Forum')

@section('content')
<div class="container-fluid">
    <div class="mb-4 p-4 rounded-4 text-white" style="background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #06b6d4 100%); box-shadow: 0 8px 24px rgba(0,0,0,0.08);">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <div class="d-flex align-items-center gap-3">
                    <i class="bi bi-chat-square-text" style="font-size: 2rem;"></i>
                    <div>
                        <h1 class="h3 mb-1" id="forum-title">Forum Details</h1>
                        <div class="small opacity-75">
                            <a class="text-white text-decoration-underline" href="/admin/dashboard">Dashboard</a>
                            <span class="mx-2">/</span>
                            <a class="text-white text-decoration-underline" href="/admin/forums">Forums</a>
                            <span class="mx-2">/</span>
                            <span>View Forum</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="d-flex gap-2">
                <a href="/admin/forums" class="btn btn-light btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back
                </a>
                <button class="btn btn-dark btn-sm" onclick="editForum()">
                    <i class="bi bi-pencil me-1"></i> Edit
                </button>
            </div>
        </div>
    </div>

    <!-- Forum Details Card -->
    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm mb-4" id="forum-details">
                <div class="card-body">
                    <div class="d-flex justify-content-center align-items-center" style="min-height: 200px;">
                        <div class="spinner-border text-primary" role="status"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm" id="forum-stats">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="bi bi-bar-chart text-primary me-2"></i> Statistics</h5>
                </div>
                <div class="card-body">
                    <div class="d-flex justify-content-center">
                        <div class="spinner-border text-primary" role="status"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Members Section -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <i class="bi bi-people text-primary me-2"></i> Members
                <span class="badge bg-primary ms-2" id="members-count">0</span>
            </h5>
            <div class="input-group" style="width: 300px;">
                <span class="input-group-text"><i class="bi bi-search"></i></span>
                <input type="text" class="form-control" id="member-search" placeholder="Search members...">
            </div>
        </div>
        <div class="card-body">
            <div id="members-container">
                <div class="d-flex justify-content-center py-5">
                    <div class="spinner-border text-primary" role="status"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const forumId = window.location.pathname.split('/').pop();
    let currentForum = null;
    let allMembers = [];

    async function loadForumDetails() {
        try {
            const response = await apiRequest(`/admin/forums/${forumId}`);
            
            if (response.status === 200) {
                currentForum = response.data;
                displayForumDetails(currentForum);
                displayForumStats(currentForum);
                displayMembers(currentForum.members || []);
                allMembers = currentForum.members || [];
            }
        } catch (error) {
            console.error('Error:', error);
            document.getElementById('forum-details').innerHTML = `
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle me-2"></i> Failed to load forum details
                </div>
            `;
        }
    }

    function displayForumDetails(forum) {
        const statusBadge = forum.is_active 
            ? '<span class="badge bg-success">Active</span>' 
            : '<span class="badge bg-secondary">Inactive</span>';
        
        const visibilityBadge = forum.is_public 
            ? '<span class="badge bg-info ms-2">Public</span>' 
            : '<span class="badge bg-warning ms-2">Private</span>';

        document.getElementById('forum-title').textContent = forum.name || 'Forum Details';

        document.getElementById('forum-details').innerHTML = `
            <div class="row g-4">
                <div class="col-12">
                    <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
                        ${statusBadge} ${visibilityBadge}
                        ${forum.category?.name ? `<span class="badge bg-primary">${forum.category.name}</span>` : ''}
                        ${forum.level?.name ? `<span class="badge bg-dark">Level: ${forum.level.name}</span>` : ''}
                    </div>
                </div>
                <div class="col-lg-8 p-3">
                    <h5 class="mb-2">About</h5>
                    <p class="text-muted mb-0">${forum.description || 'No description provided.'}</p>
                </div>
                <div class="col-lg-4">
                    <div class="border rounded p-3">
                        <div class="mb-2 d-flex justify-content-between"><span>Creator</span><strong>${forum.creator?.name || 'Unknown'}</strong></div>
                        <div class="mb-2 d-flex justify-content-between"><span>Max Members</span><strong>${forum.max_members || 'Unlimited'}</strong></div>
                        <div class="d-flex justify-content-between"><span>Created</span><strong>${new Date(forum.created_at).toLocaleString()}</strong></div>
                    </div>
                </div>
            </div>
        `;
    }

    function displayForumStats(forum) {
        const members = forum.members || [];
        const adminCount = members.filter(m => m.role === 'admin').length;
        const moderatorCount = members.filter(m => m.role === 'moderator').length;

        document.getElementById('forum-stats').innerHTML = `
            <div class="card-header bg-white">
                <h5 class="mb-0"><i class="bi bi-bar-chart text-primary me-2"></i> Statistics</h5>
            </div>
            <div class="card-body">
                <div class="row text-center g-3 mb-3">
                    <div class="col-4">
                        <div class="border rounded p-3">
                            <div class="small text-muted">Total</div>
                            <div class="fs-5 fw-bold">${members.length}</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="border rounded p-3">
                            <div class="small text-muted">Admins</div>
                            <div class="fs-5 fw-bold">${adminCount}</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="border rounded p-3">
                            <div class="small text-muted">Mods</div>
                            <div class="fs-5 fw-bold">${moderatorCount}</div>
                        </div>
                    </div>
                </div>
                <div class="mb-2 small text-muted">Capacity</div>
                <div class="progress" style="height: 8px;">
                    <div class="progress-bar" style="width: ${forum.max_members ? Math.min(100, Math.round((members.length / forum.max_members) * 100)) : 100}%"></div>
                </div>
            </div>
        `;
    }

    function displayMembers(members) {
        document.getElementById('members-count').textContent = members.length;

        if (members.length === 0) {
            document.getElementById('members-container').innerHTML = `
                <div class="text-center text-muted py-5">
                    <i class="bi bi-people" style="font-size: 3rem;"></i>
                    <p class="mt-3">No members yet</p>
                </div>
            `;
            return;
        }

        const html = members.map(member => {
            let roleBadge = '';
            if (member.role === 'admin') {
                roleBadge = '<span class="badge bg-success">Admin</span>';
            } else if (member.role === 'moderator') {
                roleBadge = '<span class="badge bg-info">Moderator</span>';
            } else {
                roleBadge = '<span class="badge bg-secondary">Member</span>';
            }

            return `
                <div class="d-flex justify-content-between align-items-center border rounded-3 p-3 mb-3">
                    <div class="d-flex align-items-center">
                        <img src="${member.user?.avatar_url || 'https://ui-avatars.com/api/?name=' + encodeURIComponent(member.user?.name || 'User')}" 
                             class="rounded-circle me-3 border" width="48" height="48" alt="Avatar">
                        <div>
                            <div class="mb-1 d-flex align-items-center gap-2">
                                <a class="fw-semibold text-decoration-none" href="/admin/users/${member.user_id}">${member.user?.name || 'Unknown User'}</a>
                                ${roleBadge}
                            </div>
                            <small class="text-muted">Joined ${new Date(member.created_at).toLocaleDateString()}</small>
                        </div>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            Actions
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            ${member.role !== 'admin' ? `
                                <li><a class="dropdown-item" href="#" onclick="makeAdmin(${member.id}); return false;">
                                    <i class="bi bi-shield-check me-2"></i> Make Admin
                                </a></li>
                            ` : ''}
                            ${member.role !== 'moderator' ? `
                                <li><a class="dropdown-item" href="#" onclick="makeModerator(${member.id}); return false;">
                                    <i class="bi bi-shield me-2"></i> Make Moderator
                                </a></li>
                            ` : ''}
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="#" onclick="removeMember(${member.user_id}); return false;">
                                <i class="bi bi-trash me-2"></i> Remove from Forum
                            </a></li>
                        </ul>
                    </div>
                </div>
            `;
        }).join('');

        document.getElementById('members-container').innerHTML = html;
    }

    function editForum() {
        window.location.href = `/admin/forums/${forumId}/edit`;
    }

    async function makeAdmin(memberId) {
        if (confirm('Make this user a forum admin?')) {
            try {
                const response = await apiRequest(`/admin/forums/${forumId}/make-admin`, 'POST', { 
                    user_id: memberId 
                });
                if (response.status === 200) {
                    showToast('Member promoted to admin', 'success');
                    loadForumDetails();
                }
            } catch (error) {
                showToast('Failed to promote member', 'error');
            }
        }
    }

    async function makeModerator(memberId) {
        if (confirm('Make this user a forum moderator?')) {
            try {
                const response = await apiRequest(`/admin/forums/${forumId}/make-moderator`, 'POST', { 
                    user_id: memberId 
                });
                if (response.status === 200) {
                    showToast('Member promoted to moderator', 'success');
                    loadForumDetails();
                }
            } catch (error) {
                showToast('Failed to promote member', 'error');
            }
        }
    }

    async function removeMember(userId) {
        if (confirm('Remove this member from the forum?')) {
            try {
                const response = await apiRequest(`/admin/forums/${forumId}/remove-member`, 'POST', { 
                    user_id: userId 
                });
                if (response.status === 200) {
                    showToast('Member removed successfully', 'success');
                    loadForumDetails();
                }
            } catch (error) {
                showToast('Failed to remove member', 'error');
            }
        }
    }

    // Search functionality
    document.getElementById('member-search').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const filtered = allMembers.filter(member => 
            (member.user?.name || '').toLowerCase().includes(searchTerm)
        );
        displayMembers(filtered);
    });

    // Load data on page load
    document.addEventListener('DOMContentLoaded', loadForumDetails);
</script>
@endsection


