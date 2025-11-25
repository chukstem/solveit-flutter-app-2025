@extends('layouts.admin')

@section('title', 'Departments')
@section('page-title', 'Departments Management')
@section('page-description', 'Manage departments')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Departments</h5>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModal">
                    <i class="bi bi-plus-circle"></i> Add Department
                </button>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Code</th>
                            <th>Faculty</th>
                            <th>School</th>
                            <th>Students</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="departments-table-body">
                        <tr><td colspan="6" class="text-center py-5"><div class="spinner-border text-primary"></div></td></tr>
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
                <h5 class="modal-title">Add Department</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="create-form">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Faculty</label>
                        <select class="form-select" name="faculty_id" required></select>
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
                <h5 class="modal-title">Edit Department</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="edit-form">
                <input type="hidden" id="edit-id">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Faculty</label>
                        <select class="form-select" id="edit-faculty_id" required></select>
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
    let allDepartments = [];
    let allFaculties = [];

    async function loadDepartments() {
        try {
            const response = await apiRequest('/admin/school/getSchoolElements?elementType=Department');
            if (response.status === 200) {
                allDepartments = response.data;
                const tbody = document.getElementById('departments-table-body');
                if (!response.data || response.data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-muted">No departments found</td></tr>';
                    return;
                }
                tbody.innerHTML = response.data.map(dept => `
                    <tr>
                        <td><strong>${dept.name}</strong></td>
                        <td><span class="badge bg-primary">${dept.code}</span></td>
                        <td>${dept.faculty ? dept.faculty.name : 'N/A'}</td>
                        <td>${dept.faculty && dept.faculty.school ? dept.faculty.school.name : 'N/A'}</td>
                        <td><span class="badge bg-info">${dept.students_count || 0}</span></td>
                        <td>
                            <div class="btn-group btn-group-sm">
                                <button class="btn btn-outline-warning" onclick="editDepartment(${dept.id})">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-outline-danger" onclick="deleteDepartment(${dept.id})">
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

    async function loadFaculties() {
        try {
            const response = await apiRequest('/admin/school/getSchoolElements?elementType=Faculty');
            if (response.status === 200) {
                allFaculties = response.data;
                const selects = document.querySelectorAll('select[name="faculty_id"], select#edit-faculty_id');
                selects.forEach(select => {
                    select.innerHTML = '<option value="">Select Faculty</option>' +
                        response.data.map(f => `<option value="${f.id}">${f.name}</option>`).join('');
                });
            }
        } catch (error) {
            console.error('Error loading faculties:', error);
        }
    }

    document.getElementById('create-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        try {
            await apiRequest('/admin/school/createDepartment', {
                method: 'POST',
                body: JSON.stringify(Object.fromEntries(formData))
            });
            showToast('Department created', 'success');
            bootstrap.Modal.getInstance(document.getElementById('createModal')).hide();
            e.target.reset();
            loadDepartments();
        } catch (error) {
            showToast('Failed to create department', 'danger');
        }
    });

    function editDepartment(id) {
        const department = allDepartments.find(d => d.id === id);
        if (!department) return;

        document.getElementById('edit-id').value = department.id;
        document.getElementById('edit-name').value = department.name || '';
        document.getElementById('edit-code').value = department.code || '';
        document.getElementById('edit-faculty_id').value = department.faculty_id || '';
        document.getElementById('edit-description').value = department.description || '';

        new bootstrap.Modal(document.getElementById('editModal')).show();
    }

    document.getElementById('edit-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const id = document.getElementById('edit-id').value;
        const data = {
            name: document.getElementById('edit-name').value,
            code: document.getElementById('edit-code').value,
            faculty_id: document.getElementById('edit-faculty_id').value,
            description: document.getElementById('edit-description').value
        };

        try {
            await apiRequest(`/admin/departments/${id}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            });
            showToast('Department updated successfully', 'success');
            bootstrap.Modal.getInstance(document.getElementById('editModal')).hide();
            loadDepartments();
        } catch (error) {
            showToast('Failed to update department', 'danger');
        }
    });

    async function deleteDepartment(id) {
        if (!confirm('Delete this department?')) return;
        try {
            await apiRequest(`/admin/departments/${id}`, { method: 'DELETE' });
            showToast('Department deleted', 'success');
            loadDepartments();
        } catch (error) {
            showToast('Failed to delete department', 'danger');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        loadFaculties();
        loadDepartments();
    });
</script>
@endpush

