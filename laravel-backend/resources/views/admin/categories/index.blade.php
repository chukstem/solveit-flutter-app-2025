@extends('layouts.admin')

@section('title', 'Categories')
@section('page-title', 'Post Categories')
@section('page-description', 'Manage post categories')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Categories</h5>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModal">
                    <i class="bi bi-plus-circle"></i> Add Category
                </button>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Color</th>
                            <th>Posts</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="categories-table-body">
                        <tr><td colspan="5" class="text-center py-5"><div class="spinner-border text-primary"></div></td></tr>
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
                <h5 class="modal-title">Add Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="create-form">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Color</label>
                        <input type="color" class="form-control" name="color" value="#6366f1">
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

<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="edit-form">
                <input type="hidden" id="edit-id">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" id="edit-name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" id="edit-description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Color</label>
                        <input type="color" class="form-control" id="edit-color" value="#6366f1">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    let allCategories = [];

    async function loadCategories() {
        try {
            const response = await apiRequest('/posts/getCategories');
            if (response.status === 200) {
                allCategories = response.data;
                const tbody = document.getElementById('categories-table-body');
                tbody.innerHTML = response.data.map(cat => `
                    <tr>
                        <td><strong>${cat.name}</strong></td>
                        <td>${cat.description || 'N/A'}</td>
                        <td><span class="badge" style="background-color: ${cat.color || '#6366f1'}">${cat.color}</span></td>
                        <td><span class="badge bg-info">${cat.posts_count || 0} posts</span></td>
                        <td>
                            <div class="btn-group btn-group-sm">
                                <button class="btn btn-outline-warning" onclick="editCategory(${cat.id})">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-outline-danger" onclick="deleteCategory(${cat.id})">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                `).join('');
            }
        } catch (error) {
            console.error('Error loading categories:', error);
        }
    }

    document.getElementById('create-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        try {
            await apiRequest('/admin/category/createPostCategory', {
                method: 'POST',
                body: JSON.stringify(Object.fromEntries(formData))
            });
            showToast('Category created successfully', 'success');
            bootstrap.Modal.getInstance(document.getElementById('createModal')).hide();
            e.target.reset();
            loadCategories();
        } catch (error) {
            showToast('Failed to create category', 'danger');
        }
    });

    function editCategory(id) {
        const category = allCategories.find(c => c.id === id);
        if (!category) return;

        document.getElementById('edit-id').value = category.id;
        document.getElementById('edit-name').value = category.name || '';
        document.getElementById('edit-description').value = category.description || '';
        document.getElementById('edit-color').value = category.color || '#6366f1';

        new bootstrap.Modal(document.getElementById('editModal')).show();
    }

    document.getElementById('edit-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const id = document.getElementById('edit-id').value;
        const data = {
            name: document.getElementById('edit-name').value,
            description: document.getElementById('edit-description').value,
            color: document.getElementById('edit-color').value
        };

        try {
            await apiRequest(`/admin/categories/${id}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            });
            showToast('Category updated successfully', 'success');
            bootstrap.Modal.getInstance(document.getElementById('editModal')).hide();
            loadCategories();
        } catch (error) {
            showToast('Failed to update category', 'danger');
        }
    });

    async function deleteCategory(id) {
        if (!confirm('Delete this category?')) return;
        try {
            await apiRequest(`/admin/categories/${id}`, { method: 'DELETE' });
            showToast('Category deleted', 'success');
            loadCategories();
        } catch (error) {
            showToast('Failed to delete category', 'danger');
        }
    }

    document.addEventListener('DOMContentLoaded', loadCategories);
</script>
@endpush

