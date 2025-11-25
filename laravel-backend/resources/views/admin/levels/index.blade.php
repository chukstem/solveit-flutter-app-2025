@extends('layouts.admin')

@section('title', 'Levels')
@section('page-title', 'Levels Management')
@section('page-description', 'Manage academic levels')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Levels</h5>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModal">
                    <i class="bi bi-plus-circle"></i> Add Level
                </button>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Code</th>
                            <th>Department</th>
                            <th>Students</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="levels-table-body">
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
                <h5 class="modal-title">Add Level</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="create-form">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Department</label>
                        <select class="form-select" name="department_id" required></select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Code</label>
                        <input type="text" class="form-control" name="code" required>
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

<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Level</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="edit-form">
                <input type="hidden" id="edit-id">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Department</label>
                        <select class="form-select" id="edit-department_id" required></select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" id="edit-name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Code</label>
                        <input type="text" class="form-control" id="edit-code" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" id="edit-description" rows="3"></textarea>
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
    let allLevels = [];
    let allDepartments = [];

    async function loadLevels() {
        try {
            const response = await apiRequest('/school/levels');
            if (response.status === 200) {
                allLevels = response.data;
                const tbody = document.getElementById('levels-table-body');
                if (!response.data || response.data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="5" class="text-center py-4 text-muted">No levels found</td></tr>';
                    return;
                }
                tbody.innerHTML = response.data.map(level => `
                    <tr>
                        <td><strong>${level.name}</strong></td>
                        <td><span class="badge bg-primary">${level.code}</span></td>
                        <td>${level.department ? level.department.name : 'N/A'}</td>
                        <td><span class="badge bg-info">${level.students_count || 0}</span></td>
                        <td>
                            <div class="btn-group btn-group-sm">
                                <button class="btn btn-outline-warning" onclick="editLevel(${level.id})">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-outline-danger" onclick="deleteLevel(${level.id})">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                `).join('');
            }
        } catch (error) {
            console.error('Error:', error);
        }
    }

    async function loadDepartments() {
        try {
            const response = await apiRequest('/admin/school/getSchoolElements?elementType=Department');
            if (response.status === 200) {
                allDepartments = response.data;
                const selects = document.querySelectorAll('select[name="department_id"], select#edit-department_id');
                selects.forEach(select => {
                    select.innerHTML = '<option value="">Select Department</option>' +
                        response.data.map(d => `<option value="${d.id}">${d.name}</option>`).join('');
                });
            }
        } catch (error) {
            console.error('Error loading departments:', error);
        }
    }

    document.getElementById('create-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        try {
            await apiRequest('/admin/school/createLevel', {
                method: 'POST',
                body: JSON.stringify(Object.fromEntries(formData))
            });
            showToast('Level created', 'success');
            bootstrap.Modal.getInstance(document.getElementById('createModal')).hide();
            e.target.reset();
            loadLevels();
        } catch (error) {
            showToast('Failed to create level', 'danger');
        }
    });

    function editLevel(id) {
        const level = allLevels.find(l => l.id === id);
        if (!level) return;

        document.getElementById('edit-id').value = level.id;
        document.getElementById('edit-name').value = level.name || '';
        document.getElementById('edit-code').value = level.code || '';
        document.getElementById('edit-department_id').value = level.department_id || '';
        document.getElementById('edit-description').value = level.description || '';

        new bootstrap.Modal(document.getElementById('editModal')).show();
    }

    document.getElementById('edit-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const id = document.getElementById('edit-id').value;
        const data = {
            name: document.getElementById('edit-name').value,
            code: document.getElementById('edit-code').value,
            department_id: document.getElementById('edit-department_id').value,
            description: document.getElementById('edit-description').value
        };

        try {
            await apiRequest(`/admin/levels/${id}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            });
            showToast('Level updated successfully', 'success');
            bootstrap.Modal.getInstance(document.getElementById('editModal')).hide();
            loadLevels();
        } catch (error) {
            showToast('Failed to update level', 'danger');
        }
    });

    async function deleteLevel(id) {
        if (!confirm('Delete this level?')) return;
        try {
            await apiRequest(`/admin/levels/${id}`, { method: 'DELETE' });
            showToast('Level deleted', 'success');
            loadLevels();
        } catch (error) {
            showToast('Failed to delete level', 'danger');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        loadDepartments();
        loadLevels();
    });
</script>
@endpush

