@extends('layouts.admin')

@section('title', 'Send Notifications')
@section('page-title', 'Send Notifications')
@section('page-description', 'Send email and push notifications to users')

@section('content')
<div class="row g-4">
    <!-- Email Notification -->
    <div class="col-lg-6">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title"><i class="bi bi-envelope"></i> Email Notification</h5>
            </div>
            <div class="p-4">
                <form id="email-form">
                    <div class="mb-3">
                        <label class="form-label">Subject</label>
                        <input type="text" class="form-control" name="subject" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Message</label>
                        <textarea class="form-control" name="message" rows="6" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Filter Recipients (Optional)</label>
                        <select class="form-select" name="school_id">
                            <option value="">All Schools</option>
                        </select>
                    </div>
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle"></i> Emails will be queued and sent at 500 per hour
                    </div>
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-send"></i> Send Email Notification
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Push Notification -->
    <div class="col-lg-6">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title"><i class="bi bi-phone"></i> Push Notification</h5>
            </div>
            <div class="p-4">
                <form id="push-form">
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" class="form-control" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Message</label>
                        <textarea class="form-control" name="message" rows="6" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Topic</label>
                        <input type="text" class="form-control" name="topic" placeholder="e.g. general" value="general" required>
                    </div>
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle"></i> Push notification will be sent to the specified FCM topic
                    </div>
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-send"></i> Send Push Notification
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    document.getElementById('email-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = {
            subject: formData.get('subject'),
            message: formData.get('message'),
            user_filter: formData.get('school_id') ? { school_id: formData.get('school_id') } : null
        };

        try {
            const response = await apiRequest('/admin/notifications/send-email', {
                method: 'POST',
                body: JSON.stringify(data)
            });
            showToast(`Email notification queued! Will be sent to ${response.data.recipients_count} users`, 'success');
            e.target.reset();
        } catch (error) {
            showToast('Failed to send email notification', 'danger');
        }
    });

    document.getElementById('push-form').addEventListener('submit', async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);
        const data = {
            title: formData.get('title'),
            message: formData.get('message'),
            topic: formData.get('topic') || 'general'
        };

        try {
            await apiRequest('/admin/push/send', {
                method: 'POST',
                body: JSON.stringify(data)
            });
            showToast('Push notification sent successfully!', 'success');
            e.target.reset();
        } catch (error) {
            showToast('Failed to send push notification', 'danger');
        }
    });
</script>
@endpush


