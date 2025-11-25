@extends('layouts.admin')

@section('title', 'Post Comments')

@section('content')
<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 mb-0">Post Comments</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="/admin/posts">Posts</a></li>
                    <li class="breadcrumb-item active">Comments</li>
                </ol>
            </nav>
        </div>
        <a href="/admin/posts" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i> Back to Posts
        </a>
    </div>

    <!-- Post Info Card -->
    <div class="card shadow-sm mb-4" id="post-info">
        <div class="card-body">
            <div class="d-flex justify-content-center">
                <div class="spinner-border text-primary" role="status"></div>
            </div>
        </div>
    </div>

    <!-- Comments Card -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <i class="bi bi-chat-dots text-primary me-2"></i> Comments
                <span class="badge bg-primary ms-2" id="total-comments">0</span>
            </h5>
        </div>
        <div class="card-body">
            <div id="comments-container">
                <div class="d-flex justify-content-center py-5">
                    <div class="spinner-border text-primary" role="status"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Comment Modal -->
<div class="modal fade" id="editCommentModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Comment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="edit-comment-form">
                    <input type="hidden" id="edit-comment-id">
                    <div class="mb-3">
                        <label class="form-label">Comment Content</label>
                        <textarea class="form-control" id="edit-comment-content" rows="4" required></textarea>
                    </div>
                    <div class="d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    const postId = window.location.pathname.split('/')[3];
    let editModal;

    async function loadPostInfo() {
        try {
            const response = await fetch(`${API_URL}/posts/getPostElements/${postId}`, {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('admin_token')}`,
                    'Accept': 'application/json'
                }
            });
            
            if (response.ok) {
                const data = await response.json();
                displayPostInfo(data.data);
            }
        } catch (error) {
            console.error('Error:', error);
        }
    }

    function displayPostInfo(post) {
        document.getElementById('post-info').innerHTML = `
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h5 class="mb-1">${post.title}</h5>
                    <small class="text-muted">
                        by ${post.user?.name || 'Unknown'} • 
                        ${new Date(post.created_at).toLocaleDateString()}
                    </small>
                </div>
                <a href="/admin/posts/${postId}" class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-eye me-1"></i> View Post
                </a>
            </div>
        `;
    }

    async function loadComments() {
        try {
            const response = await apiRequest(`/posts/getComments/${postId}`);
            
            if (response.status === 200) {
                const comments = (response.data && response.data.data) ? response.data.data : [];
                document.getElementById('total-comments').textContent = Array.isArray(comments) ? comments.length : 0;
                displayComments(Array.isArray(comments) ? comments : []);
            }
        } catch (error) {
            console.error('Error:', error);
            document.getElementById('comments-container').innerHTML = `
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle me-2"></i> Failed to load comments
                </div>
            `;
        }
    }

    function displayComments(comments) {
        if (!Array.isArray(comments)) {
            comments = [];
        }
        if (comments.length === 0) {
            document.getElementById('comments-container').innerHTML = `
                <div class="text-center text-muted py-5">
                    <i class="bi bi-chat-dots" style="font-size: 3rem;"></i>
                    <p class="mt-3">No comments yet</p>
                </div>
            `;
            return;
        }

        const html = comments.map(comment => `
            <div class="card mb-3">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="d-flex align-items-start flex-grow-1">
                            <img src="${comment.user?.avatar_url || 'https://ui-avatars.com/api/?name=' + encodeURIComponent(comment.user?.name || 'User')}" 
                                 class="rounded-circle me-3" width="48" height="48" alt="Avatar">
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div>
                                        <strong>${comment.user?.name || 'Unknown User'}</strong>
                                        <small class="text-muted ms-2">${new Date(comment.created_at).toLocaleString()}</small>
                                    </div>
                                </div>
                                <p class="mb-2">${comment.content}</p>
                                ${comment.updated_at !== comment.created_at ? '<small class="text-muted"><i class="bi bi-pencil"></i> Edited</small>' : ''}
                            </div>
                        </div>
                        <div class="dropdown">
                            <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-three-dots-vertical"></i>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" onclick="editComment(${comment.id}, '${escapeHtml(comment.content)}'); return false;">
                                    <i class="bi bi-pencil me-2"></i> Edit
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="#" onclick="deleteComment(${comment.id}); return false;">
                                    <i class="bi bi-trash me-2"></i> Delete
                                </a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        `).join('');

        document.getElementById('comments-container').innerHTML = html;
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML.replace(/'/g, '\\\'');
    }

    function editComment(commentId, content) {
        document.getElementById('edit-comment-id').value = commentId;
        document.getElementById('edit-comment-content').value = content.replace(/\\'/g, "'");
        editModal.show();
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

    document.getElementById('edit-comment-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const commentId = document.getElementById('edit-comment-id').value;
        const content = document.getElementById('edit-comment-content').value;

        try {
        const response = await apiRequest(`/posts/updateComment/${commentId}`, { method: 'PUT', body: JSON.stringify({ body: content }) });
            if (response.status === 200) {
                showToast('Comment updated successfully', 'success');
                editModal.hide();
                loadComments();
            }
        } catch (error) {
            showToast('Failed to update comment', 'error');
        }
    });

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        editModal = new bootstrap.Modal(document.getElementById('editCommentModal'));
        loadPostInfo();
        loadComments();
    });
</script>
@endsection


