@extends('layouts.admin')

@section('title', 'Posts Management')
@section('page-title', 'Posts Management')
@section('page-description', 'Manage all posts, comments, and content')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Posts List</h5>
                <div class="d-flex gap-2">
                    <div class="search-bar">
                        <i class="bi bi-search"></i>
                        <input type="text" class="form-control" id="search-input" placeholder="Search posts...">
                    </div>
                    <a href="{{ route('admin.posts.create') }}" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Create Post
                    </a>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Comments</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="posts-table-body">
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
    async function loadPosts() {
        try {
            const response = await apiRequest('/posts/getPostElements');
            if (response.status === 200) {
                renderPosts(response.data.data);
            }
        } catch (error) {
            document.getElementById('posts-table-body').innerHTML = 
                '<tr><td colspan="7" class="text-center py-4 text-danger">Failed to load posts</td></tr>';
        }
    }

    function renderPosts(posts) {
        const tbody = document.getElementById('posts-table-body');
        if (!posts || posts.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center py-4 text-muted">No posts found</td></tr>';
            return;
        }

        tbody.innerHTML = posts.map(post => `
            <tr>
                <td>
                    <strong>${post.title}</strong>
                    ${post.featured ? '<span class="badge bg-warning ms-2">Featured</span>' : ''}
                </td>
                <td>${post.user ? post.user.name : 'N/A'}</td>
                <td>${post.category ? post.category.name : 'N/A'}</td>
                <td>
                    <span class="badge bg-${post.is_published ? 'success' : 'warning'}">
                        ${post.is_published ? 'Published' : 'Draft'}
                    </span>
                </td>
                <td><span class="badge bg-info">${post.comments_count || 0}</span></td>
                <td>${new Date(post.created_at).toLocaleDateString()}</td>
                <td>
                    <div class="btn-group btn-group-sm">
                        <a href="/admin/posts/${post.id}" class="btn btn-outline-primary">
                            <i class="bi bi-eye"></i>
                        </a>
                        <a href="/admin/posts/${post.id}/edit" class="btn btn-outline-warning">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <a href="/admin/posts/${post.id}/comments" class="btn btn-outline-info">
                            <i class="bi bi-chat"></i>
                        </a>
                        <button class="btn btn-outline-danger" onclick="deletePost(${post.id})">
                            <i class="bi bi-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
        `).join('');
    }

    async function deletePost(id) {
        if (!confirm('Are you sure you want to delete this post?')) return;
        try {
            await apiRequest(`/admin/post/deletePost/${id}`, { method: 'DELETE' });
            showToast('Post deleted successfully', 'success');
            loadPosts();
        } catch (error) {
            showToast('Failed to delete post', 'danger');
        }
    }

    document.addEventListener('DOMContentLoaded', loadPosts);
</script>
@endpush


