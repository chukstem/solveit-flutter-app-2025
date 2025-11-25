<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Your Password - SolveIt</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 40px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo {
            font-size: 32px;
            font-weight: bold;
            color: #83074E;
            margin-bottom: 10px;
        }
        .content {
            margin-bottom: 30px;
        }
        .verification-code {
            background-color: #f8f9fa;
            border: 2px dashed #83074E;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            margin: 30px 0;
        }
        .code {
            font-size: 36px;
            font-weight: bold;
            color: #83074E;
            letter-spacing: 8px;
            font-family: 'Courier New', monospace;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            color: #666;
            font-size: 14px;
        }
        .button {
            display: inline-block;
            padding: 12px 30px;
            background-color: #83074E;
            color: #ffffff;
            text-decoration: none;
            border-radius: 5px;
            margin: 20px 0;
        }
        .warning {
            color: #666;
            font-size: 14px;
            margin-top: 20px;
        }
        .alert {
            background-color: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 5px;
            padding: 15px;
            margin: 20px 0;
            color: #856404;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">SolveIt</div>
            <h1 style="color: #333; margin: 0;">Reset Your Password</h1>
        </div>

        <div class="content">
            <p>Hello {{ $user->name }},</p>
            
            <p>We received a request to reset your password for your SolveIt account. Use the code below to reset your password:</p>

            <div class="verification-code">
                <div style="color: #666; font-size: 14px; margin-bottom: 10px;">Your Reset Code</div>
                <div class="code">{{ $code }}</div>
            </div>

            <p>Enter this code in the app to reset your password.</p>

            <div class="alert">
                <strong>Security Notice:</strong> If you didn't request a password reset, please ignore this email and ensure your account is secure.
            </div>

            <div class="warning">
                <strong>Note:</strong> This reset code will expire in 30 minutes.
            </div>
        </div>

        <div class="footer">
            <p>© {{ date('Y') }} SolveIt. All rights reserved.</p>
            <p>This is an automated email. Please do not reply to this message.</p>
        </div>
    </div>
</body>
</html>





