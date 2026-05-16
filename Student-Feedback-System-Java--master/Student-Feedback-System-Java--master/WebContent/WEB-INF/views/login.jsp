<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — Student Feedback System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="<%= request.getContextPath() %>/css/style.css?v=1777051475519" rel="stylesheet">
    <style>
        html, body { height: 100%; margin: 0; }
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg);
        }
        .auth-wrap {
            display: flex;
            width: 100%;
            max-width: 900px;
            min-height: 540px;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 24px 80px rgba(0,0,0,0.14);
            margin: 24px;
        }
        .auth-left {
            flex: 1;
            background: linear-gradient(145deg, #007aff, #5856d6);
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 52px 48px;
            color: #fff;
        }
        .auth-left .brand { font-size: 1rem; font-weight: 700; opacity: 0.8; margin-bottom: 48px; letter-spacing: -0.01em; }
        .auth-left .brand i { margin-right: 8px; }
        .auth-left h2 { font-size: 2rem; font-weight: 800; letter-spacing: -0.03em; margin-bottom: 12px; line-height: 1.2; }
        .auth-left p { font-size: 0.95rem; opacity: 0.75; line-height: 1.6; }
        .auth-left .features { margin-top: 36px; display: flex; flex-direction: column; gap: 14px; }
        .auth-left .feature { display: flex; align-items: center; gap: 12px; font-size: 0.88rem; opacity: 0.85; }
        .auth-left .feature i { width: 32px; height: 32px; background: rgba(255,255,255,0.2); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 1rem; flex-shrink: 0; }
        .auth-right {
            width: 400px;
            background: var(--surface);
            padding: 52px 44px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .auth-right h3 { font-size: 1.6rem; font-weight: 800; letter-spacing: -0.02em; color: var(--text); margin-bottom: 6px; }
        .auth-right .subtitle { font-size: 0.88rem; color: var(--text-secondary); margin-bottom: 32px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { font-size: 0.82rem; font-weight: 600; color: var(--text-secondary); display: block; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.04em; }
        .form-group .form-control { padding: 12px 14px; font-size: 0.95rem; }
        .btn-signin { width: 100%; padding: 13px; font-size: 0.95rem; font-weight: 700; border-radius: 10px; margin-top: 8px; }
        .auth-footer { text-align: center; margin-top: 24px; font-size: 0.85rem; color: var(--text-secondary); }
        .auth-footer a { color: var(--accent); font-weight: 600; }
        @media (max-width: 640px) { .auth-left { display: none; } .auth-right { width: 100%; } }
    </style>
</head>
<body data-theme="light">
    <div class="auth-wrap animate-scale">
        <div class="auth-left">
            <div class="brand"><i class="bi bi-mortarboard-fill"></i>Feedback System</div>
            <h2>Student Feedback Platform</h2>
            <p>Collect meaningful insights, track student responses, and visualize data with beautiful analytics.</p>
            <div class="features">
                <div class="feature"><i class="bi bi-ui-radios"></i>Dynamic Form Builder</div>
                <div class="feature"><i class="bi bi-bar-chart-line-fill"></i>Real-time Analytics</div>
                <div class="feature"><i class="bi bi-shield-check"></i>Secure & Private</div>
            </div>
        </div>
        <div class="auth-right">
            <h3>Welcome back</h3>
            <p class="subtitle">Sign in to your account to continue</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger d-flex align-items-center gap-2 py-2" style="font-size:.88rem">
                    <i class="bi bi-exclamation-circle-fill"></i><%= request.getAttribute("error") %>
                </div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success d-flex align-items-center gap-2 py-2" style="font-size:.88rem">
                    <i class="bi bi-check-circle-fill"></i><%= request.getAttribute("success") %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="POST">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" class="form-control" id="username" name="username" required placeholder="Enter your username" autofocus>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required placeholder="Enter your password">
                </div>
                <button type="submit" class="btn btn-primary btn-signin">Sign In</button>
            </form>

            <div class="auth-footer">
                New student? <a href="<%= request.getContextPath() %>/register">Create account</a>
            </div>
        </div>
    </div>

    <script>
        const t = localStorage.getItem('theme');
        if (t) document.body.setAttribute('data-theme', t);
    </script>
</body>
</html>
