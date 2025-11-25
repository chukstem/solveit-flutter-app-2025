@extends('layouts.admin')

@section('title', 'Edit Post')

@section('content')
<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 mb-0">Edit Post</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="/admin/posts">Posts</a></li>
                    <li class="breadcrumb-item active">Edit Post</li>
                </ol>
            </nav>
        </div>
        <a href="/admin/posts" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i> Back to Posts
        </a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <form id="edit-post-form">
                <div class="row">
                    <div class="col-md-8">
                        <div class="mb-3">
                            <label class="form-label">Title *</label>
                            <input type="text" class="form-control" id="title" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Excerpt</label>
                            <textarea class="form-control" id="excerpt" rows="2" maxlength="500"></textarea>
                            <small class="text-muted">Brief summary (max 500 characters)</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Content *</label>
                            <textarea class="form-control" id="body" rows="10" required></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Tags</label>
                            <input type="text" class="form-control" id="tags" placeholder="tag1, tag2, tag3">
                            <small class="text-muted">Comma-separated tags</small>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card mb-3">
                            <div class="card-header bg-light">
                                <h6 class="mb-0">Post Settings</h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label">Category *</label>
                                    <select class="form-select" id="news_category_id" required>
                                        <option value="">Loading...</option>
                                    </select>
                                </div>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="is_published">
                                    <label class="form-check-label" for="is_published">
                                        Published
                                    </label>
                                </div>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="featured">
                                    <label class="form-check-label" for="featured">
                                        Featured
                                    </label>
                                </div>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="enable_comments">
                                    <label class="form-check-label" for="enable_comments">
                                        Enable Comments
                                    </label>
                                </div>

                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="enable_reactions">
                                    <label class="form-check-label" for="enable_reactions">
                                        Enable Reactions
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header bg-light">
                                <h6 class="mb-0">Targeting</h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label">Faculties</label>
                                    <input type="text" class="form-control" id="faculties" placeholder="faculty1, faculty2">
                                    <small class="text-muted">Comma-separated</small>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Departments</label>
                                    <input type="text" class="form-control" id="departments" placeholder="dept1, dept2">
                                    <small class="text-muted">Comma-separated</small>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Levels</label>
                                    <input type="text" class="form-control" id="levels" placeholder="100, 200, 300">
                                    <small class="text-muted">Comma-separated</small>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Interests</label>
                                    <input type="text" class="form-control" id="interests" placeholder="sports, tech">
                                    <small class="text-muted">Comma-separated</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a href="/admin/posts" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-2"></i> Update Post
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    const postId = window.location.pathname.split('/')[3];
    let currentPost = null;

    async function loadCategories() {
        try {
            const response = await fetch(`${API_URL}/posts/getCategories`, {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('admin_token')}`,
                    'Accept': 'application/json'
                }
            });
            
            if (response.ok) {
                const data = await response.json();
                const categories = data.data || [];
                const select = document.getElementById('news_category_id');
                select.innerHTML = '<option value="">Select Category</option>' +
                    categories.map(cat => `<option value="${cat.id}">${cat.name}</option>`).join('');
            }
        } catch (error) {
            console.error('Error loading categories:', error);
        }
    }

    async function loadPost() {
        try {
            const response = await fetch(`${API_URL}/posts/getPostElements/${postId}`, {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('admin_token')}`,
                    'Accept': 'application/json'
                }
            });
            
            if (response.ok) {
                const data = await response.json();
                currentPost = data.data;
                populateForm(currentPost);
            } else {
                showToast('Failed to load post', 'error');
                setTimeout(() => window.location.href = '/admin/posts', 2000);
            }
        } catch (error) {
            console.error('Error:', error);
            showToast('Failed to load post', 'error');
        }
    }

    function populateForm(post) {
        document.getElementById('title').value = post.title || '';
        document.getElementById('excerpt').value = post.excerpt || '';
        document.getElementById('body').value = post.body || '';
        document.getElementById('tags').value = post.tags || '';
        document.getElementById('news_category_id').value = post.news_category_id || '';
        document.getElementById('faculties').value = post.faculties || '';
        document.getElementById('departments').value = post.departments || '';
        document.getElementById('levels').value = post.levels || '';
        document.getElementById('interests').value = post.interests || '';
        document.getElementById('is_published').checked = post.is_published || false;
        document.getElementById('featured').checked = post.featured || false;
        document.getElementById('enable_comments').checked = post.enable_comments !== false;
        document.getElementById('enable_reactions').checked = post.enable_reactions !== false;
    }

    document.getElementById('edit-post-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const formData = {
            title: document.getElementById('title').value,
            excerpt: document.getElementById('excerpt').value,
            body: document.getElementById('body').value,
            tags: document.getElementById('tags').value,
            news_category_id: document.getElementById('news_category_id').value,
            faculties: document.getElementById('faculties').value,
            departments: document.getElementById('departments').value,
            levels: document.getElementById('levels').value,
            interests: document.getElementById('interests').value,
            is_published: document.getElementById('is_published').checked,
            featured: document.getElementById('featured').checked,
            enable_comments: document.getElementById('enable_comments').checked,
            enable_reactions: document.getElementById('enable_reactions').checked
        };

        try {
            const response = await apiRequest(`/admin/post/updatePost/${postId}`, 'PUT', formData);
            
            if (response.status === 200) {
                showToast('Post updated successfully!', 'success');
                setTimeout(() => window.location.href = '/admin/posts', 1500);
            } else {
                showToast(response.message || 'Failed to update post', 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            showToast('Failed to update post', 'error');
        }
    });

    // Load data on page load
    document.addEventListener('DOMContentLoaded', function() {
        loadCategories();
        loadPost();
    });
</script>
@endsection


