package com.studentfeedback.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.studentfeedback.model.Answer;
import com.studentfeedback.model.Response;
import com.studentfeedback.util.DBConnection;

/**
 * Data Access Object for Response and Answer operations.
 * Handles submission (with transaction), listing, and analytics.
 */
public class ResponseDAO {

    /**
     * Submit a complete feedback response with all answers.
     * Uses a transaction to ensure atomicity.
     */
    public boolean submitResponse(Response response) {
        Connection conn = null;
        PreparedStatement ps = null;
        PreparedStatement answerPs = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Insert response record
            String sql = "INSERT INTO responses (form_id, user_id) VALUES (?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, response.getFormId());
            ps.setInt(2, response.getUserId());
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (!rs.next()) {
                throw new SQLException("Failed to get generated response ID");
            }
            int responseId = rs.getInt(1);

            // Insert all answers
            String answerSql = "INSERT INTO answers (response_id, question_id, answer_text) VALUES (?, ?, ?)";
            answerPs = conn.prepareStatement(answerSql);
            for (Answer answer : response.getAnswers()) {
                answerPs.setInt(1, responseId);
                answerPs.setInt(2, answer.getQuestionId());
                answerPs.setString(3, answer.getAnswerText());
                answerPs.addBatch();
            }
            answerPs.executeBatch();

            conn.commit();
            return true;

        } catch (SQLException e) {
            // Rollback on failure
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (answerPs != null) answerPs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    /**
     * Check if a student has already submitted a specific form.
     */
    public boolean hasSubmitted(int formId, int userId) {
        String sql = "SELECT COUNT(*) FROM responses WHERE form_id = ? AND user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, formId);
            ps.setInt(2, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    /**
     * Get all responses for a specific form (for admin analytics).
     */
    public List<Response> findByFormId(int formId) {
        List<Response> responses = new ArrayList<Response>();
        String sql = "SELECT r.*, u.full_name AS student_name, u.usn "
                   + "FROM responses r JOIN users u ON r.user_id = u.user_id "
                   + "WHERE r.form_id = ? ORDER BY r.submitted_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, formId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Response resp = new Response();
                resp.setResponseId(rs.getInt("response_id"));
                resp.setFormId(rs.getInt("form_id"));
                resp.setUserId(rs.getInt("user_id"));
                resp.setStudentName(rs.getString("student_name"));
                resp.setUsn(rs.getString("usn"));
                resp.setSubmittedAt(rs.getTimestamp("submitted_at"));
                responses.add(resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return responses;
    }

    /**
     * Get all responses by a specific student (for submission history).
     */
    public List<Response> findByUserId(int userId) {
        List<Response> responses = new ArrayList<Response>();
        String sql = "SELECT r.*, f.title AS form_title "
                   + "FROM responses r JOIN forms f ON r.form_id = f.form_id "
                   + "WHERE r.user_id = ? ORDER BY r.submitted_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Response resp = new Response();
                resp.setResponseId(rs.getInt("response_id"));
                resp.setFormId(rs.getInt("form_id"));
                resp.setUserId(rs.getInt("user_id"));
                resp.setFormTitle(rs.getString("form_title"));
                resp.setSubmittedAt(rs.getTimestamp("submitted_at"));
                responses.add(resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return responses;
    }

    /**
     * Get all answers for a specific response (detailed view).
     */
    public List<Answer> getAnswersByResponseId(int responseId) {
        List<Answer> answers = new ArrayList<Answer>();
        String sql = "SELECT a.*, q.question_text, q.question_type "
                   + "FROM answers a JOIN questions q ON a.question_id = q.question_id "
                   + "WHERE a.response_id = ? ORDER BY q.question_order";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, responseId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Answer ans = new Answer();
                ans.setAnswerId(rs.getInt("answer_id"));
                ans.setResponseId(rs.getInt("response_id"));
                ans.setQuestionId(rs.getInt("question_id"));
                ans.setAnswerText(rs.getString("answer_text"));
                ans.setQuestionText(rs.getString("question_text"));
                ans.setQuestionType(rs.getString("question_type"));
                answers.add(ans);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return answers;
    }

    /**
     * Get average ratings for all RATING-type questions in a form.
     * Returns a map of question_text -> average_rating.
     */
    public Map<String, Double> getAverageRatings(int formId) {
        Map<String, Double> ratings = new LinkedHashMap<String, Double>();
        String sql = "SELECT q.question_text, AVG(CAST(a.answer_text AS DECIMAL(3,2))) AS avg_rating "
                   + "FROM answers a "
                   + "JOIN questions q ON a.question_id = q.question_id "
                   + "JOIN responses r ON a.response_id = r.response_id "
                   + "WHERE r.form_id = ? AND q.question_type = 'RATING' "
                   + "GROUP BY q.question_id, q.question_text "
                   + "ORDER BY q.question_order";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, formId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ratings.put(rs.getString("question_text"), rs.getDouble("avg_rating"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return ratings;
    }
}
