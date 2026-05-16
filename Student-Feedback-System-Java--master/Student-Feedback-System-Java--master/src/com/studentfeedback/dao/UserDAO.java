package com.studentfeedback.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.studentfeedback.model.User;
import com.studentfeedback.util.DBConnection;

/**
 * Data Access Object for User operations.
 * Handles login, registration, and user lookup using JDBC + PreparedStatement.
 */
public class UserDAO {

    /**
     * Authenticate a user by username and password.
     * Returns the User object if credentials are valid, null otherwise.
     */
    public User login(String username, String password) {
        String sql = "SELECT u.*, r.role_name FROM users u "
                   + "JOIN roles r ON u.role_id = r.role_id "
                   + "WHERE u.username = ? AND u.password = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return null;
    }

    /**
     * Register a new student user.
     * Returns true if registration is successful.
     */
    public boolean register(User user) {
        String sql = "INSERT INTO users (usn, username, password, full_name, email, role_id) "
                   + "VALUES (?, ?, ?, ?, ?, 2)";  // role_id 2 = STUDENT
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsn());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getEmail());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }
        return false;
    }

    /**
     * Check if a username is already taken.
     */
    public boolean isUsernameTaken(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return false;
    }

    /**
     * Check if an email is already registered.
     */
    public boolean isEmailTaken(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return false;
    }

    /**
     * Extract a User object from a ResultSet row.
     */
    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsn(rs.getString("usn"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setRoleId(rs.getInt("role_id"));
        user.setRoleName(rs.getString("role_name"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }

    /**
     * Close JDBC resources safely.
     */
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}
