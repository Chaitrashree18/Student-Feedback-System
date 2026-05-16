package com.studentfeedback.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.studentfeedback.model.Question;
import com.studentfeedback.util.DBConnection;

/**
 * Data Access Object for Question operations.
 * Handles adding, deleting, and listing questions for a form.
 */
public class QuestionDAO {

    /**
     * Add a question to a form.
     */
    public boolean addQuestion(Question question) {
        String sql = "INSERT INTO questions (form_id, question_text, question_type, options, question_order) "
                   + "VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, question.getFormId());
            ps.setString(2, question.getQuestionText());
            ps.setString(3, question.getQuestionType());
            ps.setString(4, question.getOptions());
            ps.setInt(5, question.getQuestionOrder());
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
     * Delete a question by ID.
     */
    public boolean deleteQuestion(int questionId) {
        String sql = "DELETE FROM questions WHERE question_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, questionId);
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
     * Get all questions for a specific form, ordered by question_order.
     */
    public List<Question> findByFormId(int formId) {
        List<Question> questions = new ArrayList<Question>();
        String sql = "SELECT * FROM questions WHERE form_id = ? ORDER BY question_order";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, formId);
            rs = ps.executeQuery();
            while (rs.next()) {
                questions.add(extractQuestion(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return questions;
    }

    /**
     * Get the next question order number for a form.
     */
    public int getNextOrder(int formId) {
        String sql = "SELECT COALESCE(MAX(question_order), 0) + 1 FROM questions WHERE form_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, formId);
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
        return 1;
    }

    /**
     * Extract a Question object from a ResultSet row.
     */
    private Question extractQuestion(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setQuestionId(rs.getInt("question_id"));
        q.setFormId(rs.getInt("form_id"));
        q.setQuestionText(rs.getString("question_text"));
        q.setQuestionType(rs.getString("question_type"));
        q.setOptions(rs.getString("options"));
        q.setQuestionOrder(rs.getInt("question_order"));
        return q;
    }
}
