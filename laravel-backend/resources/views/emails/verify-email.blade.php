<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Your Email - SolveIt</title>
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">SolveIt</div>
            <h1 style="color: #333; margin: 0;">Verify Your Email Address</h1>
        </div>

        <div class="content">
            <p>Hello {{ $user->name }},</p>
            
            <p>Thank you for registering with SolveIt! To complete your registration, please verify your email address using the code below:</p>

            <div class="verification-code">
                <div style="color: #666; font-size: 14px; margin-bottom: 10px;">Your Verification Code</div>
                <div class="code">{{ $user->verification_code }}</div>
            </div>

            <p>Enter this code in the app to verify your email address and activate your account.</p>

            <div class="warning">
                <strong>Note:</strong> This verification code will expire in 30 minutes. If you didn't create an account with SolveIt, please ignore this email.
            </div>
        </div>

        <div class="footer">
            <p>© {{ date('Y') }} SolveIt. All rights reserved.</p>
            <p>This is an automated email. Please do not reply to this message.</p>
        </div>
    </div>
</body>
</html>





