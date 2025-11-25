<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'Admin Panel') - SolveIt</title>
    
    <!-- Bootstrap 5.3.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    
    <!-- Custom CSS -->
    <style>
        :root {
            --primary-color: #83074e; /* updated brand color */
            --primary-dark: #5e0538;  /* darker shade for gradients */
            --secondary-color: #a60a60; /* complementary shade */
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --info-color: #3b82f6;
            --dark-color: #1e293b;
            --sidebar-width: 280px;
            --topbar-height: 70px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f8fafc;
            color: #1e293b;
            overflow-x: hidden;
        }

        /* Sidebar Styles */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: var(--sidebar-width);
            background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);
            color: #fff;
            padding: 0;
            z-index: 1000;
            box-shadow: 4px 0 24px rgba(0, 0, 0, 0.12);
            overflow-y: auto;
            transition: all 0.3s ease;
        }

        .sidebar::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
        }

        .sidebar-logo {
            padding: 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sidebar-logo i {
            font-size: 32px;
            color: var(--primary-color);
        }

        .sidebar-logo h4 {
            margin: 0;
            font-weight: 700;
            font-size: 24px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .sidebar-menu {
            padding: 20px 12px;
            list-style: none;
        }

        .menu-label {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: rgba(255, 255, 255, 0.5);
            padding: 12px 16px 8px;
            margin-top: 12px;
        }

        .menu-item {
            margin-bottom: 4px;
        }

        .menu-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            border-radius: 12px;
            transition: all 0.3s ease;
            font-size: 14px;
            font-weight: 500;
            position: relative;
            overflow: hidden;
        }

        .menu-link::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: var(--primary-color);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }

        .menu-link:hover,
        .menu-link.active {
            background: rgba(99, 102, 241, 0.1);
            color: #fff;
            transform: translateX(4px);
        }

        .menu-link.active::before {
            transform: scaleY(1);
        }

        .menu-link i {
            font-size: 18px;
            width: 24px;
            text-align: center;
        }

        .badge-count {
            margin-left: auto;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }

        /* Main Content */
        .main-content {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
            transition: all 0.3s ease;
        }

        /* Topbar */
        .topbar {
            height: var(--topbar-height);
            background: #fff;
            border-bottom: 1px solid #e2e8f0;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .topbar-left h1 {
            font-size: 24px;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
        }

        .topbar-left p {
            font-size: 14px;
            color: #64748b;
            margin: 0;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .topbar-btn {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            border: none;
            background: #f8fafc;
            color: #64748b;
            font-size: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .topbar-btn:hover {
            background: #e2e8f0;
            color: #1e293b;
            transform: translateY(-2px);
        }

        .topbar-btn .badge {
            position: absolute;
            top: -4px;
            right: -4px;
            padding: 2px 6px;
            font-size: 10px;
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 12px;
            border-radius: 12px;
            background: #f8fafc;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .user-menu:hover {
            background: #e2e8f0;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            object-fit: cover;
            border: 2px solid #fff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .user-info {
            text-align: right;
        }

        .user-name {
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
            display: block;
        }

        .user-role {
            font-size: 12px;
            color: #64748b;
        }

        /* Content Area */
        .content-area {
            padding: 32px;
        }

        /* Cards */
        .stat-card {
            background: #fff;
            border-radius: 16px;
            padding: 24px;
            border: none;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 16px;
        }

        .stat-icon.primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: #fff;
        }

        .stat-icon.success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #fff;
        }

        .stat-icon.warning {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: #fff;
        }

        .stat-icon.danger {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: #fff;
        }

        .stat-icon.info {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: #fff;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 4px;
        }

        .stat-label {
            font-size: 14px;
            color: #64748b;
            font-weight: 500;
        }

        .stat-change {
            font-size: 13px;
            font-weight: 600;
            margin-top: 8px;
        }

        .stat-change.positive {
            color: var(--success-color);
        }

        .stat-change.negative {
            color: var(--danger-color);
        }

        /* Tables */
        .data-table {
            background: #fff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
        }

        .table-header {
            padding: 24px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .table-title {
            font-size: 18px;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
        }

        .table {
            margin: 0;
        }

        .table thead th {
            background: #f8fafc;
            color: #64748b;
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 16px 24px;
            border: none;
        }

        .table tbody td {
            padding: 16px 24px;
            vertical-align: middle;
            border-color: #f1f5f9;
            font-size: 14px;
        }

        .table tbody tr {
            transition: all 0.2s ease;
        }

        .table tbody tr:hover {
            background: #f8fafc;
        }

        /* Buttons */
        .btn {
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            box-shadow: 0 4px 12px rgba(131, 7, 78, 0.3);
        }

        .btn-primary:hover {
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
            transform: translateY(-2px);
        }

        .btn-sm {
            padding: 6px 14px;
            font-size: 13px;
            border-radius: 8px;
        }

        /* Badges */
        .badge {
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 12px;
        }

        /* Forms */
        .form-control, .form-select {
            border-radius: 10px;
            border: 1px solid #e2e8f0;
            padding: 12px 16px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
        }

        .form-label {
            font-weight: 600;
            font-size: 14px;
            color: #475569;
            margin-bottom: 8px;
        }

        /* Search Bar */
        .search-bar {
            position: relative;
            max-width: 400px;
        }

        .search-bar input {
            padding-left: 44px;
            border-radius: 12px;
        }

        .search-bar i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
            }

            .content-area {
                padding: 20px;
            }

            .topbar {
                padding: 0 16px;
            }
        }

        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-fade-in {
            animation: fadeIn 0.5s ease forwards;
        }

        /* Loading Spinner */
        .spinner-border-sm {
            width: 16px;
            height: 16px;
        }
    </style>
    
    @stack('styles')
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-logo">
             
            <h4>SolveIt Admin</h4>
        </div>
        
        <ul class="sidebar-menu">
            <li class="menu-label">Main</li>
            <li class="menu-item">
                <a href="{{ route('admin.dashboard') }}" class="menu-link {{ request()->routeIs('admin.dashboard') ? 'active' : '' }}">
                    <i class="bi bi-speedometer2"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            
            <li class="menu-label">Management</li>
            <li class="menu-item">
                <a href="{{ route('admin.users.index') }}" class="menu-link {{ request()->routeIs('admin.users.*') ? 'active' : '' }}">
                    <i class="bi bi-people"></i>
                    <span>Users</span>
                    <span class="badge bg-primary badge-count" id="users-count">...</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.forums.index') }}" class="menu-link {{ request()->routeIs('admin.forums.*') ? 'active' : '' }}">
                    <i class="bi bi-chat-square-text"></i>
                    <span>Forums</span>
                    <span class="badge bg-info badge-count" id="forums-count">...</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.posts.index') }}" class="menu-link {{ request()->routeIs('admin.posts.*') ? 'active' : '' }}">
                    <i class="bi bi-newspaper"></i>
                    <span>Posts</span>
                    <span class="badge bg-success badge-count" id="posts-count">...</span>
                </a>
            </li>
            
            <li class="menu-label">School Elements</li>
            <li class="menu-item">
                <a href="{{ route('admin.schools.index') }}" class="menu-link {{ request()->routeIs('admin.schools.*') ? 'active' : '' }}">
                    <i class="bi bi-building"></i>
                    <span>Schools</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.faculties.index') }}" class="menu-link {{ request()->routeIs('admin.faculties.*') ? 'active' : '' }}">
                    <i class="bi bi-mortarboard"></i>
                    <span>Faculties</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.departments.index') }}" class="menu-link {{ request()->routeIs('admin.departments.*') ? 'active' : '' }}">
                    <i class="bi bi-diagram-3"></i>
                    <span>Departments</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.levels.index') }}" class="menu-link {{ request()->routeIs('admin.levels.*') ? 'active' : '' }}">
                    <i class="bi bi-bar-chart-steps"></i>
                    <span>Levels</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.categories.index') }}" class="menu-link {{ request()->routeIs('admin.categories.*') ? 'active' : '' }}">
                    <i class="bi bi-tags"></i>
                    <span>Categories</span>
                </a>
            </li>
            
            <li class="menu-label">Verification</li>
            <li class="menu-item">
                <a href="{{ route('admin.kyc.verifications') }}" class="menu-link {{ request()->routeIs('admin.kyc.*') ? 'active' : '' }}">
                    <i class="bi bi-shield-check"></i>
                    <span>KYC Verification</span>
                    <span class="badge bg-warning badge-count" id="kyc-count">...</span>
                </a>
            </li>
            
            <li class="menu-label">Communication</li>
            <li class="menu-item">
                <a href="{{ route('admin.notifications.index') }}" class="menu-link {{ request()->routeIs('admin.notifications.*') ? 'active' : '' }}">
                    <i class="bi bi-bell"></i>
                    <span>Notifications</span>
                </a>
            </li>
            
            <li class="menu-label">System</li>
            <li class="menu-item">
                <a href="{{ route('admin.roles.index') }}" class="menu-link {{ request()->routeIs('admin.roles.*') ? 'active' : '' }}">
                    <i class="bi bi-shield-check"></i>
                    <span>Roles</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.roles.index') }}#assign" class="menu-link {{ request()->routeIs('admin.roles.*') ? 'active' : '' }}">
                    <i class="bi bi-person-gear"></i>
                    <span>Assign Roles</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.permissions.index') }}" class="menu-link {{ request()->routeIs('admin.permissions.*') ? 'active' : '' }}">
                    <i class="bi bi-key"></i>
                    <span>Permissions</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Topbar -->
        <nav class="topbar">
            <div class="topbar-left">
                <h1>@yield('page-title', 'Dashboard')</h1>
                <p>@yield('page-description', 'Welcome to SolveIt Admin Panel')</p>
            </div>
            <div class="topbar-right">
                <div class="search-bar d-none d-md-block">
                    <i class="bi bi-search"></i>
                    <input type="text" class="form-control" id="global-search" placeholder="Search users, forums, schools...">
                </div>
                <button class="btn btn-primary btn-sm d-none d-md-inline-flex" id="global-search-btn" title="Search" style="height: 40px;">
                    <i class="bi bi-search"></i>
                </button>
                
                <button class="topbar-btn d-md-none" id="toggle-sidebar">
                    <i class="bi bi-list"></i>
                </button>
                <div class="dropdown">
                    <div class="user-menu" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="https://ui-avatars.com/api/?name=Admin&background=6366f1&color=fff" alt="Admin" class="user-avatar">
                        <div class="user-info">
                            <span class="user-name">Admin User</span>
                            <span class="user-role">Super Admin</span>
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#" onclick="logout(); return false;"><i class="bi bi-box-arrow-right me-2"></i> Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Content -->
        <div class="content-area">
            @yield('content')
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // API Base URL (dynamic to support subdirectory deployments)
        const API_URL = '{{ url('/api/v1') }}';
        
        // CSRF Token
        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
        
        // Check authentication
        const adminToken = localStorage.getItem('admin_token');
        const adminUser = localStorage.getItem('admin_user');
        
        // Redirect to login if not authenticated
        if (!adminToken && window.location.pathname !== '/admin/login' && !window.location.pathname.includes('/admin/login')) {
            window.location.href = '/admin/login';
        }

        // Sidebar Toggle (Mobile)
        document.getElementById('toggle-sidebar')?.addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('active');
        });

        // Global API Helper
        async function apiRequest(endpoint, options = {}) {
            const token = localStorage.getItem('admin_token');
            
            const defaultOptions = {
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'X-CSRF-TOKEN': csrfToken,
                    'Authorization': token ? `Bearer ${token}` : '',
                    ...(options.headers || {})
                }
            };

            const response = await fetch(API_URL + endpoint, {
                ...defaultOptions,
                ...options
            });

            const data = await response.json();
            
            if (!response.ok) {
                // If unauthorized, redirect to login
                if (response.status === 401) {
                    localStorage.removeItem('admin_token');
                    localStorage.removeItem('admin_user');
                    window.location.href = '/admin/login';
                }
                throw new Error(data.message || 'An error occurred');
            }

            return data;
        }
        
        // Logout function
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                localStorage.removeItem('admin_token');
                localStorage.removeItem('admin_user');
                window.location.href = '/admin/login';
            }
        }
        
        // Update user info in topbar
        if (adminUser) {
            try {
                const user = JSON.parse(adminUser);
                const userNameEl = document.querySelector('.user-name');
                const userRoleEl = document.querySelector('.user-role');
                const userAvatarEl = document.querySelector('.user-avatar');
                
                if (userNameEl) userNameEl.textContent = user.name;
                if (userRoleEl) userRoleEl.textContent = user.role ? user.role.display_name : 'Admin';
                if (userAvatarEl) userAvatarEl.src = user.avatar_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(user.name)}&background=83074e&color=fff`;
            } catch (e) {
                console.error('Error parsing user data:', e);
            }
        }

        // Load sidebar counts
        async function loadSidebarCounts() {
            try {
                const stats = await apiRequest('/admin/dashboard');
                if (stats.status === 200) {
                    document.getElementById('users-count').textContent = stats.data.total_users;
                    document.getElementById('forums-count').textContent = stats.data.total_forums;
                    document.getElementById('posts-count').textContent = stats.data.total_posts;
                    document.getElementById('kyc-count').textContent = stats.data.pending_kyc || 0;
                }
            } catch (error) {
                console.error('Error loading counts:', error);
            }
        }

        // Idle timeout: warn at 55m, logout at 60m of inactivity
        (function setupIdleTimeout(){
            const IDLE_LIMIT_MS = (60 * 60 * 1000); // 60 minutes
            const WARN_BEFORE_MS = (5 * 60 * 1000); // warn 5 minutes before
            let lastActivity = Date.now();
            let warned = false;

            function resetActivity(){
                lastActivity = Date.now();
                warned = false;
            }
            ['click','keydown','mousemove','scroll','touchstart'].forEach(ev => {
                window.addEventListener(ev, resetActivity, { passive: true });
            });

            setInterval(() => {
                const inactive = Date.now() - lastActivity;
                if (!warned && inactive > (IDLE_LIMIT_MS - WARN_BEFORE_MS)) {
                    try { showToast('You will be logged out soon due to inactivity', 'warning'); } catch(e) {}
                    warned = true;
                }
                if (inactive > IDLE_LIMIT_MS) {
                    logout();
                }
            }, 30000);
        })();

        // Global Search
        (function setupGlobalSearch(){
            const input = document.getElementById('global-search');
            const btn = document.getElementById('global-search-btn');
            if (!input) return;
            let t;
            async function doGlobalSearch(q){
                try {
                    const res = await apiRequest(`/general/search?query=${encodeURIComponent(q)}&type=all`);
                    if (res.status === 200) {
                        const r = res.data || {};
                        const first = (r.users?.[0]) || (r.forums?.[0]) || (r.schools?.[0]) || (r.faculties?.[0]) || (r.departments?.[0]) || (r.posts?.[0]) || null;
                        if (first) {
                            if (r.users?.[0]?.id) window.location.href = `/admin/users/${r.users[0].id}`;
                            else if (r.forums?.[0]?.id) window.location.href = `/admin/forums/${r.forums[0].id}`;
                            else if (r.schools?.[0]?.id) window.location.href = `/admin/schools`;
                            else if (r.faculties?.[0]?.id) window.location.href = `/admin/faculties`;
                            else if (r.departments?.[0]?.id) window.location.href = `/admin/departments`;
                            else if (r.posts?.[0]?.id) window.location.href = `/admin/posts/${r.posts[0].id}`;
                        } else {
                            showToast('No results found', 'warning');
                        }
                    }
                } catch (err) {
                    console.error('Global search error', err);
                }
            }

            input.addEventListener('input', function(e){
                clearTimeout(t);
                const q = e.target.value.trim();
                if (q.length < 2) return;
                t = setTimeout(() => doGlobalSearch(q), 500);
            });

            function handleEnter(e){
                const key = e.key || e.keyCode;
                if (key === 'Enter' || key === 13) {
                    e.preventDefault();
                    const q = input.value.trim();
                    if (q.length < 2) { showToast('Type at least 2 characters', 'warning'); return; }
                    clearTimeout(t);
                    doGlobalSearch(q);
                }
            }
            input.addEventListener('keydown', handleEnter);
            input.addEventListener('keypress', handleEnter);
            input.addEventListener('keyup', handleEnter);

            if (btn) {
                btn.addEventListener('click', function(){
                    const q = input.value.trim();
                    if (q.length < 2) { showToast('Type at least 2 characters', 'warning'); return; }
                    doGlobalSearch(q);
                });
            }
        })();

        // Load counts on page load
        document.addEventListener('DOMContentLoaded', loadSidebarCounts);

        // Toast notification helper
        function showToast(message, type = 'success') {
            const toast = document.createElement('div');
            toast.className = `alert alert-${type} position-fixed top-0 end-0 m-3 animate-fade-in`;
            toast.style.zIndex = '9999';
            toast.innerHTML = `
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-${type === 'success' ? 'check-circle' : 'x-circle'}"></i>
                    <span>${message}</span>
                </div>
            `;
            document.body.appendChild(toast);
            setTimeout(() => toast.remove(), 3000);
        }
    </script>

    @stack('scripts')
</body>
</html>

