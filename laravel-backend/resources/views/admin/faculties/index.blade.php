@extends('layouts.admin')

@section('title', 'Faculties')
@section('page-title', 'Faculties Management')
@section('page-description', 'Manage faculties')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Faculties</h5>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModal">
                    <i class="bi bi-plus-circle"></i> Add Faculty
                </button>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Code</th>
                            <th>School</th>
                            <th>Departments</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="faculties-table-body">
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
                <h5 class="modal-title">Add Faculty</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="create-form">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">School</label>
                        <select class="form-select" name="school_id" required></select>
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
                <h5 class="modal-title">Edit Faculty</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="edit-form">
                <input type="hidden" id="edit-id">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">School</label>
                        <select class="form-select" id="edit-school_id" required></select>
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
    let allFaculties = [];
    let allSchools = [];

    async function loadFaculties() {
        try {
            const response = await apiRequest('/admin/school/getSchoolElements?elementType=Faculty');
            if (response.status === 200) {
                allFaculties = response.data;
                const tbody = document.getElementById('faculties-table-body');
                if (!response.data || response.data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="5" class="text-center py-4 text-muted">No faculties found</td></tr>';
                    return;
                }
                tbody.innerHTML = response.data.map(fac => `
                    <tr>
                        <td><strong>${fac.name}</strong></td>
                        <td><span class="badge bg-primary">${fac.code}</span></td>
                        <td>${fac.school ? fac.school.name : 'N/A'}</td>
                        <td><span class="badge bg-info">${fac.departments_count || 0}</span></td>
                        <td>
                            <div class="btn-group btn-group-sm">
                                <button class="btn btn-outline-warning" onclick="editFaculty(${fac.id})">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-outline-danger" onclick="deleteFaculty(${fac.id})">
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

    async function loadSchools() {
        try {
            const response = await apiRequest('/admin/school/getSchoolElements?elementType=School');
            if (response.status === 200) {
                allSchools = response.data;
                const selects = document.querySelectorAll('select[name="school_id"], select#edit-school_id');
                selects.forEach(select => {
                    select.innerHTML = '<option value="">Select School</option>' +
                        response.data.map(s => `<option value="${s.id}">${s.name}</option>`).join('');
                });
            }
        } catch (error) {
            console.error('Error loading schools:', error);
        }
    }

    document.getElementById('create-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        try {
            await apiRequest('/admin/school/createFaculty', {
                method: 'POST',
                body: JSON.stringify(Object.fromEntries(formData))
            });
            showToast('Faculty created', 'success');
            bootstrap.Modal.getInstance(document.getElementById('createModal')).hide();
            e.target.reset();
            loadFaculties();
        } catch (error) {
            showToast('Failed to create faculty', 'danger');
        }
    });

    function editFaculty(id) {
        const faculty = allFaculties.find(f => f.id === id);
        if (!faculty) return;

        document.getElementById('edit-id').value = faculty.id;
        document.getElementById('edit-name').value = faculty.name || '';
        document.getElementById('edit-code').value = faculty.code || '';
        document.getElementById('edit-school_id').value = faculty.school_id || '';
        document.getElementById('edit-description').value = faculty.description || '';

        new bootstrap.Modal(document.getElementById('editModal')).show();
    }

    document.getElementById('edit-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const id = document.getElementById('edit-id').value;
        const data = {
            name: document.getElementById('edit-name').value,
            code: document.getElementById('edit-code').value,
            school_id: document.getElementById('edit-school_id').value,
            description: document.getElementById('edit-description').value
        };

        try {
            await apiRequest(`/admin/faculties/${id}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            });
            showToast('Faculty updated successfully', 'success');
            bootstrap.Modal.getInstance(document.getElementById('editModal')).hide();
            loadFaculties();
        } catch (error) {
            showToast('Failed to update faculty', 'danger');
        }
    });

    async function deleteFaculty(id) {
        if (!confirm('Delete this faculty?')) return;
        try {
            await apiRequest(`/admin/faculties/${id}`, { method: 'DELETE' });
            showToast('Faculty deleted', 'success');
            loadFaculties();
        } catch (error) {
            showToast('Failed to delete faculty', 'danger');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        loadSchools();
        loadFaculties();
    });
</script>
@endpush

