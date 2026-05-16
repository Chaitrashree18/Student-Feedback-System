package com.studentfeedback.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.studentfeedback.dao.FormDAO;
import com.studentfeedback.dao.QuestionDAO;
import com.studentfeedback.model.Form;
import com.studentfeedback.model.Question;

/**
 * AdminFormBuilderServlet - Manages questions within a feedback form.
 * GET  /admin/form-builder?id=X                          -> Show form builder
 * GET  /admin/form-builder?id=X&action=deleteQuestion&questionId=Y -> Delete a question
 * POST /admin/form-builder                                -> Add a question (supports AJAX)
 */
public class AdminFormBuilderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FormDAO formDAO = new FormDAO();
    private QuestionDAO questionDAO = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/forms");
            return;
        }

        int formId = Integer.parseInt(idStr);

        // Handle delete question action
        String action = request.getParameter("action");
        if ("deleteQuestion".equals(action)) {
            String questionIdStr = request.getParameter("questionId");
            if (questionIdStr != null) {
                questionDAO.deleteQuestion(Integer.parseInt(questionIdStr));
            }
            response.sendRedirect(request.getContextPath() + "/admin/form-builder?id=" + formId);
            return;
        }

        // Load form and its questions
        Form form = formDAO.findById(formId);
        if (form == null) {
            response.sendRedirect(request.getContextPath() + "/admin/forms");
            return;
        }

        List<Question> questions = questionDAO.findByFormId(formId);

        request.setAttribute("form", form);
        request.setAttribute("questions", questions);
        request.getRequestDispatcher("/WEB-INF/views/admin/form-builder.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formIdStr = request.getParameter("formId");
        String questionText = request.getParameter("questionText");
        String questionType = request.getParameter("questionType");
        String options = request.getParameter("options");
        String ajax = request.getParameter("ajax");

        if (formIdStr == null || questionText == null || questionType == null) {
            if ("true".equals(ajax)) {
                sendJsonResponse(response, false, "Missing required fields.");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/forms");
            }
            return;
        }

        int formId = Integer.parseInt(formIdStr);

        // Create question
        Question question = new Question();
        question.setFormId(formId);
        question.setQuestionText(questionText.trim());
        question.setQuestionType(questionType);
        question.setOptions("MCQ".equals(questionType) ? options : null);
        question.setQuestionOrder(questionDAO.getNextOrder(formId));

        boolean success = questionDAO.addQuestion(question);

        if ("true".equals(ajax)) {
            // AJAX response
            sendJsonResponse(response, success, success ? "Question added successfully." : "Failed to add question.");
        } else {
            // Regular form submission
            response.sendRedirect(request.getContextPath() + "/admin/form-builder?id=" + formId);
        }
    }

    /**
     * Send a simple JSON response for AJAX requests.
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
        out.flush();
    }
}
