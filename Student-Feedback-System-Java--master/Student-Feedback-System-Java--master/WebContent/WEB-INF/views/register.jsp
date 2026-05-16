<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — Student Feedback System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="<%= request.getContextPath() %>/css/style.css?v=1777051475521" rel="stylesheet">
    <style>
        html, body { height: 100%; margin: 0; }
        body { min-height: 100vh; display: flex; align-items: center; justify-content: center; background: var(--bg); padding: 32px 16px; }
        .register-wrap {
            width: 100%;
            max-width: 520px;
            background: var(--surface);
            border-radius: 20px;
            padding: 48px 44px;
            box-shadow: 0 24px 80px rgba(0,0,0,0.12);
            animation: scaleIn 0.4s var(--ease) both;
        }
        .register-wrap .brand { font-size: 0.85rem; font-weight: 700; color: var(--accent); margin-bottom: 24px; display: block; text-decoration: none; }
        .register-wrap .brand i { margin-right: 6px; }
        .register-wrap h3 { font-size: 1.6rem; font-weight: 800; letter-spacing: -0.02em; color: var(--text); margin-bottom: 4px; }
        .register-wrap .subtitle { font-size: 0.88rem; color: var(--text-secondary); margin-bottom: 28px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { font-size: 0.8rem; font-weight: 600; color: var(--text-secondary); display: block; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 0.04em; }
        .form-group .form-control { padding: 11px 14px; font-size: 0.9rem; }
        .btn-register { width: 100%; padding: 13px; font-size: 0.95rem; font-weight: 700; border-radius: 10px; margin-top: 6px; }
        .auth-footer { text-align: center; margin-top: 20px; font-size: 0.85rem; color: var(--text-secondary); }
        .auth-footer a { color: var(--accent); font-weight: 600; }
        @media (max-width: 480px) { .form-row { grid-template-columns: 1fr; } .register-wrap { padding: 32px 24px; } }
    </style>
</head>
<body data-theme="light">
    <div class="register-wrap">
        <a href="<%= request.getContextPath() %>/login" class="brand"><i class="bi bi-mortarboard-fill"></i>Feedback System</a>
        <h3>Create your account</h3>
        <p class="subtitle">Join the platform and start sharing feedback</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger d-flex align-items-center gap-2 py-2" style="font-size:.88rem">
                <i class="bi bi-exclamation-circle-fill"></i><%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/register" method="POST">
            <div class="form-group">
                <label for="usn">University Seat Number (USN)</label>
                <input type="text" class="form-control" id="usn" name="usn" required placeholder="e.g., 1AB22CS001" autofocus>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" required placeholder="John Doe">
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" id="email" name="email" required placeholder="you@example.com">
                </div>
            </div>

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" class="form-control" id="username" name="username" required placeholder="Choose a username">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required placeholder="Min 4 characters">
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required placeholder="Repeat password">
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-register">Create Account</button>
        </form>

        <div class="auth-footer">
            Already have an account? <a href="<%= request.getContextPath() %>/login">Sign in</a>
        </div>
    </div>

    <script>
        const t = localStorage.getItem('theme');
        if (t) document.body.setAttribute('data-theme', t);
    </script>
</body>
</html>
