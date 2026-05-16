package com.studentfeedback.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.studentfeedback.model.Form;
import com.studentfeedback.util.DBConnection;

/**
 * Data Access Object for Form (feedback form) operations.
 * Handles CRUD, listing, and statistics using JDBC + PreparedStatement.
 */
public class FormDAO {

    /**
     * Create a new feedback form.
     * Returns the generated form_id, or -1 on failure.
     */
    public int createForm(Form form) {
        String sql = "INSERT INTO forms (title, description, created_by, course_id, is_active) "
                   + "VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, form.getTitle());
            ps.setString(2, form.getDescription());
            ps.setInt(3, form.getCreatedBy());
            if (form.getCourseId() != null && form.getCourseId() > 0) {
                ps.setInt(4, form.getCourseId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setBoolean(5, form.isActive());
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return -1;
    }

    /**
     * Update an existing feedback form.
     */
    public boolean updateForm(Form form) {
        String sql = "UPDATE forms SET title = ?, description = ?, course_id = ?, is_active = ? "
                   + "WHERE form_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, form.getTitle());
            ps.setString(2, form.getDescription());
            if (form.getCourseId() != null && form.getCourseId() > 0) {
                ps.setInt(3, form.getCourseId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setBoolean(4, form.isActive());
            ps.setInt(5, form.getFormId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    /**
     * Delete a feedback form by ID.
     * Questions are deleted automatically via ON DELETE CASCADE.
     */
    public boolean deleteForm(int formId) {
        // First delete responses and answers (no cascade on responses)
        String deleteAnswers = "DELETE FROM answers WHERE response_id IN "
                             + "(SELECT response_id FROM responses WHERE form_id = ?)";
        String deleteResponses = "DELETE FROM responses WHERE form_id = ?";
        String deleteForm = "DELETE FROM forms WHERE form_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            ps = conn.prepareStatement(deleteAnswers);
            ps.setInt(1, formId);
            ps.executeUpdate();
            ps.close();

            ps = conn.prepareStatement(deleteResponses);
            ps.setInt(1, formId);
            ps.executeUpdate();
            ps.close();

            ps = conn.prepareStatement(deleteForm);
            ps.setInt(1, formId);
            ps.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    /**
     * Find a form by its ID, including question count and response count.
     */
    public Form findById(int formId) {
        String sql = "SELECT f.*, c.course_name, "
                   + "(SELECT COUNT(*) FROM questions WHERE form_id = f.form_id) AS question_count, "
                   + "(SELECT COUNT(*) FROM responses WHERE form_id = f.form_id) AS response_count "
                   + "FROM forms f LEFT JOIN courses c ON f.course_id = c.course_id "
                   + "WHERE f.form_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, formId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractForm(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return null;
    }

    /**
     * Get all forms (for admin listing).
     */
    public List<Form> findAll() {
        List<Form> forms = new ArrayList<Form>();
        String sql = "SELECT f.*, c.course_name, "
                   + "(SELECT COUNT(*) FROM questions WHERE form_id = f.form_id) AS question_count, "
                   + "(SELECT COUNT(*) FROM responses WHERE form_id = f.form_id) AS response_count "
                   + "FROM forms f LEFT JOIN courses c ON f.course_id = c.course_id "
                   + "ORDER BY f.created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                forms.add(extractForm(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return forms;
    }

    /**
     * Get active forms that a student has NOT yet submitted.
     * Only returns forms that have at least one question.
     */
    public List<Form> findActiveForStudent(int userId) {
        List<Form> forms = new ArrayList<Form>();
        String sql = "SELECT f.*, c.course_name, "
                   + "(SELECT COUNT(*) FROM questions WHERE form_id = f.form_id) AS question_count, "
                   + "0 AS response_count "
                   + "FROM forms f LEFT JOIN courses c ON f.course_id = c.course_id "
                   + "WHERE f.is_active = TRUE "
                   + "AND f.form_id NOT IN (SELECT form_id FROM responses WHERE user_id = ?) "
                   + "AND (SELECT COUNT(*) FROM questions WHERE form_id = f.form_id) > 0 "
                   + "ORDER BY f.created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                forms.add(extractForm(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return forms;
    }

    // ==================== Statistics Methods ====================

    public int getTotalForms() {
        return getCount("SELECT COUNT(*) FROM forms");
    }

    public int getActiveForms() {
        return getCount("SELECT COUNT(*) FROM forms WHERE is_active = TRUE");
    }

    public int getTotalResponses() {
        return getCount("SELECT COUNT(*) FROM responses");
    }

    public int getTotalStudents() {
        return getCount("SELECT COUNT(*) FROM users WHERE role_id = 2");
    }

    // ==================== Helper Methods ====================

    private int getCount(String sql) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return 0;
    }

    private Form extractForm(ResultSet rs) throws SQLException {
        Form form = new Form();
        form.setFormId(rs.getInt("form_id"));
        form.setTitle(rs.getString("title"));
        form.setDescription(rs.getString("description"));
        form.setCreatedBy(rs.getInt("created_by"));
        int courseId = rs.getInt("course_id");
        form.setCourseId(rs.wasNull() ? null : courseId);
        form.setCourseName(rs.getString("course_name"));
        form.setActive(rs.getBoolean("is_active"));
        form.setCreatedAt(rs.getTimestamp("created_at"));
        form.setQuestionCount(rs.getInt("question_count"));
        form.setResponseCount(rs.getInt("response_count"));
        return form;
    }
}
