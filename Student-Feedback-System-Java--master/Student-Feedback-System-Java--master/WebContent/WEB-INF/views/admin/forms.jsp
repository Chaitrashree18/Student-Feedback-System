<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Forms — Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="<%= request.getContextPath() %>/css/style.css?v=1777051475515" rel="stylesheet">
</head>
<body data-theme="light">

    <nav class="sidebar" id="sidebar">
        <div class="sidebar-brand"><i class="bi bi-mortarboard-fill"></i> Feedback System</div>
        <div class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin/forms" class="sidebar-link active"><i class="bi bi-ui-radios"></i> Manage Forms</a>
            <a href="<%= request.getContextPath() %>/admin/analytics" class="sidebar-link"><i class="bi bi-bar-chart-line-fill"></i> Analytics</a>
        </div>
        <div class="sidebar-footer">
            <span class="user-name"><i class="bi bi-person-circle"></i> ${user.fullName}</span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout"><i class="bi bi-box-arrow-left me-1"></i>Sign Out</a>
        </div>
    </nav>

    <div class="sidebar-backdrop" id="sidebarBackdrop" onclick="closeSidebar()"></div>

    <main class="main-content">
        <div class="topbar">
            <button class="hamburger-btn" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
            <button class="btn-theme" onclick="toggleTheme()"><i class="bi bi-moon-fill me-1"></i> Theme</button>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="page-title mb-0">Feedback Forms</h1>
                <p class="page-subtitle mb-0">Create and manage your feedback forms</p>
            </div>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#formModal">
                <i class="bi bi-plus-lg me-1"></i> New Form
            </button>
        </div>

        <c:if test="${not empty error}"><div class="alert alert-danger animate-in">${error}</div></c:if>
        <c:if test="${not empty success}"><div class="alert alert-success animate-in">${success}</div></c:if>

        <div class="card animate-in" style="animation-delay:.1s">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="f" items="${forms}">
                            <tr>
                                <td><span class="badge bg-secondary">${f.formId}</span></td>
                                <td>
                                    <strong>${f.title}</strong>
                                    <c:if test="${not empty f.description}"><br><small class="text-muted">${f.description}</small></c:if>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/admin/forms?action=toggle&id=${f.formId}"
                                       class="badge text-decoration-none bg-${f.active ? 'success' : 'danger'}"
                                       style="font-size:.75rem">
                                        ${f.active ? 'Active' : 'Inactive'}
                                    </a>
                                </td>
                                <td><small>${f.createdAt}</small></td>
                                <td>
                                    <div class="d-flex gap-1">
                                        <a href="<%= request.getContextPath() %>/admin/form-builder?id=${f.formId}" class="btn btn-sm btn-outline-primary"><i class="bi bi-list-task"></i></a>
                                        <a href="<%= request.getContextPath() %>/admin/analytics?formId=${f.formId}" class="btn btn-sm btn-outline-info"><i class="bi bi-bar-chart"></i></a>
                                        <a href="<%= request.getContextPath() %>/admin/forms?action=delete&id=${f.formId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this form?');"><i class="bi bi-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty forms}">
                            <tr><td colspan="5" class="empty-state"><i class="bi bi-inbox"></i>No forms yet. Create your first one!</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Modal -->
    <div class="modal fade" id="formModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="<%= request.getContextPath() %>/admin/forms" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold">Create Feedback Form</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" required placeholder="e.g., Mid-Term Feedback">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Description</label>
                            <textarea name="description" class="form-control" rows="2" placeholder="Optional description..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Assign to Course (Optional)</label>
                            <select name="courseId" class="form-select">
                                <option value="">-- All Students --</option>
                                <c:forEach var="c" items="${courses}"><option value="${c.courseId}">${c.courseCode} - ${c.courseName}</option></c:forEach>
                            </select>
                        </div>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" name="isActive" id="isActive" checked>
                            <label class="form-check-label" for="isActive">Active (Visible to Students)</label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Create</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleSidebar() { document.getElementById('sidebar').classList.toggle('active'); document.getElementById('sidebarBackdrop').classList.toggle('active'); }
        function closeSidebar() { document.getElementById('sidebar').classList.remove('active'); document.getElementById('sidebarBackdrop').classList.remove('active'); }
        function toggleTheme() { const n = document.body.getAttribute('data-theme')==='dark'?'light':'dark'; document.body.setAttribute('data-theme',n); localStorage.setItem('theme',n); }
        document.addEventListener('DOMContentLoaded', () => { const t=localStorage.getItem('theme'); if(t) document.body.setAttribute('data-theme',t); });
    </script>
</body>
</html>
