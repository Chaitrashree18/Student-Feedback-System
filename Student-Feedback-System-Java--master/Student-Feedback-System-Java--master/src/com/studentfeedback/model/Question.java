package com.studentfeedback.model;

/**
 * Question POJO - represents a question in a feedback form.
 * Supported types: TEXT, RATING (1-5), MCQ (multiple choice), YESNO
 */
public class Question {

    private int questionId;
    private int formId;
    private String questionText;
    private String questionType;    // TEXT, RATING, MCQ, YESNO
    private String options;         // comma-separated options for MCQ type
    private int questionOrder;

    public Question() {}

    // Getters and Setters

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public int getFormId() {
        return formId;
    }

    public void setFormId(int formId) {
        this.formId = formId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public String getOptions() {
        return options;
    }

    public void setOptions(String options) {
        this.options = options;
    }

    public int getQuestionOrder() {
        return questionOrder;
    }

    public void setQuestionOrder(int questionOrder) {
        this.questionOrder = questionOrder;
    }
}
