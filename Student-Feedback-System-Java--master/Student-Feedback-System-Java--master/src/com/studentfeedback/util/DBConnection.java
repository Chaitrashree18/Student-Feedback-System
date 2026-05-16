package com.studentfeedback.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility.
 * Provides a method to get a JDBC connection to MySQL.
 * 
 * IMPORTANT: Update the URL, USER, and PASSWORD constants
 * to match your MySQL configuration before deploying.
 */
public class DBConnection {

    // ========== CONFIGURE THESE VALUES ==========
    private static final String URL = "jdbc:mysql://localhost:3306/student_feedback_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "akshay@123";   // Set your MySQL root password here
    // =============================================

    // Load MySQL JDBC Driver once when class is loaded
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    /**
     * Returns a new database connection.
     * Caller is responsible for closing the connection.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
