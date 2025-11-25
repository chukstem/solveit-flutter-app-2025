<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Redirecting...</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }
        .loader {
            text-align: center;
            color: white;
        }
        .spinner {
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top: 4px solid white;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        h3 {
            margin: 0;
            font-weight: 500;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="loader">
        <div class="spinner"></div>
        <h3>Redirecting...</h3>
    </div>

    <script>
        // Check if user is authenticated by looking for token in localStorage
        const adminToken = localStorage.getItem('admin_token');
        
        if (adminToken) {
            // User has token, redirect to dashboard
            window.location.href = '/admin/dashboard';
        } else {
            // No token, redirect to login
            window.location.href = '/admin/login';
        }
    </script>
</body>
</html>


