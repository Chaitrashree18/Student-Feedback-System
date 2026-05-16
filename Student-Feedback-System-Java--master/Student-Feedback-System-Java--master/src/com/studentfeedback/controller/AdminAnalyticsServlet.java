package com.studentfeedback.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.studentfeedback.dao.FormDAO;
import com.studentfeedback.dao.QuestionDAO;
import com.studentfeedback.dao.ResponseDAO;
import com.studentfeedback.model.Answer;
import com.studentfeedback.model.Form;
import com.studentfeedback.model.Question;
import com.studentfeedback.model.Response;

/**
 * AdminAnalyticsServlet - Shows feedback analytics and individual responses.
 * GET /admin/analytics                    -> Show form selection
 * GET /admin/analytics?formId=X           -> Show analytics for a specific form
 * GET /admin/analytics?formId=X&responseId=Y -> Show details of a specific response
 */
public class AdminAnalyticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FormDAO formDAO = new FormDAO();
    private QuestionDAO questionDAO = new QuestionDAO();
    private ResponseDAO responseDAO = new ResponseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formIdStr = request.getParameter("formId");

        if (formIdStr != null && !formIdStr.trim().isEmpty()) {
            int formId = Integer.parseInt(formIdStr);

            // Load form details
            Form form = formDAO.findById(formId);
            List<Question> questions = questionDAO.findByFormId(formId);
            List<Response> responses = responseDAO.findByFormId(formId);
            Map<String, Double> avgRatings = responseDAO.getAverageRatings(formId);

            request.setAttribute("selectedForm", form);
            request.setAttribute("questions", questions);
            request.setAttribute("responses", responses);
            request.setAttribute("avgRatings", avgRatings);

            // Check if viewing a specific response's answers
            String responseIdStr = request.getParameter("responseId");
            if (responseIdStr != null && !responseIdStr.trim().isEmpty()) {
                int responseId = Integer.parseInt(responseIdStr);
                List<Answer> answers = responseDAO.getAnswersByResponseId(responseId);
                request.setAttribute("viewAnswers", answers);
                request.setAttribute("viewResponseId", responseId);
            }
        }

        // Always load all forms for the dropdown
        request.setAttribute("allForms", formDAO.findAll());

        request.getRequestDispatcher("/WEB-INF/views/admin/analytics.jsp").forward(request, response);
    }
}
// Force rebuild comment
