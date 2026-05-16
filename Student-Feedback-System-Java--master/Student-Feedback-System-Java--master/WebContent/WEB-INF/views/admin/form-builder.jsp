<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Builder — ${form.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="<%= request.getContextPath() %>/css/style.css?v=1777051475513" rel="stylesheet">
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
            <a href="<%= request.getContextPath() %>/admin/forms" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Back</a>
            <button class="btn-theme" onclick="toggleTheme()"><i class="bi bi-moon-fill me-1"></i> Theme</button>
        </div>

        <h1 class="page-title">${form.title}</h1>
        <p class="page-subtitle">${form.description}</p>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card animate-in">
                    <div class="card-header"><h5 class="mb-0 fw-bold">Questions (${questions.size()})</h5></div>
                    <div class="card-body">
                        <c:if test="${empty questions}">
                            <div class="empty-state"><i class="bi bi-plus-circle"></i>No questions yet. Add one from the panel.</div>
                        </c:if>
                        <c:forEach var="q" items="${questions}">
                            <div class="question-card">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <span class="question-number">${q.questionOrder}</span>
                                        <strong>${q.questionText}</strong>
                                        <br><span class="badge bg-primary ms-4 mt-1">${q.questionType}</span>
                                        <c:if test="${q.questionType eq 'MCQ'}"><small class="text-muted ms-2">Options: ${q.options}</small></c:if>
                                    </div>
                                    <a href="<%= request.getContextPath() %>/admin/form-builder?id=${form.formId}&action=deleteQuestion&questionId=${q.questionId}"
                                       class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete?');"><i class="bi bi-trash"></i></a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card sticky-top animate-in" style="top:24px;animation-delay:.15s">
                    <div class="card-header"><h5 class="mb-0 fw-bold"><i class="bi bi-plus-circle me-2"></i>Add Question</h5></div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/admin/form-builder" method="POST">
                            <input type="hidden" name="formId" value="${form.formId}">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Type</label>
                                <select class="form-select" name="questionType" id="qType" required onchange="toggleOptions()">
                                    <option value="TEXT">Text (Paragraph)</option>
                                    <option value="RATING">Rating (1–5)</option>
                                    <option value="YESNO">Yes / No</option>
                                    <option value="MCQ">Multiple Choice</option>
                                    <option value="DATE">Date Picker</option>
                                    <option value="FILE">File Upload</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Question Text</label>
                                <input type="text" class="form-control" name="questionText" required placeholder="e.g., Rate the course...">
                            </div>
                            <div class="mb-3" id="optionsDiv" style="display:none;">
                                <label class="form-label fw-bold">MCQ Options</label>
                                <input type="text" class="form-control" name="options" id="mcqOptions" placeholder="Good, Average, Bad">
                                <small class="text-muted">Comma-separated</small>
                            </div>
                            <button type="submit" class="btn btn-success w-100"><i class="bi bi-plus-lg me-1"></i>Add to Form</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function toggleOptions(){const d=document.getElementById('optionsDiv'),m=document.getElementById('mcqOptions');if(document.getElementById('qType').value==='MCQ'){d.style.display='block';m.required=true}else{d.style.display='none';m.required=false}}
        function toggleSidebar(){document.getElementById('sidebar').classList.toggle('active');document.getElementById('sidebarBackdrop').classList.toggle('active')}
        function closeSidebar(){document.getElementById('sidebar').classList.remove('active');document.getElementById('sidebarBackdrop').classList.remove('active')}
        function toggleTheme(){const n=document.body.getAttribute('data-theme')==='dark'?'light':'dark';document.body.setAttribute('data-theme',n);localStorage.setItem('theme',n)}
        document.addEventListener('DOMContentLoaded',()=>{const t=localStorage.getItem('theme');if(t)document.body.setAttribute('data-theme',t)});
    </script>
</body>
</html>
