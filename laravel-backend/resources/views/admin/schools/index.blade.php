@extends('layouts.admin')

@section('title', 'Schools Management')
@section('page-title', 'Schools Management')
@section('page-description', 'Manage schools and educational institutions')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Schools List</h5>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModal">
                    <i class="bi bi-plus-circle"></i> Add School
                </button>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Code</th>
                            <th>Location</th>
                            <th>Contact</th>
                            <th>Students</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="schools-table-body">
                        <tr><td colspan="6" class="text-center py-5"><div class="spinner-border text-primary"></div></td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Create Modal -->
<div class="modal fade" id="createModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New School</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="create-form">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">School Name</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">School Code</label>
                        <input type="text" class="form-control" name="code" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <input type="text" class="form-control" name="address">
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">City</label>
                            <input type="text" class="form-control" name="city">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">State</label>
                            <input type="text" class="form-control" name="state">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="tel" class="form-control" name="phone">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create School</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit School</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="edit-form">
                <input type="hidden" id="edit-id">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">School Name</label>
                        <input type="text" class="form-control" id="edit-name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">School Code</label>
                        <input type="text" class="form-control" id="edit-code" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <input type="text" class="form-control" id="edit-address">
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">City</label>
                            <input type="text" class="form-control" id="edit-city">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">State</label>
                            <input type="text" class="form-control" id="edit-state">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" id="edit-email">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="tel" class="form-control" id="edit-phone">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update School</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    let allSchools = [];

    async function loadSchools() {
        try {
            const response = await apiRequest('/admin/school/getSchoolElements?elementType=School');
            if (response.status === 200) {
                allSchools = response.data;
                renderSchools(response.data);
            }
        } catch (error) {
            document.getElementById('schools-table-body').innerHTML = 
                '<tr><td colspan="6" class="text-center py-4 text-danger">Failed to load schools</td></tr>';
        }
    }

    function renderSchools(schools) {
        const tbody = document.getElementById('schools-table-body');
        if (!schools || schools.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-muted">No schools found</td></tr>';
            return;
        }

        tbody.innerHTML = schools.map(school => `
            <tr>
                <td><strong>${school.name}</strong></td>
                <td><span class="badge bg-primary">${school.code}</span></td>
                <td>${school.city || ''} ${school.state || ''}</td>
                <td>
                    ${school.email ? `<div>${school.email}</div>` : ''}
                    ${school.phone ? `<div>${school.phone}</div>` : ''}
                </td>
                <td><span class="badge bg-info">${school.users_count || 0} students</span></td>
                <td>
                    <div class="btn-group btn-group-sm">
                        <button class="btn btn-outline-warning" onclick="editSchool(${school.id})">
                            <i class="bi bi-pencil"></i>
                        </button>
                        <button class="btn btn-outline-danger" onclick="deleteSchool(${school.id})">
                            <i class="bi bi-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
        `).join('');
    }

    document.getElementById('create-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);

        try {
            await apiRequest('/admin/school/createSchool', {
                method: 'POST',
                body: JSON.stringify(data)
            });
            showToast('School created successfully', 'success');
            bootstrap.Modal.getInstance(document.getElementById('createModal')).hide();
            e.target.reset();
            loadSchools();
        } catch (error) {
            showToast('Failed to create school', 'danger');
        }
    });

    function editSchool(id) {
        const school = allSchools.find(s => s.id === id);
        if (!school) return;

        document.getElementById('edit-id').value = school.id;
        document.getElementById('edit-name').value = school.name || '';
        document.getElementById('edit-code').value = school.code || '';
        document.getElementById('edit-address').value = school.address || '';
        document.getElementById('edit-city').value = school.city || '';
        document.getElementById('edit-state').value = school.state || '';
        document.getElementById('edit-email').value = school.email || '';
        document.getElementById('edit-phone').value = school.phone || '';

        new bootstrap.Modal(document.getElementById('editModal')).show();
    }

    document.getElementById('edit-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const id = document.getElementById('edit-id').value;
        const data = {
            name: document.getElementById('edit-name').value,
            code: document.getElementById('edit-code').value,
            address: document.getElementById('edit-address').value,
            city: document.getElementById('edit-city').value,
            state: document.getElementById('edit-state').value,
            email: document.getElementById('edit-email').value,
            phone: document.getElementById('edit-phone').value
        };

        try {
            await apiRequest(`/admin/schools/${id}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            });
            showToast('School updated successfully', 'success');
            bootstrap.Modal.getInstance(document.getElementById('editModal')).hide();
            loadSchools();
        } catch (error) {
            showToast('Failed to update school', 'danger');
        }
    });

    async function deleteSchool(id) {
        if (!confirm('Are you sure you want to delete this school?')) return;
        try {
            await apiRequest(`/admin/schools/${id}`, { method: 'DELETE' });
            showToast('School deleted successfully', 'success');
            loadSchools();
        } catch (error) {
            showToast(error.message || 'Failed to delete school', 'danger');
        }
    }

    document.addEventListener('DOMContentLoaded', loadSchools);
</script>
@endpush

