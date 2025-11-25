@extends('layouts.admin')

@section('title', 'View Post')

@section('content')
<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 mb-0">Post Details</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="/admin/posts">Posts</a></li>
                    <li class="breadcrumb-item active">View Post</li>
                </ol>
            </nav>
        </div>
        <div>
            <a href="/admin/posts" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i> Back to Posts
            </a>
            <button class="btn btn-primary" onclick="editPost()">
                <i class="bi bi-pencil me-2"></i> Edit Post
            </button>
        </div>
    </div>

    <!-- Post Details Card -->
    <div class="card shadow-sm mb-4">
        <div class="card-body" id="post-details">
            <div class="d-flex justify-content-center align-items-center" style="min-height: 300px;">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Comments Section -->
    <div class="card shadow-sm">
        <div class="card-header bg-white border-bottom">
            <h5 class="mb-0">
                <i class="bi bi-chat-dots text-primary me-2"></i> Comments
                <span class="badge bg-primary ms-2" id="comments-count">0</span>
            </h5>
        </div>
        <div class="card-body" id="comments-section">
            <div class="d-flex justify-content-center align-items-center" style="min-height: 200px;">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const postId = window.location.pathname.split('/').pop();
    let currentPost = null;

    async function loadPostDetails() {
        try {
            const response = await apiRequest(`/posts/getPostElements/${postId}`);
            if (response.status === 200) {
                currentPost = response.data;
                displayPostDetails(currentPost);
            }
            loadComments();
        } catch (error) {
            console.error('Error:', error);
            document.getElementById('post-details').innerHTML = `
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle me-2"></i> Failed to load post details
                </div>
            `;
        }
    }

    function displayPostDetails(post) {
        const statusBadge = post.is_published 
            ? '<span class="badge bg-success">Published</span>' 
            : '<span class="badge bg-warning">Draft</span>';
        
        const featuredBadge = post.featured 
            ? '<span class="badge bg-primary ms-2">Featured</span>' 
            : '';

        document.getElementById('post-details').innerHTML = `
            <div class="row">
                <div class="col-md-8">
                    <div class="mb-4">
                        <h2 class="mb-3">${post.title}</h2>
                        ${statusBadge} ${featuredBadge}
                    </div>
                    
                    ${post.excerpt ? `
                        <div class="alert alert-info mb-4">
                            <strong>Excerpt:</strong> ${post.excerpt}
                        </div>
                    ` : ''}
                    
                    <div class="mb-4">
                        <h5 class="mb-3">Content</h5>
                        <div class="border rounded p-3 bg-light">
                            ${post.body || 'No content'}
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="card mb-3">
                        <div class="card-body">
                            <h6 class="card-title mb-3">Post Information</h6>
                            <div class="mb-2">
                                <small class="text-muted">Author:</small><br>
                                <strong>${post.user?.name || 'Unknown'}</strong>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted">Category:</small><br>
                                <strong>${post.category?.name || 'Uncategorized'}</strong>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted">School:</small><br>
                                <strong>${post.school?.name || 'N/A'}</strong>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted">Created:</small><br>
                                <strong>${new Date(post.created_at).toLocaleString()}</strong>
                            </div>
                            ${post.published_at ? `
                                <div class="mb-2">
                                    <small class="text-muted">Published:</small><br>
                                    <strong>${new Date(post.published_at).toLocaleString()}</strong>
                                </div>
                            ` : ''}
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-body">
                            <h6 class="card-title mb-3">Settings</h6>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" ${post.enable_comments ? 'checked' : ''} disabled>
                                <label class="form-check-label">Enable Comments</label>
                            </div>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" ${post.enable_reactions ? 'checked' : ''} disabled>
                                <label class="form-check-label">Enable Reactions</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" ${post.featured ? 'checked' : ''} disabled>
                                <label class="form-check-label">Featured Post</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    async function loadComments() {
        try {
            const response = await apiRequest(`/posts/getComments/${postId}`);
            
            if (response.status === 200) {
                const comments = (response.data && response.data.data) ? response.data.data : [];
                document.getElementById('comments-count').textContent = comments.length;
                displayComments(comments);
            }
        } catch (error) {
            console.error('Error:', error);
            document.getElementById('comments-section').innerHTML = `
                <div class="alert alert-warning">
                    <i class="bi bi-exclamation-triangle me-2"></i> Failed to load comments
                </div>
            `;
        }
    }

    function displayComments(comments) {
        if (comments.length === 0) {
            document.getElementById('comments-section').innerHTML = `
                <div class="text-center text-muted py-5">
                    <i class="bi bi-chat-dots" style="font-size: 3rem;"></i>
                    <p class="mt-3">No comments yet</p>
                </div>
            `;
            return;
        }

        const html = comments.map(comment => `
            <div class="border-bottom pb-3 mb-3">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <div class="d-flex align-items-center">
                        <img src="${comment.user?.avatar_url || 'https://ui-avatars.com/api/?name=' + encodeURIComponent(comment.user?.name || 'User')}" 
                             class="rounded-circle me-2" width="40" height="40" alt="Avatar">
                        <div>
                            <strong>${comment.user?.name || 'Unknown User'}</strong>
                            <br>
                            <small class="text-muted">${new Date(comment.created_at).toLocaleString()}</small>
                        </div>
                    </div>
                    <div>
                        <button class="btn btn-sm btn-outline-primary" onclick="editComment(${comment.id})">
                            <i class="bi bi-pencil"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-danger" onclick="deleteComment(${comment.id})">
                            <i class="bi bi-trash"></i>
                        </button>
                    </div>
                </div>
                <p class="mb-0">${comment.content}</p>
            </div>
        `).join('');

        document.getElementById('comments-section').innerHTML = html;
    }

    function editPost() {
        window.location.href = `/admin/posts/${postId}/edit`;
    }

    async function editComment(commentId) {
        const content = prompt('Edit comment:');
        if (content) {
            try {
                const response = await apiRequest(`/posts/updateComment/${commentId}`, { method: 'PUT', body: JSON.stringify({ body: content }) });
                if (response.status === 200) {
                    showToast('Comment updated successfully', 'success');
                    loadComments();
                }
            } catch (error) {
                showToast('Failed to update comment', 'error');
            }
        }
    }

    async function deleteComment(commentId) {
        if (confirm('Are you sure you want to delete this comment?')) {
            try {
                const response = await apiRequest(`/posts/deleteComment/${commentId}`, { method: 'DELETE' });
                if (response.status === 200) {
                    showToast('Comment deleted successfully', 'success');
                    loadComments();
                }
            } catch (error) {
                showToast('Failed to delete comment', 'error');
            }
        }
    }

    // Load data on page load
    document.addEventListener('DOMContentLoaded', loadPostDetails);
</script>
@endsection


