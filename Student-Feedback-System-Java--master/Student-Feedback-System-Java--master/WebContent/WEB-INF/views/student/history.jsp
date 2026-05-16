<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My History — Student Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="<%= request.getContextPath() %>/css/style.css?v=1777051475532" rel="stylesheet">
    <style>
        .student-nav { background:var(--sidebar-bg); padding:14px 28px; display:flex; align-items:center; justify-content:space-between; border-bottom:1px solid rgba(255,255,255,0.06); position:sticky; top:0; z-index:100; }
        .student-nav .nav-brand { font-size:1rem; font-weight:700; color:#fff; text-decoration:none; }
        .student-nav .nav-brand i { color:var(--accent); margin-right:8px; }
        .student-nav .nav-links { display:flex; gap:4px; }
        .student-nav .nav-links a { padding:7px 14px; font-size:0.85rem; font-weight:500; color:rgba(255,255,255,0.65); border-radius:8px; text-decoration:none; transition:all 0.2s; }
        .student-nav .nav-links a:hover, .student-nav .nav-links a.active { color:#fff; background:rgba(255,255,255,0.1); }
        .student-nav .btn-logout { font-size:0.8rem; font-weight:600; padding:6px 14px; border-radius:8px; border:1px solid rgba(255,59,48,0.35); color:#ff6961; background:transparent; text-decoration:none; transition:all 0.2s; }
        .student-nav .btn-logout:hover { background:rgba(255,59,48,0.1); }
        .page-content { padding: 32px; }
        .answer-panel { position: sticky; top: 80px; }
    </style>
</head>
<body data-theme="light">

    <nav class="student-nav">
        <a href="#" class="nav-brand"><i class="bi bi-mortarboard-fill"></i>Student Portal</a>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/student/dashboard">Available Forms</a>
            <a href="<%= request.getContextPath() %>/student/history" class="active">My History</a>
        </div>
        <div style="display:flex;align-items:center;gap:10px">
            <button class="btn-theme" onclick="toggleTheme()"><i class="bi bi-moon-fill me-1"></i>Theme</button>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout"><i class="bi bi-box-arrow-right me-1"></i>Sign Out</a>
        </div>
    </nav>

    <div class="page-content">
        <h1 class="page-title">Submission History</h1>
        <p class="page-subtitle">Review your past feedback submissions</p>

        <div class="row g-4">
            <div class="col-lg-${not empty viewAnswers ? '7' : '12'}">
                <div class="card animate-in">
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Form</th>
                                    <th>Submitted</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sub" items="${submissions}">
                                    <tr class="${viewResponseId == sub.responseId ? 'table-primary' : ''}">
                                        <td><span class="badge bg-secondary">${sub.responseId}</span></td>
                                        <td>
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${not empty sub.formTitle}">${sub.formTitle}</c:when>
                                                    <c:otherwise>Form #${sub.formId}</c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </td>
                                        <td><small class="text-muted">${sub.submittedAt}</small></td>
                                        <td>
                                            <a href="<%= request.getContextPath() %>/student/history?responseId=${sub.responseId}" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye me-1"></i>View
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty submissions}">
                                    <tr>
                                        <td colspan="4">
                                            <div class="empty-state">
                                                <i class="bi bi-inbox"></i>
                                                No submissions yet.
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <c:if test="${not empty viewAnswers}">
                <div class="col-lg-5">
                    <div class="card animate-scale answer-panel" style="border-top:3px solid var(--accent)">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h6 class="mb-0 fw-bold"><i class="bi bi-card-list me-2"></i>Submission #${viewResponseId}</h6>
                            <a href="<%= request.getContextPath() %>/student/history" class="btn btn-sm btn-outline-secondary"><i class="bi bi-x-lg"></i></a>
                        </div>
                        <div class="card-body" style="max-height:65vh; overflow-y:auto">
                            <c:forEach var="ans" items="${viewAnswers}">
                                <div class="mb-3 pb-3 border-bottom">
                                    <p class="fw-bold mb-1" style="font-size:0.85rem; color:var(--text-secondary); text-transform:uppercase; letter-spacing:0.04em">Q${ans.questionId}</p>
                                    <c:choose>
                                        <c:when test="${ans.questionType == 'FILE'}">
                                            <a href="<%= request.getContextPath() %>${ans.answerText}" target="_blank" class="btn btn-sm btn-outline-primary"><i class="bi bi-download me-1"></i>Download</a>
                                        </c:when>
                                        <c:when test="${ans.questionType == 'RATING'}">
                                            <span style="color:var(--orange); font-weight:700; font-size:1.1rem">
                                                <c:forEach begin="1" end="${ans.answerText}"><i class="bi bi-star-fill"></i></c:forEach>
                                                &nbsp;${ans.answerText}/5
                                            </span>
                                        </c:when>
                                        <c:when test="${ans.answerText == 'Yes'}">
                                            <span style="color:var(--green); font-weight:600"><i class="bi bi-check-circle-fill me-1"></i>Yes</span>
                                        </c:when>
                                        <c:when test="${ans.answerText == 'No'}">
                                            <span style="color:var(--red); font-weight:600"><i class="bi bi-x-circle-fill me-1"></i>No</span>
                                        </c:when>
                                        <c:otherwise>
                                            <p style="color:var(--text); margin:0">${ans.answerText}</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>
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
