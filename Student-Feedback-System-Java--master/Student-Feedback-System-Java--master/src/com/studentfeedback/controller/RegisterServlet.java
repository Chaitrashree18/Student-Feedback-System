package com.studentfeedback.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.studentfeedback.dao.UserDAO;
import com.studentfeedback.model.User;

/**
 * RegisterServlet - Handles student self-registration.
 * GET  /register -> Display registration form
 * POST /register -> Create new student account
 */
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usn = request.getParameter("usn");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        // Validation
        if (usn == null || usn.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 4) {
            request.setAttribute("error", "Password must be at least 4 characters long.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isUsernameTaken(username.trim())) {
            request.setAttribute("error", "Username is already taken.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isEmailTaken(email.trim())) {
            request.setAttribute("error", "Email is already registered.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Create user
        User user = new User();
        user.setUsn(usn.trim());
        user.setUsername(username.trim());
        user.setPassword(password);
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());

        if (userDAO.register(user)) {
            request.setAttribute("success", "Registration successful! Please login with your credentials.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
