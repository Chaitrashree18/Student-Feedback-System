<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — Student Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="<%= request.getContextPath() %>/css/style.css?v=1777051475524" rel="stylesheet">
    <style>
        .student-nav {
            background: var(--sidebar-bg);
            padding: 14px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .student-nav .nav-brand {
            font-size: 1rem;
            font-weight: 700;
            color: #fff;
            text-decoration: none;
            letter-spacing: -0.01em;
        }
        .student-nav .nav-brand i { color: var(--accent); margin-right: 8px; }
        .student-nav .nav-links { display: flex; gap: 4px; }
        .student-nav .nav-links a {
            padding: 7px 14px;
            font-size: 0.85rem;
            font-weight: 500;
            color: rgba(255,255,255,0.65);
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.2s;
        }
        .student-nav .nav-links a:hover,
        .student-nav .nav-links a.active { color: #fff; background: rgba(255,255,255,0.1); }
        .student-nav .nav-actions { display: flex; align-items: center; gap: 10px; }
        .student-nav .nav-user { font-size: 0.8rem; color: rgba(255,255,255,0.5); }
        .student-nav .btn-logout {
            font-size: 0.8rem;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 8px;
            border: 1px solid rgba(255,59,48,0.35);
            color: #ff6961;
            background: transparent;
            text-decoration: none;
            transition: all 0.2s;
        }
        .student-nav .btn-logout:hover { background: rgba(255,59,48,0.1); }
        .page-content { padding: 32px; }
    </style>
</head>
<body style="background: var(--bg);" data-theme="light">

    <nav class="student-nav">
        <a href="#" class="nav-brand"><i class="bi bi-mortarboard-fill"></i>Student Portal</a>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/student/dashboard" class="active">Available Forms</a>
            <a href="<%= request.getContextPath() %>/student/history">My History</a>
        </div>
        <div class="nav-actions">
            <button class="btn-theme" onclick="toggleTheme()"><i class="bi bi-moon-fill me-1"></i>Theme</button>
            <span class="nav-user"><i class="bi bi-person-circle me-1"></i>${user.fullName}</span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout"><i class="bi bi-box-arrow-right me-1"></i>Sign Out</a>
        </div>
    </nav>

    <div class="page-content">
        <h1 class="page-title">Pending Feedback</h1>
        <p class="page-subtitle">Complete these forms to share your experience</p>

        <c:if test="${not empty success}">
            <div class="alert alert-success animate-in d-flex align-items-center gap-2">
                <i class="bi bi-check-circle-fill"></i>${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger animate-in d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-triangle-fill"></i>${error}
            </div>
        </c:if>

        <div class="row g-4">
            <c:forEach var="f" items="${forms}">
                <div class="col-lg-4 col-md-6 animate-in">
                    <div class="form-card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <h5 class="fw-bold mb-0">${f.title}</h5>
                                <span class="badge bg-success">Active</span>
                            </div>
                            <p class="text-muted small mb-3">${f.description}</p>
                            <div class="d-flex gap-3 mb-4">
                                <small class="text-muted"><i class="bi bi-question-circle me-1"></i>${f.questionCount} Questions</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i>${f.createdAt}</small>
                            </div>
                            <a href="<%= request.getContextPath() %>/student/fill-form?id=${f.formId}" class="btn btn-primary w-100">
                                <i class="bi bi-pencil-fill me-2"></i>Fill Feedback
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty forms}">
                <div class="col-12">
                    <div class="card animate-in">
                        <div class="card-body empty-state">
                            <i class="bi bi-check2-circle" style="color:var(--green)"></i>
                            <h5 class="mt-3">All caught up!</h5>
                            <p class="text-muted mb-3">No pending feedback forms right now.</p>
                            <a href="<%= request.getContextPath() %>/student/history" class="btn btn-outline-primary btn-sm">
                                <i class="bi bi-clock-history me-1"></i>View History
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleTheme(){const n=document.body.getAttribute('data-theme')==='dark'?'light':'dark';document.body.setAttribute('data-theme',n);localStorage.setItem('theme',n);}
        document.addEventListener('DOMContentLoaded',()=>{const t=localStorage.getItem('theme');if(t)document.body.setAttribute('data-theme',t);});
    </script>
</body>
</html>
