package com.studentfeedback.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.studentfeedback.dao.CourseDAO;
import com.studentfeedback.dao.FormDAO;
import com.studentfeedback.model.Form;
import com.studentfeedback.model.User;

/**
 * AdminFormServlet - Handles CRUD operations for feedback forms.
 * GET  /admin/forms             -> List all forms
 * GET  /admin/forms?action=edit&id=X -> Show edit form
 * GET  /admin/forms?action=delete&id=X -> Delete a form
 * GET  /admin/forms?action=toggle&id=X -> Toggle active status
 * POST /admin/forms             -> Create or update a form
 */
public class AdminFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FormDAO formDAO = new FormDAO();
    private CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Handle Delete
        if ("delete".equals(action)) {
            int formId = Integer.parseInt(request.getParameter("id"));
            formDAO.deleteForm(formId);
            response.sendRedirect(request.getContextPath() + "/admin/forms");
            return;
        }

        // Handle Toggle Active/Inactive
        if ("toggle".equals(action)) {
            int formId = Integer.parseInt(request.getParameter("id"));
            Form form = formDAO.findById(formId);
            if (form != null) {
                form.setActive(!form.isActive());
                formDAO.updateForm(form);
            }
            response.sendRedirect(request.getContextPath() + "/admin/forms");
            return;
        }

        // Handle Edit (load form for editing)
        if ("edit".equals(action)) {
            int formId = Integer.parseInt(request.getParameter("id"));
            Form form = formDAO.findById(formId);
            request.setAttribute("editForm", form);
        }

        // List all forms
        request.setAttribute("forms", formDAO.findAll());
        request.setAttribute("courses", courseDAO.findAll());

        request.getRequestDispatcher("/WEB-INF/views/admin/forms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String formIdStr = request.getParameter("formId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String courseIdStr = request.getParameter("courseId");
        String isActiveStr = request.getParameter("isActive");

        // Build Form object
        Form form = new Form();
        form.setTitle(title);
        form.setDescription(description);
        form.setCreatedBy(user.getUserId());

        // Parse course ID (empty means all students)
        if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
            form.setCourseId(Integer.parseInt(courseIdStr));
        } else {
            form.setCourseId(null);
        }

        // Handle checkbox for active status
        form.setActive(isActiveStr != null);

        if (formIdStr != null && !formIdStr.trim().isEmpty()) {
            // UPDATE existing form
            form.setFormId(Integer.parseInt(formIdStr));
            formDAO.updateForm(form);
            response.sendRedirect(request.getContextPath() + "/admin/forms");
        } else {
            // CREATE new form, then redirect to form builder to add questions
            int newFormId = formDAO.createForm(form);
            if (newFormId > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/form-builder?id=" + newFormId);
            } else {
                request.setAttribute("error", "Failed to create form.");
                request.setAttribute("forms", formDAO.findAll());
                request.setAttribute("courses", courseDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/admin/forms.jsp").forward(request, response);
            }
        }
    }
}
