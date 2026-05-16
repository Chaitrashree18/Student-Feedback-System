<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${form.title} — Fill Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="<%= request.getContextPath() %>/css/style.css?v=1777051475527" rel="stylesheet">
    <style>
        .student-nav { background:var(--sidebar-bg); padding:14px 28px; display:flex; align-items:center; justify-content:space-between; border-bottom:1px solid rgba(255,255,255,0.06); position:sticky; top:0; z-index:100; }
        .student-nav .nav-brand { font-size:1rem; font-weight:700; color:#fff; text-decoration:none; }
        .student-nav .nav-brand i { color:var(--accent); margin-right:8px; }
        .student-nav .nav-links { display:flex; gap:4px; }
        .student-nav .nav-links a { padding:7px 14px; font-size:0.85rem; font-weight:500; color:rgba(255,255,255,0.65); border-radius:8px; text-decoration:none; transition:all 0.2s; }
        .student-nav .nav-links a:hover { color:#fff; background:rgba(255,255,255,0.1); }
        .student-nav .btn-back { font-size:0.8rem; font-weight:600; padding:6px 14px; border-radius:8px; border:1px solid rgba(255,255,255,0.15); color:rgba(255,255,255,0.7); background:transparent; text-decoration:none; transition:all 0.2s; }
        .student-nav .btn-back:hover { background:rgba(255,255,255,0.08); color:#fff; }
        .fill-form-container { max-width: 720px; margin: 40px auto; padding: 0 20px 60px; }
        .rating-btn { width:44px; height:44px; border-radius:50%; border:2px solid var(--border-strong); background:var(--surface); color:var(--text); font-weight:700; font-size:1rem; cursor:pointer; transition:all 0.2s var(--spring); display:flex; align-items:center; justify-content:center; }
        .rating-btn:hover { border-color:var(--accent); color:var(--accent); transform:scale(1.15); }
        input[type=radio]:checked + .rating-btn { background:var(--accent); border-color:var(--accent); color:#fff; transform:scale(1.15); }
        .rating-item { display:flex; flex-direction:column; align-items:center; gap:4px; }
        .rating-item label { display:flex; flex-direction:column; align-items:center; gap:4px; cursor:pointer; }
        .rating-item input[type=radio] { position:absolute; opacity:0; width:0; }
        .yesno-btn { padding:10px 28px; border-radius:10px; border:2px solid var(--border-strong); background:var(--surface); color:var(--text); font-weight:600; cursor:pointer; transition:all 0.2s; }
        .yesno-btn:hover { border-color:var(--accent); color:var(--accent); }
        input[type=radio].yn-radio:checked ~ .yesno-btn { background:var(--accent); border-color:var(--accent); color:#fff; }
    </style>
</head>
<body data-theme="light">

    <nav class="student-nav">
        <a href="#" class="nav-brand"><i class="bi bi-mortarboard-fill"></i>Student Portal</a>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/student/dashboard">Available Forms</a>
            <a href="<%= request.getContextPath() %>/student/history">My History</a>
        </div>
        <a href="<%= request.getContextPath() %>/student/dashboard" class="btn-back"><i class="bi bi-arrow-left me-1"></i>Dashboard</a>
    </nav>

    <div class="fill-form-container">
        <div class="form-header animate-in">
            <div class="d-flex align-items-center gap-2 mb-2">
                <span class="badge" style="background:rgba(255,255,255,0.2); color:#fff; font-size:0.75rem">Feedback Form</span>
            </div>
            <h1 style="font-size:1.8rem; font-weight:800; color:#fff; margin-bottom:6px; letter-spacing:-0.02em">${form.title}</h1>
            <p style="color:rgba(255,255,255,0.7); margin:0; font-size:0.95rem">${form.description}</p>
        </div>

        <c:if test="${empty questions}">
            <div class="card animate-in">
                <div class="card-body empty-state">
                    <i class="bi bi-exclamation-circle text-warning"></i>
                    <p class="mt-2 text-muted">This form has no questions configured yet.</p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty questions}">
            <form action="<%= request.getContextPath() %>/student/fill-form" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="formId" value="${form.formId}">

                <c:forEach var="q" items="${questions}" varStatus="s">
                    <div class="question-box animate-in" style="animation-delay:${s.index * 0.05 + 0.1}s">
                        <p class="fw-bold mb-1" style="color:var(--text-secondary); font-size:0.75rem; text-transform:uppercase; letter-spacing:0.06em">Question ${q.questionOrder}</p>
                        <h6 class="fw-bold mb-4">${q.questionText} <span class="text-danger">*</span></h6>

                        <%-- TEXT --%>
                        <c:if test="${q.questionType eq 'TEXT'}">
                            <textarea name="question_${q.questionId}" class="form-control" rows="3" required placeholder="Share your thoughts..."></textarea>
                        </c:if>

                        <%-- RATING --%>
                        <c:if test="${q.questionType eq 'RATING'}">
                            <div class="d-flex gap-3 align-items-end">
                                <c:forEach var="i" begin="1" end="5">
                                    <label class="rating-item">
                                        <input type="radio" name="question_${q.questionId}" value="${i}" required style="position:absolute;opacity:0;width:0">
                                        <div class="rating-btn" onclick="selectRating(this, 'question_${q.questionId}', ${i})">${i}</div>
                                        <small class="text-muted" style="font-size:0.7rem">${i == 1 ? 'Poor' : i == 5 ? 'Great' : ''}</small>
                                    </label>
                                </c:forEach>
                            </div>
                        </c:if>

                        <%-- YESNO --%>
                        <c:if test="${q.questionType eq 'YESNO'}">
                            <div class="d-flex gap-3">
                                <label class="d-flex align-items-center gap-2" style="cursor:pointer">
                                    <input type="radio" name="question_${q.questionId}" value="Yes" required style="display:none" id="yn_y_${q.questionId}"
                                        onchange="styleYesNo('${q.questionId}', 'Yes')">
                                    <div class="yesno-btn" id="yesBtn_${q.questionId}" onclick="document.getElementById('yn_y_${q.questionId}').click()">
                                        <i class="bi bi-check-circle me-1"></i>Yes
                                    </div>
                                </label>
                                <label class="d-flex align-items-center gap-2" style="cursor:pointer">
                                    <input type="radio" name="question_${q.questionId}" value="No" required style="display:none" id="yn_n_${q.questionId}"
                                        onchange="styleYesNo('${q.questionId}', 'No')">
                                    <div class="yesno-btn" id="noBtn_${q.questionId}" onclick="document.getElementById('yn_n_${q.questionId}').click()">
                                        <i class="bi bi-x-circle me-1"></i>No
                                    </div>
                                </label>
                            </div>
                        </c:if>

                        <%-- MCQ --%>
                        <c:if test="${q.questionType eq 'MCQ'}">
                            <select name="question_${q.questionId}" class="form-select" required style="max-width:380px">
                                <option value="">-- Select an option --</option>
                                <c:forEach items="${q.options.split(',')}" var="opt">
                                    <option value="${opt.trim()}">${opt.trim()}</option>
                                </c:forEach>
                            </select>
                        </c:if>

                        <%-- DATE --%>
                        <c:if test="${q.questionType eq 'DATE'}">
                            <input type="date" name="question_${q.questionId}" class="form-control" style="max-width:240px" required>
                        </c:if>

                        <%-- FILE --%>
                        <c:if test="${q.questionType eq 'FILE'}">
                            <div class="dropzone-box" onclick="document.getElementById('file_${q.questionId}').click()">
                                <i class="bi bi-cloud-arrow-up" style="font-size:2rem; color:var(--accent); display:block; margin-bottom:8px"></i>
                                <p class="mb-1 fw-semibold" style="color:var(--text)">Click to upload</p>
                                <small class="text-muted">Max 10MB</small>
                                <input type="file" id="file_${q.questionId}" name="question_${q.questionId}" class="d-none" required
                                    onchange="document.getElementById('fname_${q.questionId}').textContent=this.files[0].name">
                            </div>
                            <p class="mt-1 small" style="color:var(--green)" id="fname_${q.questionId}"></p>
                        </c:if>
                    </div>
                </c:forEach>

                <div class="text-end mt-4">
                    <button type="submit" class="btn btn-primary btn-lg px-5">
                        <i class="bi bi-send-fill me-2"></i>Submit Feedback
                    </button>
                </div>
            </form>
        </c:if>
    </div>

    <script>
        function selectRating(el, name, val){
            document.querySelectorAll('.rating-btn').forEach(b=>{if(b.closest('label') && b.closest('label').querySelector('input[name="'+name+'"]'))b.style.css?v=1777051475527''});
            el.style.background='var(--accent)';el.style.borderColor='var(--accent)';el.style.color='#fff';el.style.transform='scale(1.15)';
            const radio=el.closest('label').querySelector('input[type=radio]');if(radio){radio.value=val;radio.checked=true;}
        }
        function styleYesNo(id,val){
            const yb=document.getElementById('yesBtn_'+id),nb=document.getElementById('noBtn_'+id);
            yb.style.css?v=1777051475527'';nb.style.css?v=1777051475527'';
            if(val==='Yes'){yb.style.background='var(--accent)';yb.style.borderColor='var(--accent)';yb.style.color='#fff';}
            else{nb.style.background='var(--red)';nb.style.borderColor='var(--red)';nb.style.color='#fff';}
        }
        function toggleTheme(){const n=document.body.getAttribute('data-theme')==='dark'?'light':'dark';document.body.setAttribute('data-theme',n);localStorage.setItem('theme',n);}
        document.addEventListener('DOMContentLoaded',()=>{const t=localStorage.getItem('theme');if(t)document.body.setAttribute('data-theme',t);});
    </script>
</body>
</html>
