@extends('layouts.admin')

@section('title', 'KYC Verification Management')
@section('page-title', 'KYC Verification Management')
@section('page-description', 'Manage user verification requests and status')

@section('content')
<div class="row g-4">
    <!-- Statistics Cards -->
    <div class="col-md-6 col-xl-3">
        <div class="stat-card animate-fade-in">
            <div class="stat-icon primary">
                <i class="bi bi-people"></i>
            </div>
            <div class="stat-value" id="total-users">-</div>
            <div class="stat-label">Total Users</div>
            <div class="stat-change">
                <i class="bi bi-arrow-up"></i> <span id="users-change">0%</span> this month
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="stat-card animate-fade-in" style="animation-delay: 0.1s">
            <div class="stat-icon warning">
                <i class="bi bi-clock"></i>
            </div>
            <div class="stat-value" id="pending-bvn">-</div>
            <div class="stat-label">Pending BVN</div>
            <div class="stat-change">
                <i class="bi bi-arrow-up"></i> <span id="bvn-change">0%</span> this month
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="stat-card animate-fade-in" style="animation-delay: 0.2s">
            <div class="stat-icon info">
                <i class="bi bi-credit-card"></i>
            </div>
            <div class="stat-value" id="pending-id">-</div>
            <div class="stat-label">Pending ID Card</div>
            <div class="stat-change">
                <i class="bi bi-arrow-up"></i> <span id="id-change">0%</span> this month
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="stat-card animate-fade-in" style="animation-delay: 0.3s">
            <div class="stat-icon secondary">
                <i class="bi bi-camera"></i>
            </div>
            <div class="stat-value" id="pending-selfie">-</div>
            <div class="stat-label">Pending Selfie</div>
            <div class="stat-change">
                <i class="bi bi-arrow-up"></i> <span id="selfie-change">0%</span> this month
            </div>
        </div>
    </div>

    <!-- Filters Card -->
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Verification Filters</h5>
            </div>
            <div class="p-3">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Search</label>
                        <div class="search-bar">
                            <i class="bi bi-search"></i>
                            <input type="text" id="search-input" class="form-control" placeholder="Search by name, email, or phone">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Status</label>
                        <select id="status-filter" class="form-select">
                            <option value="">Show All</option>
                            <option value="pending" selected>Pending</option>
                            <option value="verified">Verified</option>
                            <option value="rejected">Rejected</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Verification Type</label>
                        <select id="type-filter" class="form-select">
                            <option value="">All Types</option>
                            <option value="bvn">BVN</option>
                            <option value="id_card">ID Card</option>
                            <option value="selfie">Selfie</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-flex gap-2">
                            <button onclick="loadVerifications()" class="btn btn-primary flex-fill">
                                <i class="bi bi-search"></i> Filter
                            </button>
                            <button onclick="clearFilters()" class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Verifications Table -->
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Verification Requests</h5>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>BVN Status</th>
                            <th>ID Card Status</th>
                            <th>Selfie Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="verifications-table">
                        <tr>
                            <td colspan="5" class="text-center py-5">
                                <div class="spinner-border text-primary"></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div id="pagination" class="p-3 border-top">
                <!-- Pagination will be loaded here -->
            </div>
        </div>
    </div>
</div>

<!-- Action Modal -->
<div class="modal fade" id="actionModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modal-title">Update Verification Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="action-form">
                    <input type="hidden" id="modal-user-id">
                    <input type="hidden" id="modal-verification-type">
                    
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select id="modal-status" class="form-select">
                            <option value="verified">Approve</option>
                            <option value="rejected">Reject</option>
                        </select>
                    </div>
                    
                    <div class="mb-3" id="rejection-reason-container" style="display: none;">
                        <label class="form-label">Rejection Reason</label>
                        <textarea id="modal-rejection-reason" rows="3" class="form-control" placeholder="Enter reason for rejection..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="submitAction()">Update Status</button>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    let currentPage = 1;
    let totalPages = 1;
    const API_BASE = '/api/v1/admin/verification';
    const AUTH_TOKEN = localStorage.getItem('admin_token') || '{{ csrf_token() }}';

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
        // Check if user is authenticated
        const adminToken = localStorage.getItem('admin_token');
        if (!adminToken) {
            console.error('No admin token found. Redirecting to login...');
            window.location.href = '/admin/login';
            return;
        }
        
        console.log('Admin token found:', adminToken.substring(0, 20) + '...');
        
        loadStats();
        loadVerifications();
        
        // Event listeners
        document.getElementById('modal-status').addEventListener('change', function() {
            const rejectionContainer = document.getElementById('rejection-reason-container');
            if (this.value === 'rejected') {
                rejectionContainer.style.display = 'block';
            } else {
                rejectionContainer.style.display = 'none';
            }
        });
    });

    // Load verification statistics
    async function loadStats() {
        try {
            console.log('Loading stats from:', `${API_BASE}/stats`);
            const response = await fetch(`${API_BASE}/stats`, {
                headers: {
                    'Authorization': `Bearer ${AUTH_TOKEN}`,
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            });
            
            console.log('Stats response status:', response.status);
            
            if (response.ok) {
                const data = await response.json();
                console.log('Stats data:', data);
                const stats = data.data;
                
                document.getElementById('total-users').textContent = stats.total_users || 0;
                document.getElementById('pending-bvn').textContent = stats.bvn_stats.pending || 0;
                document.getElementById('pending-id').textContent = stats.id_card_stats.pending || 0;
                document.getElementById('pending-selfie').textContent = stats.selfie_stats.pending || 0;
            } else {
                const errorData = await response.json();
                console.error('Stats API error:', errorData);
                // Set default values
                document.getElementById('total-users').textContent = '0';
                document.getElementById('pending-bvn').textContent = '0';
                document.getElementById('pending-id').textContent = '0';
                document.getElementById('pending-selfie').textContent = '0';
                
                // Show error message
                showNotification('Failed to load statistics. Please check your authentication.', 'error');
            }
        } catch (error) {
            console.error('Error loading stats:', error);
            // Set default values
            document.getElementById('total-users').textContent = '0';
            document.getElementById('pending-bvn').textContent = '0';
            document.getElementById('pending-id').textContent = '0';
            document.getElementById('pending-selfie').textContent = '0';
            
            // Show error message
            showNotification('Failed to load statistics. Please check your connection.', 'error');
        }
    }

    // Load verifications with filters
    async function loadVerifications(page = 1) {
        try {
            const search = document.getElementById('search-input').value;
            const status = document.getElementById('status-filter').value;
            const type = document.getElementById('type-filter').value;
            
            let url = `${API_BASE}/all?page=${page}&per_page=15`;
            
            // Only add filters if they have values
            if (search && search.trim()) url += `&search=${encodeURIComponent(search.trim())}`;
            if (status && status !== '') url += `&status=${status}`;
            if (type && type !== '') url += `&verification_type=${type}`;
            
            console.log('Loading verifications from:', url);
            
            const response = await fetch(url, {
                headers: {
                    'Authorization': `Bearer ${AUTH_TOKEN}`,
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            });
            
            console.log('Verifications response status:', response.status);
            
            if (response.ok) {
                const data = await response.json();
                console.log('Verifications data:', data);
                displayVerifications(data.data.verifications);
                displayPagination(data.data.pagination);
                currentPage = page;
            } else {
                const errorData = await response.json();
                console.error('Verifications API error:', errorData);
                displayVerifications([]);
                showNotification('Failed to load verifications. Please check your authentication.', 'error');
            }
        } catch (error) {
            console.error('Error loading verifications:', error);
            displayVerifications([]);
            showNotification('Failed to load verifications. Please check your connection.', 'error');
        }
    }

    // Display verifications in table
    function displayVerifications(verifications) {
        const tbody = document.getElementById('verifications-table');
        tbody.innerHTML = '';
        
        if (verifications.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center py-5 text-muted">No verification requests found</td></tr>';
            return;
        }
        
        verifications.forEach(verification => {
            const user = verification.user;
            const status = verification.verification_status;
            
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>
                    <div class="d-flex align-items-center">
                        <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3">
                            ${user.name.charAt(0).toUpperCase()}
                        </div>
                        <div>
                            <div class="fw-semibold">${user.name}</div>
                            <div class="text-muted small">${user.email}</div>
                            <div class="text-muted small">${user.phone || 'N/A'}</div>
                        </div>
                    </div>
                </td>
                <td>
                    <span class="badge ${getStatusClass(status.bvn.status)}">${status.bvn.status}</span>
                    ${status.bvn.status === 'pending' ? `<button onclick="openActionModal(${user.id}, 'bvn')" class="btn btn-sm btn-outline-primary ms-2">Review</button>` : ''}
                </td>
                <td>
                    <span class="badge ${getStatusClass(status.id_card.status)}">${status.id_card.status}</span>
                    ${status.id_card.status === 'pending' ? `<button onclick="openActionModal(${user.id}, 'id_card')" class="btn btn-sm btn-outline-primary ms-2">Review</button>` : ''}
                </td>
                <td>
                    <span class="badge ${getStatusClass(status.selfie.status)}">${status.selfie.status}</span>
                    ${status.selfie.status === 'pending' ? `<button onclick="openActionModal(${user.id}, 'selfie')" class="btn btn-sm btn-outline-primary ms-2">Review</button>` : ''}
                </td>
                <td>
                    <button onclick="viewDetails(${user.id})" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-eye"></i> View Details
                    </button>
                </td>
            `;
            tbody.appendChild(row);
        });
    }

    // Get status CSS class
    function getStatusClass(status) {
        switch (status) {
            case 'verified': return 'bg-success';
            case 'rejected': return 'bg-danger';
            case 'pending': return 'bg-warning';
            default: return 'bg-secondary';
        }
    }

    // Display pagination
    function displayPagination(pagination) {
        const container = document.getElementById('pagination');
        let html = '<div class="d-flex justify-content-between align-items-center">';
        
        html += `<div class="text-muted">
            Showing ${pagination.from || 0} to ${pagination.to || 0} of ${pagination.total} results
        </div>`;
        
        html += '<nav><ul class="pagination pagination-sm mb-0">';
        
        if (pagination.current_page > 1) {
            html += `<li class="page-item"><a class="page-link" href="#" onclick="loadVerifications(${pagination.current_page - 1}); return false;">Previous</a></li>`;
        }
        
        for (let i = Math.max(1, pagination.current_page - 2); i <= Math.min(pagination.last_page, pagination.current_page + 2); i++) {
            const activeClass = i === pagination.current_page ? 'active' : '';
            html += `<li class="page-item ${activeClass}"><a class="page-link" href="#" onclick="loadVerifications(${i}); return false;">${i}</a></li>`;
        }
        
        if (pagination.current_page < pagination.last_page) {
            html += `<li class="page-item"><a class="page-link" href="#" onclick="loadVerifications(${pagination.current_page + 1}); return false;">Next</a></li>`;
        }
        
        html += '</ul></nav></div>';
        container.innerHTML = html;
    }

    // Open action modal
    function openActionModal(userId, verificationType) {
        document.getElementById('modal-user-id').value = userId;
        document.getElementById('modal-verification-type').value = verificationType;
        document.getElementById('modal-title').textContent = `Update ${verificationType.toUpperCase()} Verification`;
        
        const modal = new bootstrap.Modal(document.getElementById('actionModal'));
        modal.show();
    }

    // Submit action
    async function submitAction() {
        const userId = document.getElementById('modal-user-id').value;
        const verificationType = document.getElementById('modal-verification-type').value;
        const status = document.getElementById('modal-status').value;
        const rejectionReason = document.getElementById('modal-rejection-reason').value;
        
        if (status === 'rejected' && !rejectionReason.trim()) {
            alert('Please provide a rejection reason.');
            return;
        }
        
        try {
            const response = await fetch(`${API_BASE}/update-status`, {
                method: 'PUT',
                headers: {
                    'Authorization': `Bearer ${AUTH_TOKEN}`,
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    user_id: parseInt(userId),
                    verification_type: verificationType,
                    status: status,
                    rejection_reason: rejectionReason || null
                })
            });
            
            if (response.ok) {
                alert('Verification status updated successfully!');
                bootstrap.Modal.getInstance(document.getElementById('actionModal')).hide();
                loadVerifications(currentPage);
                loadStats();
            } else {
                const error = await response.json();
                alert('Error: ' + (error.message || 'Failed to update status'));
            }
        } catch (error) {
            console.error('Error updating status:', error);
            alert('Error updating verification status');
        }
    }

    // View user details
    function viewDetails(userId) {
        window.open(`/admin/kyc/verification/user/${userId}`, '_blank');
    }

    // Clear all filters
    function clearFilters() {
        document.getElementById('search-input').value = '';
        document.getElementById('status-filter').value = 'pending'; // Reset to default pending
        document.getElementById('type-filter').value = '';
        loadVerifications();
    }

    // Show notification
    function showNotification(message, type = 'info') {
        // Create a simple notification
        const notification = document.createElement('div');
        notification.className = `alert alert-${type === 'error' ? 'danger' : type} alert-dismissible fade show position-fixed`;
        notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        notification.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        document.body.appendChild(notification);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 5000);
    }
</script>
@endpush