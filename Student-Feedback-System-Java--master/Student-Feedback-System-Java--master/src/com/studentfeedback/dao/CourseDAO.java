package com.studentfeedback.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.studentfeedback.model.Course;
import com.studentfeedback.util.DBConnection;

/**
 * Data Access Object for Course operations.
 */
public class CourseDAO {

    /**
     * Get all courses ordered by name.
     */
    public List<Course> findAll() {
        List<Course> courses = new ArrayList<Course>();
        String sql = "SELECT * FROM courses ORDER BY course_name";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setCourseCode(rs.getString("course_code"));
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return courses;
    }
}
