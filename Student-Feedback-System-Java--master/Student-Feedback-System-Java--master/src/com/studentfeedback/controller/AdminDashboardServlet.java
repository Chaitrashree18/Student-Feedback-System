package com.studentfeedback.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.studentfeedback.dao.FormDAO;

/**
 * AdminDashboardServlet - Displays admin dashboard with summary statistics.
 * GET /admin/dashboard -> Show total forms, active forms, total responses, total students
 */
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FormDAO formDAO = new FormDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch dashboard statistics
        request.setAttribute("totalForms", formDAO.getTotalForms());
        request.setAttribute("activeForms", formDAO.getActiveForms());
        request.setAttribute("totalResponses", formDAO.getTotalResponses());
        request.setAttribute("totalStudents", formDAO.getTotalStudents());

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
