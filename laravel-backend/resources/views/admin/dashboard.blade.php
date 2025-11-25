@extends('layouts.admin')

@section('title', 'Dashboard')
@section('page-title', 'Dashboard')
@section('page-description', 'Overview of your system statistics and activities')

@section('content')
<div class="row g-4">
    <!-- Statistics Cards -->
    <div class="col-md-6 col-xl-3">
        <div class="stat-card animate-fade-in">
            <div class="stat-icon primary">
                <i class="bi bi-people"></i>
            </div>
            <div class="stat-value" id="total-users">0</div>
            <div class="stat-label">Total Users</div>
            <div class="stat-change positive">
                <i class="bi bi-arrow-up"></i> <span id="users-change">0%</span> this month
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="stat-card animate-fade-in" style="animation-delay: 0.1s">
            <div class="stat-icon success">
                <i class="bi bi-check-circle"></i>
            </div>
            <div class="stat-value" id="verified-users">0</div>
            <div class="stat-label">Verified Users</div>
            <div class="stat-change positive">
                <i class="bi bi-arrow-up"></i> <span id="verified-change">0%</span> this month
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="stat-card animate-fade-in" style="animation-delay: 0.2s">
            <div class="stat-icon warning">
                <i class="bi bi-newspaper"></i>
            </div>
            <div class="stat-value" id="total-posts">0</div>
            <div class="stat-label">Total Posts</div>
            <div class="stat-change positive">
                <i class="bi bi-arrow-up"></i> <span id="posts-change">0%</span> this month
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="stat-card animate-fade-in" style="animation-delay: 0.3s">
            <div class="stat-icon info">
                <i class="bi bi-chat-square-text"></i>
            </div>
            <div class="stat-value" id="total-forums">0</div>
            <div class="stat-label">Active Forums</div>
            <div class="stat-change positive">
                <i class="bi bi-arrow-up"></i> <span id="forums-change">0%</span> this month
            </div>
        </div>
    </div>

    <!-- Additional Stats -->
    <div class="col-md-4">
        <div class="stat-card animate-fade-in" style="animation-delay: 0.4s">
            <div class="stat-icon" style="background: linear-gradient(135deg, #ec4899 0%, #8b5cf6 100%)">
                <i class="bi bi-building"></i>
            </div>
            <div class="stat-value" id="total-schools">0</div>
            <div class="stat-label">Schools</div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="stat-card animate-fade-in" style="animation-delay: 0.5s">
            <div class="stat-icon" style="background: linear-gradient(135deg, #14b8a6 0%, #06b6d4 100%)">
                <i class="bi bi-box-seam"></i>
            </div>
            <div class="stat-value" id="total-products">0</div>
            <div class="stat-label">Products</div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="stat-card animate-fade-in" style="animation-delay: 0.6s">
            <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b 0%, #ef4444 100%)">
                <i class="bi bi-gear"></i>
            </div>
            <div class="stat-value" id="total-services">0</div>
            <div class="stat-label">Services</div>
        </div>
    </div>

    <!-- User Activity Chart -->
    <div class="col-lg-8">
        <div class="data-table animate-fade-in" style="animation-delay: 0.7s">
            <div class="table-header">
                <h5 class="table-title">User Activity</h5>
                <div class="btn-group btn-group-sm">
                    <button class="btn btn-outline-primary active" data-period="week">Week</button>
                    <button class="btn btn-outline-primary" data-period="month">Month</button>
                    <button class="btn btn-outline-primary" data-period="year">Year</button>
                </div>
            </div>
            <div class="p-4">
                <canvas id="userActivityChart" height="280"></canvas>
            </div>
        </div>
    </div>

    <!-- User Status Chart -->
    <div class="col-lg-4">
        <div class="data-table animate-fade-in" style="animation-delay: 0.8s">
            <div class="table-header">
                <h5 class="table-title">User Status</h5>
            </div>
            <div class="p-4">
                <canvas id="userStatusChart" height="280"></canvas>
            </div>
            <div class="p-4 pt-0">
                <div class="d-flex justify-content-between mb-2">
                    <span class="d-flex align-items-center gap-2">
                        <span class="badge bg-success">●</span> Active
                    </span>
                    <span class="fw-bold" id="status-active">0</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span class="d-flex align-items-center gap-2">
                        <span class="badge bg-warning">●</span> Blocked
                    </span>
                    <span class="fw-bold" id="status-blocked">0</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span class="d-flex align-items-center gap-2">
                        <span class="badge bg-danger">●</span> Deleted
                    </span>
                    <span class="fw-bold" id="status-deleted">0</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Users -->
    <div class="col-lg-6">
        <div class="data-table animate-fade-in" style="animation-delay: 0.9s">
            <div class="table-header">
                <h5 class="table-title">Recent Users</h5>
                <a href="{{ route('admin.users.index') }}" class="btn btn-sm btn-primary">View All</a>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Joined</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody id="recent-users">
                        <tr>
                            <td colspan="4" class="text-center py-4">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Recent Posts -->
    <div class="col-lg-6">
        <div class="data-table animate-fade-in" style="animation-delay: 1s">
            <div class="table-header">
                <h5 class="table-title">Recent Posts</h5>
                <a href="{{ route('admin.posts.index') }}" class="btn btn-sm btn-primary">View All</a>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Created</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody id="recent-posts">
                        <tr>
                            <td colspan="4" class="text-center py-4">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    let userActivityChart, userStatusChart;

    // Load Dashboard Statistics
    async function loadDashboardStats() {
        try {
            const response = await apiRequest('/admin/dashboard');
            if (response.status === 200) {
                const stats = response.data;

                // Update stat cards
                document.getElementById('total-users').textContent = stats.total_users;
                document.getElementById('verified-users').textContent = stats.verified_users;
                document.getElementById('total-posts').textContent = stats.total_posts;
                document.getElementById('total-forums').textContent = stats.total_forums;
                document.getElementById('total-schools').textContent = stats.total_schools;
                document.getElementById('total-products').textContent = stats.total_products || 0;
                document.getElementById('total-services').textContent = stats.total_services || 0;

                // Update user status counts
                document.getElementById('status-active').textContent = stats.total_users - stats.blocked_users - stats.deleted_users;
                document.getElementById('status-blocked').textContent = stats.blocked_users;
                document.getElementById('status-deleted').textContent = stats.deleted_users;

                // Load recent users
                loadRecentUsers(stats.recent_users);
                
                // Load recent posts
                loadRecentPosts(stats.recent_posts);

                // Initialize charts
                initUserStatusChart(stats);
                initUserActivityChart();
            }
        } catch (error) {
            console.error('Error loading dashboard stats:', error);
            showToast('Failed to load dashboard statistics', 'danger');
        }
    }

    // Load Recent Users
    function loadRecentUsers(users) {
        const tbody = document.getElementById('recent-users');
        if (!users || users.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" class="text-center py-4 text-muted">No recent users</td></tr>';
            return;
        }

        tbody.innerHTML = users.map(user => `
            <tr>
                <td>
                    <div class="d-flex align-items-center gap-2">
                        <img src="https://ui-avatars.com/api/?name=${encodeURIComponent(user.name)}&background=6366f1&color=fff" 
                             width="32" height="32" class="rounded-circle" alt="${user.name}">
                        <span class="fw-semibold">${user.name}</span>
                    </div>
                </td>
                <td>${user.email}</td>
                <td>${new Date(user.created_at).toLocaleDateString()}</td>
                <td>
                    <span class="badge bg-success">Active</span>
                </td>
            </tr>
        `).join('');
    }

    // Load Recent Posts
    function loadRecentPosts(posts) {
        const tbody = document.getElementById('recent-posts');
        if (!posts || posts.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" class="text-center py-4 text-muted">No recent posts</td></tr>';
            return;
        }

        tbody.innerHTML = posts.map(post => `
            <tr>
                <td>
                    <span class="fw-semibold">${post.title}</span>
                </td>
                <td>${post.user ? post.user.name : 'Unknown'}</td>
                <td>${new Date(post.created_at).toLocaleDateString()}</td>
                <td>
                    <a href="/admin/posts/${post.id}" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-eye"></i>
                    </a>
                </td>
            </tr>
        `).join('');
    }

    // Initialize User Status Chart
    function initUserStatusChart(stats) {
        const ctx = document.getElementById('userStatusChart').getContext('2d');
        
        const activeUsers = stats.total_users - stats.blocked_users - stats.deleted_users;
        
        if (userStatusChart) {
            userStatusChart.destroy();
        }

        userStatusChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Active', 'Blocked', 'Deleted'],
                datasets: [{
                    data: [activeUsers, stats.blocked_users, stats.deleted_users],
                    backgroundColor: [
                        '#10b981',
                        '#f59e0b',
                        '#ef4444'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                cutout: '70%'
            }
        });
    }

    // Initialize User Activity Chart
    function initUserActivityChart() {
        const ctx = document.getElementById('userActivityChart').getContext('2d');
        
        // Sample data - in production, this would come from API
        const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        const data = [65, 59, 80, 81, 56, 55, 70];

        if (userActivityChart) {
            userActivityChart.destroy();
        }

        const gradient = ctx.createLinearGradient(0, 0, 0, 300);
        gradient.addColorStop(0, 'rgba(99, 102, 241, 0.3)');
        gradient.addColorStop(1, 'rgba(99, 102, 241, 0)');

        userActivityChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Active Users',
                    data: data,
                    borderColor: '#6366f1',
                    backgroundColor: gradient,
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#6366f1',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 5,
                    pointHoverRadius: 7
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: '#1e293b',
                        padding: 12,
                        borderRadius: 8,
                        titleFont: {
                            size: 14,
                            weight: '600'
                        },
                        bodyFont: {
                            size: 13
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#f1f5f9'
                        },
                        ticks: {
                            color: '#64748b'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#64748b'
                        }
                    }
                }
            }
        });
    }

    // Load dashboard on page load
    document.addEventListener('DOMContentLoaded', function() {
        loadDashboardStats();
    });
</script>
@endpush


