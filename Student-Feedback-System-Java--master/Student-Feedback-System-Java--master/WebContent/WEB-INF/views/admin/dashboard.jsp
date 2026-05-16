<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="<%= request.getContextPath() %>/css/style.css?v=1777051475511" rel="stylesheet">
</head>
<body data-theme="light">

    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-brand"><i class="bi bi-mortarboard-fill"></i> Feedback System</div>
        <div class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link active"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin/forms" class="sidebar-link"><i class="bi bi-ui-radios"></i> Manage Forms</a>
            <a href="<%= request.getContextPath() %>/admin/analytics" class="sidebar-link"><i class="bi bi-bar-chart-line-fill"></i> Analytics</a>
        </div>
        <div class="sidebar-footer">
            <span class="user-name"><i class="bi bi-person-circle"></i> ${user.fullName}</span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout"><i class="bi bi-box-arrow-left me-1"></i>Sign Out</a>
        </div>
    </nav>

    <div class="sidebar-backdrop" id="sidebarBackdrop" onclick="closeSidebar()"></div>

    <!-- Main Content -->
    <main class="main-content">
        <div class="topbar">
            <button class="hamburger-btn" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
            <button class="btn-theme" onclick="toggleTheme()"><i class="bi bi-moon-fill me-1"></i> Theme</button>
        </div>

        <h1 class="page-title">System Overview</h1>
        <p class="page-subtitle">Real-time snapshot of your feedback platform</p>

        <div class="row g-4 mb-4">
            <div class="col-md-3 col-6">
                <div class="stat-card stat-primary">
                    <span class="stat-label">Total Forms</span>
                    <div class="stat-value">${totalForms}</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card stat-success">
                    <span class="stat-label">Active Forms</span>
                    <div class="stat-value">${activeForms}</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card stat-info">
                    <span class="stat-label">Total Submissions</span>
                    <div class="stat-value">${totalResponses}</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card stat-warning">
                    <span class="stat-label">Registered Students</span>
                    <div class="stat-value">${totalStudents}</div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="card animate-in" style="animation-delay:.25s">
                    <div class="card-body text-center py-5">
                        <i class="bi bi-ui-radios fs-1 text-primary mb-3 d-block" style="opacity:.6"></i>
                        <h5>Manage Forms</h5>
                        <p class="text-muted small mb-3">Create, edit, and toggle feedback forms</p>
                        <a href="<%= request.getContextPath() %>/admin/forms" class="btn btn-primary btn-sm px-4">Open Forms</a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card animate-in" style="animation-delay:.35s">
                    <div class="card-body text-center py-5">
                        <i class="bi bi-bar-chart-line-fill fs-1 text-info mb-3 d-block" style="opacity:.6"></i>
                        <h5>View Analytics</h5>
                        <p class="text-muted small mb-3">Charts, ratings, and student responses</p>
                        <a href="<%= request.getContextPath() %>/admin/analytics" class="btn btn-outline-primary btn-sm px-4">Open Analytics</a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('active');
            document.getElementById('sidebarBackdrop').classList.toggle('active');
        }
        function closeSidebar() {
            document.getElementById('sidebar').classList.remove('active');
            document.getElementById('sidebarBackdrop').classList.remove('active');
        }
        function toggleTheme() {
            const next = document.body.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
            document.body.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
        }
        document.addEventListener('DOMContentLoaded', () => {
            const t = localStorage.getItem('theme');
            if (t) document.body.setAttribute('data-theme', t);
        });
    </script>
</body>
</html>
