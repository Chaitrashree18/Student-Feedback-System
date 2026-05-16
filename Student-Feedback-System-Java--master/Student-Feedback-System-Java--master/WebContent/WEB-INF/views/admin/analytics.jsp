<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Analytics — Admin</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
            <link href="<%= request.getContextPath() %>/css/style.css?v=1777051475500" rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        </head>

        <body data-theme="light">

            <nav class="sidebar" id="sidebar">
                <div class="sidebar-brand"><i class="bi bi-mortarboard-fill"></i> Feedback System</div>
                <div class="sidebar-nav">
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link"><i
                            class="bi bi-grid-1x2-fill"></i> Dashboard</a>
                    <a href="<%= request.getContextPath() %>/admin/forms" class="sidebar-link"><i
                            class="bi bi-ui-radios"></i> Manage Forms</a>
                    <a href="<%= request.getContextPath() %>/admin/analytics" class="sidebar-link active"><i
                            class="bi bi-bar-chart-line-fill"></i> Analytics</a>
                </div>
                <div class="sidebar-footer">
                    <span class="user-name"><i class="bi bi-person-circle"></i> ${user.fullName}</span>
                    <a href="<%= request.getContextPath() %>/logout" class="btn-logout"><i
                            class="bi bi-box-arrow-left me-1"></i>Sign Out</a>
                </div>
            </nav>

            <div class="sidebar-backdrop" id="sidebarBackdrop" onclick="closeSidebar()"></div>

            <main class="main-content">
                <div class="topbar">
                    <button class="hamburger-btn" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
                    <button class="btn-theme" onclick="toggleTheme()"><i class="bi bi-moon-fill me-1"></i>
                        Theme</button>
                </div>

                <h1 class="page-title">Feedback Analytics</h1>
                <p class="page-subtitle">Visualize and explore student feedback data</p>

                <!-- Form Selector -->
                <div class="card mb-4 animate-in">
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/admin/analytics" method="GET"
                            class="d-flex align-items-center gap-3 flex-wrap">
                            <label class="fw-bold mb-0">Select Form:</label>
                            <select name="formId" class="form-select" style="max-width:400px;"
                                onchange="this.form.submit()">
                                <option value="">-- Choose a Form --</option>
                                <c:forEach var="f" items="${allForms}">
                                    <option value="${f.formId}" ${selectedForm !=null && selectedForm.formId==f.formId
                                        ? 'selected' : '' }>${f.title}</option>
                                </c:forEach>
                            </select>
                        </form>
                    </div>
                </div>

                <c:if test="${not empty selectedForm}">
                    <!-- Stats -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-4 col-6">
                            <div class="stat-card stat-primary"><span class="stat-label">Form</span>
                                <h5 class="fw-bold mt-2">${selectedForm.title}</h5>
                            </div>
                        </div>
                        <div class="col-md-4 col-6">
                            <div class="stat-card stat-success"><span class="stat-label">Responses</span>
                                <div class="stat-value">${responses.size()}</div>
                            </div>
                        </div>
                        <div class="col-md-4 col-6">
                            <div class="stat-card stat-info"><span class="stat-label">Questions</span>
                                <div class="stat-value">${questions.size()}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Charts -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <div class="card animate-in" style="animation-delay:.1s">
                                <div class="card-header">
                                    <h6 class="mb-0 fw-bold"><i
                                            class="bi bi-bar-chart-fill me-2 text-primary"></i>Average Ratings</h6>
                                </div>
                                <div class="card-body"><canvas id="barChart" style="max-height:280px"></canvas></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card animate-in" style="animation-delay:.15s">
                                <div class="card-header">
                                    <h6 class="mb-0 fw-bold"><i class="bi bi-pie-chart-fill me-2 text-info"></i>Question
                                        Types</h6>
                                </div>
                                <div class="card-body"><canvas id="pieChart" style="max-height:280px"></canvas></div>
                            </div>
                        </div>
                    </div>

                    <!-- Submissions Table -->
                    <div class="card animate-in mb-4" style="animation-delay:.2s">
                        <div class="card-header">
                            <h6 class="mb-0 fw-bold"><i class="bi bi-people-fill me-2"></i>Submissions</h6>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty responses}">
                                    <div class="empty-state"><i class="bi bi-inbox"></i>No responses yet.</div>
                                </c:when>
                                <c:otherwise>
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>USN</th>
                                                <th>Student</th>
                                                <th>Submitted</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="r" items="${responses}">
                                                <tr>
                                                    <td><span class="badge bg-secondary">#${r.responseId}</span></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty r.usn}">${r.usn}</c:when>
                                                            <c:otherwise><span class="text-muted">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${r.studentName}</td>
                                                    <td><small class="text-muted">${r.submittedAt}</small></td>
                                                    <td><a href="<%= request.getContextPath() %>/admin/analytics?formId=${selectedForm.formId}&responseId=${r.responseId}"
                                                            class="btn btn-sm btn-outline-primary"><i
                                                                class="bi bi-eye me-1"></i>View</a></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- View Answers -->
                    <c:if test="${not empty viewAnswers}">
                        <div class="card border-primary animate-scale mb-4">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h6 class="mb-0 fw-bold"><i class="bi bi-card-list me-2"></i>Submission
                                    #${viewResponseId}</h6>
                                <a href="<%= request.getContextPath() %>/admin/analytics?formId=${selectedForm.formId}"
                                    class="btn btn-sm btn-outline-secondary"><i class="bi bi-x-lg"></i></a>
                            </div>
                            <div class="card-body">
                                <c:forEach var="ans" items="${viewAnswers}">
                                    <div class="mb-3 pb-3 border-bottom">
                                        <p class="fw-bold mb-1"
                                            style="font-size:0.85rem; color:var(--text-secondary); text-transform:uppercase; letter-spacing:0.04em">
                                            Q${ans.questionId}</p>
                                        <c:choose>
                                            <c:when test="${ans.questionType == 'FILE'}">
                                                <a href="<%= request.getContextPath() %>${ans.answerText}"
                                                    target="_blank" class="btn btn-sm btn-outline-primary mt-1">
                                                    <i class="bi bi-download me-1"></i>Download File
                                                </a>
                                            </c:when>
                                            <c:when test="${ans.questionType == 'RATING'}">
                                                <span style="color:var(--orange); font-weight:700; font-size:1.1rem">
                                                    <c:forEach begin="1" end="${ans.answerText}"><i
                                                            class="bi bi-star-fill"></i></c:forEach>
                                                    &nbsp;${ans.answerText}/5
                                                </span>
                                            </c:when>
                                            <c:when test="${ans.answerText == 'Yes'}">
                                                <span style="color:var(--green); font-weight:600"><i
                                                        class="bi bi-check-circle-fill me-1"></i>Yes</span>
                                            </c:when>
                                            <c:when test="${ans.answerText == 'No'}">
                                                <span style="color:var(--red); font-weight:600"><i
                                                        class="bi bi-x-circle-fill me-1"></i>No</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">${ans.answerText}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </c:if>
            </main>

            <c:if test="${not empty selectedForm}">
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const formId = ${ selectedForm.formId };
                        fetch('<%= request.getContextPath() %>/admin/api/chart-data?formId=' + formId)
                            .then(r => r.json()).then(data => {
                                const barCtx = document.getElementById('barChart').getContext('2d');
                                if (data.averageRatings && Object.keys(data.averageRatings).length > 0) {
                                    new Chart(barCtx, { type: 'bar', data: { labels: Object.keys(data.averageRatings), datasets: [{ label: 'Avg Rating', data: Object.values(data.averageRatings), backgroundColor: 'rgba(0,122,255,0.5)', borderColor: 'rgba(0,122,255,1)', borderWidth: 1, borderRadius: 6 }] }, options: { responsive: true, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true, max: 5 } } } });
                                } else { document.getElementById('barChart').parentElement.innerHTML = '<p class="text-muted text-center py-4">No rating data.</p>'; }
                                const pieCtx = document.getElementById('pieChart').getContext('2d');
                                if (data.categoryDistribution && Object.keys(data.categoryDistribution).length > 0) {
                                    new Chart(pieCtx, { type: 'doughnut', data: { labels: Object.keys(data.categoryDistribution), datasets: [{ data: Object.values(data.categoryDistribution), backgroundColor: ['#007aff', '#34c759', '#ff9500', '#5ac8fa', '#af52de', '#ff3b30'] }] }, options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom', labels: { padding: 16, usePointStyle: true } } } } });
                                } else { document.getElementById('pieChart').parentElement.innerHTML = '<p class="text-muted text-center py-4">No data.</p>'; }
                            }).catch(e => console.error(e));
                    });
                </script>
            </c:if>
            <script>
                function toggleSidebar() { document.getElementById('sidebar').classList.toggle('active'); document.getElementById('sidebarBackdrop').classList.toggle('active') }
                function closeSidebar() { document.getElementById('sidebar').classList.remove('active'); document.getElementById('sidebarBackdrop').classList.remove('active') }
                function toggleTheme() { const n = document.body.getAttribute('data-theme') === 'dark' ? 'light' : 'dark'; document.body.setAttribute('data-theme', n); localStorage.setItem('theme', n) }
                document.addEventListener('DOMContentLoaded', () => { const t = localStorage.getItem('theme'); if (t) document.body.setAttribute('data-theme', t) });
            </script>
        </body>

        </html>