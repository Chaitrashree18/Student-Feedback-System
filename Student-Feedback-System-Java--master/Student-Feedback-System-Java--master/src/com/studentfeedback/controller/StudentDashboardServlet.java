package com.studentfeedback.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.studentfeedback.dao.FormDAO;
import com.studentfeedback.model.Form;
import com.studentfeedback.model.User;

/**
 * StudentDashboardServlet - Shows available feedback forms for the student.
 * GET /student/dashboard -> List active forms not yet submitted by this student
 */
public class StudentDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FormDAO formDAO = new FormDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Get forms that are active and not yet submitted by this student
        List<Form> availableForms = formDAO.findActiveForStudent(user.getUserId());
        request.setAttribute("forms", availableForms);

        // Check for success/error messages from session (set after form submission)
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute("success");
        }
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }

        request.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(request, response);
    }
}
