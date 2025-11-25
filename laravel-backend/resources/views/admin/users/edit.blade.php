@extends('layouts.admin')

@section('title', 'Edit User')
@section('page-title', 'Edit User')
@section('page-description', 'Update user information and settings')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">User Information</h5>
                <a href="{{ route('admin.users.index') }}" class="btn btn-sm btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Users
                </a>
            </div>
            <div class="p-4">
                <form id="edit-user-form">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="name" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone</label>
                            <input type="tel" class="form-control" id="phone">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Matric Number</label>
                            <input type="text" class="form-control" id="matric_number">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">School</label>
                            <select class="form-select" id="school_id"></select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Faculty</label>
                            <select class="form-select" id="faculty_id"></select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Department</label>
                            <select class="form-select" id="department_id"></select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Level</label>
                            <select class="form-select" id="level_id"></select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Role</label>
                            <select class="form-select" id="role_id"></select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Status</label>
                            <div class="d-flex gap-3 mt-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="is_verified">
                                    <label class="form-check-label" for="is_verified">Verified</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="is_active">
                                    <label class="form-check-label" for="is_active">Active</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i> Update User
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    const userId = {{ $id }};

    async function loadUser() {
        try {
            const response = await apiRequest(`/admin/users/${userId}`);
            if (response.status === 200) {
                const user = response.data;
                document.getElementById('name').value = user.name;
                document.getElementById('email').value = user.email;
                document.getElementById('phone').value = user.phone || '';
                document.getElementById('matric_number').value = user.matric_number || '';
                document.getElementById('is_verified').checked = user.is_verified;
                document.getElementById('is_active').checked = user.is_active;
                
                // Preselect and load dependent dropdowns
                if (user.school_id) {
                    document.getElementById('school_id').value = user.school_id;
                    await loadFaculties(user.school_id);
                }
                if (user.faculty_id) {
                    document.getElementById('faculty_id').value = user.faculty_id;
                    await loadDepartments(user.faculty_id);
                }
                if (user.department_id) document.getElementById('department_id').value = user.department_id;
                if (user.level_id) document.getElementById('level_id').value = user.level_id;
                if (user.role_id) document.getElementById('role_id').value = user.role_id;
            }
        } catch (error) {
            showToast('Failed to load user', 'danger');
        }
    }

    async function loadDropdowns() {
        try {
            const [schools, roles, levels] = await Promise.all([
                apiRequest('/admin/school/getSchoolElements?elementType=School'),
                apiRequest('/admin/roles/getRoles'),
                apiRequest('/school/levels')
            ]);

            if (schools.status === 200) {
                const schoolSelect = document.getElementById('school_id');
                schoolSelect.innerHTML = '<option value="">Select School</option>' +
                    schools.data.map(s => `<option value="${s.id}">${s.name}</option>`).join('');
            }

            if (roles.status === 200) {
                const roleSelect = document.getElementById('role_id');
                roleSelect.innerHTML = '<option value="">Select Role</option>' +
                    roles.data.map(r => `<option value="${r.id}">${r.display_name || r.name}</option>`).join('');
            }

            if (levels.status === 200) {
                const levelSelect = document.getElementById('level_id');
                levelSelect.innerHTML = '<option value="">Select Level</option>' +
                    (levels.data || []).map(l => `<option value="${l.id}">${l.name}</option>`).join('');
            }
        } catch (error) {
            console.error('Error loading dropdowns:', error);
        }
    }

    async function loadFaculties(schoolId) {
        const facultySelect = document.getElementById('faculty_id');
        const departmentSelect = document.getElementById('department_id');
        if (!schoolId) {
            facultySelect.innerHTML = '<option value="">Select Faculty</option>';
            departmentSelect.innerHTML = '<option value="">Select Department</option>';
            return;
        }
        try {
            const res = await apiRequest(`/admin/school/faculty/${schoolId}`);
            if (res.status === 200) {
                facultySelect.innerHTML = '<option value="">Select Faculty</option>' +
                    (res.data || []).map(f => `<option value="${f.id}">${f.name}</option>`).join('');
            }
        } catch (e) {
            facultySelect.innerHTML = '<option value="">Select Faculty</option>';
        }
        // Reset departments when school changes
        departmentSelect.innerHTML = '<option value="">Select Department</option>';
    }

    async function loadDepartments(facultyId) {
        const departmentSelect = document.getElementById('department_id');
        if (!facultyId) {
            departmentSelect.innerHTML = '<option value="">Select Department</option>';
            return;
        }
        try {
            const res = await apiRequest(`/admin/school/department/${facultyId}`);
            if (res.status === 200) {
                departmentSelect.innerHTML = '<option value="">Select Department</option>' +
                    (res.data || []).map(d => `<option value="${d.id}">${d.name}</option>`).join('');
            }
        } catch (e) {
            departmentSelect.innerHTML = '<option value="">Select Department</option>';
        }
    }

    document.getElementById('edit-user-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const data = {
            name: document.getElementById('name').value,
            email: document.getElementById('email').value,
            phone: document.getElementById('phone').value,
            matric_number: document.getElementById('matric_number').value,
            school_id: document.getElementById('school_id').value,
            faculty_id: document.getElementById('faculty_id').value,
            department_id: document.getElementById('department_id').value,
            level_id: document.getElementById('level_id').value,
            role_id: document.getElementById('role_id').value,
            is_verified: document.getElementById('is_verified').checked,
            is_active: document.getElementById('is_active').checked
        };

        try {
            const response = await apiRequest(`/admin/users/${userId}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            });

            if (response.status === 200) {
                showToast('User updated successfully', 'success');
                setTimeout(() => window.location.href = '/admin/users', 1500);
            }
        } catch (error) {
            showToast('Failed to update user', 'danger');
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        // Bind cascading selects
        document.getElementById('school_id').addEventListener('change', function(e) {
            loadFaculties(e.target.value);
        });
        document.getElementById('faculty_id').addEventListener('change', function(e) {
            loadDepartments(e.target.value);
        });

        loadDropdowns().then(() => loadUser());
    });
</script>
@endpush


