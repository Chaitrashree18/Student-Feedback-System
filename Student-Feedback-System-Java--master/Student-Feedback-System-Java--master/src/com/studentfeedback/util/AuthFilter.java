package com.studentfeedback.util;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.studentfeedback.model.User;

/**
 * Authentication Filter.
 * Protects /admin/* and /student/* URLs.
 * Redirects to login if user is not authenticated.
 * Also enforces role-based access control.
 */
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String uri = httpRequest.getRequestURI();

        // Check if user is logged in
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            // Not logged in - redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Role-based access control
        if (uri.contains("/admin/") && !"ADMIN".equals(user.getRoleName())) {
            // Student trying to access admin pages
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/student/dashboard");
            return;
        }

        if (uri.contains("/student/") && !"STUDENT".equals(user.getRoleName())) {
            // Admin trying to access student pages
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/dashboard");
            return;
        }

        // User is authenticated and authorized - continue
        chain.doFilter(request, response);
    }
}
