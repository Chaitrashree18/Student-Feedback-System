package com.studentfeedback.model;

import java.sql.Timestamp;

/**
 * Form POJO - represents a feedback form created by an admin.
 */
public class Form {

    private int formId;
    private String title;
    private String description;
    private int createdBy;
    private Integer courseId;       // null means assigned to all students
    private String courseName;      // joined from courses table
    private boolean active;
    private Timestamp createdAt;
    private int questionCount;      // computed field
    private int responseCount;      // computed field

    public Form() {}

    // Getters and Setters

    public int getFormId() {
        return formId;
    }

    public void setFormId(int formId) {
        this.formId = formId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getQuestionCount() {
        return questionCount;
    }

    public void setQuestionCount(int questionCount) {
        this.questionCount = questionCount;
    }

    public int getResponseCount() {
        return responseCount;
    }

    public void setResponseCount(int responseCount) {
        this.responseCount = responseCount;
    }
}
