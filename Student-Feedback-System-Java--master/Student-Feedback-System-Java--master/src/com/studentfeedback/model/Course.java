package com.studentfeedback.model;

/**
 * Course POJO - represents a course.
 */
public class Course {

    private int courseId;
    private String courseName;
    private String courseCode;

    public Course() {}

    // Getters and Setters

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }
}
