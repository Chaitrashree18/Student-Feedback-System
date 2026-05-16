package com.studentfeedback.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.studentfeedback.dao.ResponseDAO;
import com.studentfeedback.model.Answer;
import com.studentfeedback.model.Response;
import com.studentfeedback.model.User;

/**
 * StudentHistoryServlet - Shows the student's past feedback submissions.
 * GET /student/history                    -> List all submissions
 * GET /student/history?responseId=X       -> View specific submission details
 */
public class StudentHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ResponseDAO responseDAO = new ResponseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Get all submissions by this student
        List<Response> submissions = responseDAO.findByUserId(user.getUserId());
        request.setAttribute("submissions", submissions);

        // Check if viewing a specific response's details
        String responseIdStr = request.getParameter("responseId");
        if (responseIdStr != null && !responseIdStr.trim().isEmpty()) {
            int responseId = Integer.parseInt(responseIdStr);
            List<Answer> answers = responseDAO.getAnswersByResponseId(responseId);
            request.setAttribute("viewAnswers", answers);
            request.setAttribute("viewResponseId", Integer.parseInt(responseIdStr));
        }

        request.getRequestDispatcher("/WEB-INF/views/student/history.jsp").forward(request, response);
    }
}
