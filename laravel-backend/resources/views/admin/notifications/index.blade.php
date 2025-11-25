@extends('layouts.admin')

@section('title', 'Notifications History')
@section('page-title', 'Notifications History')
@section('page-description', 'View all sent notifications')

@section('content')
<div class="row g-4">
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Sent Notifications</h5>
                <a href="{{ route('admin.notifications.send') }}" class="btn btn-primary">
                    <i class="bi bi-send"></i> Send New
                </a>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Type</th>
                            <th>Title</th>
                            <th>Message</th>
                            <th>Sent By</th>
                            <th>Recipients</th>
                            <th>Delivered</th>
                            <th>Failed</th>
                            <th>Sent At</th>
                        </tr>
                    </thead>
                    <tbody id="notifications-table-body">
                        <tr><td colspan="8" class="text-center py-5"><div class="spinner-border text-primary"></div></td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    async function loadNotifications() {
        try {
            const response = await apiRequest('/admin/notifications');
            if (response.status === 200) {
                const tbody = document.getElementById('notifications-table-body');
                if (!response.data.data || response.data.data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-muted">No notifications sent yet</td></tr>';
                    return;
                }
                
                tbody.innerHTML = response.data.data.map(notif => `
                    <tr>
                        <td>
                            <span class="badge bg-${notif.type === 'email' ? 'primary' : 'success'}">
                                <i class="bi bi-${notif.type === 'email' ? 'envelope' : 'phone'}"></i> ${notif.type.toUpperCase()}
                            </span>
                        </td>
                        <td><strong>${notif.title}</strong></td>
                        <td>${(notif.message || '').substring(0, 50)}...</td>
                        <td>${notif.user ? notif.user.name : 'Admin'}</td>
                        <td>
                            <span class="badge bg-info">
                                ${(notif.recipients_count ?? 'All')} users
                            </span>
                        </td>
                        <td>${notif.delivered_count ?? 0}</td>
                        <td>${notif.failed_count ?? 0}</td>
                        <td>${new Date(notif.created_at).toLocaleString()}</td>
                    </tr>
                `).join('');
            }
        } catch (error) {
            console.error('Error loading notifications:', error);
        }
    }

    document.addEventListener('DOMContentLoaded', loadNotifications);
</script>
@endpush


