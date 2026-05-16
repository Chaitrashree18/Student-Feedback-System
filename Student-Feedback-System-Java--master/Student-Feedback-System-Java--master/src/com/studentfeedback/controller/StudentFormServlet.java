package com.studentfeedback.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.io.File;

import com.studentfeedback.dao.FormDAO;
import com.studentfeedback.dao.QuestionDAO;
import com.studentfeedback.dao.ResponseDAO;
import com.studentfeedback.model.Answer;
import com.studentfeedback.model.Form;
import com.studentfeedback.model.Question;
import com.studentfeedback.model.Response;
import com.studentfeedback.model.User;

/**
 * StudentFormServlet - Handles loading and submitting feedback forms.
 * GET  /student/form?id=X -> Load the form with its questions
 * POST /student/form      -> Submit the completed form
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class StudentFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FormDAO formDAO = new FormDAO();
    private QuestionDAO questionDAO = new QuestionDAO();
    private ResponseDAO responseDAO = new ResponseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        int formId = Integer.parseInt(idStr);
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if already submitted
        if (responseDAO.hasSubmitted(formId, user.getUserId())) {
            session.setAttribute("error", "You have already submitted this form.");
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        // Load form and questions
        Form form = formDAO.findById(formId);
        if (form == null || !form.isActive()) {
            session.setAttribute("error", "This form is not available.");
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        List<Question> questions = questionDAO.findByFormId(formId);

        request.setAttribute("form", form);
        request.setAttribute("questions", questions);
        request.getRequestDispatcher("/WEB-INF/views/student/fill-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formIdStr = request.getParameter("formId");
        if (formIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        int formId = Integer.parseInt(formIdStr);
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Prevent duplicate submission
        if (responseDAO.hasSubmitted(formId, user.getUserId())) {
            session.setAttribute("error", "You have already submitted this form.");
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        // Get all questions for this form
        List<Question> questions = questionDAO.findByFormId(formId);

        // Collect answers
        List<Answer> answers = new ArrayList<Answer>();
        
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        for (Question q : questions) {
            Answer answer = new Answer();
            answer.setQuestionId(q.getQuestionId());
            
            if ("FILE".equals(q.getQuestionType())) {
                Part filePart = request.getPart("question_" + q.getQuestionId());
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
                    filePart.write(uploadPath + File.separator + fileName);
                    answer.setAnswerText("/uploads/" + fileName);
                } else {
                    answer.setAnswerText("");
                }
            } else {
                String answerText = request.getParameter("question_" + q.getQuestionId());
                answer.setAnswerText(answerText != null ? answerText.trim() : "");
            }
            
            answers.add(answer);
        }

        // Build Response object
        Response resp = new Response();
        resp.setFormId(formId);
        resp.setUserId(user.getUserId());
        resp.setAnswers(answers);

        // Submit
        if (responseDAO.submitResponse(resp)) {
            session.setAttribute("success", "Feedback submitted successfully! Thank you for your response.");
        } else {
            session.setAttribute("error", "Failed to submit feedback. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/student/dashboard");
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown_file";
    }
}
