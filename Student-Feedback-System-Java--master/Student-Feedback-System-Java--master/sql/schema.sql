-- ============================================================
-- Student Feedback System - Database Schema
-- MySQL Script
-- ============================================================

CREATE DATABASE IF NOT EXISTS student_feedback_db;
USE student_feedback_db;

-- Drop tables if they exist (for clean re-creation)
DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS responses;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS forms;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

-- ============================================================
-- Table: roles
-- ============================================================
CREATE TABLE roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ============================================================
-- Table: users
-- ============================================================
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    usn VARCHAR(20) UNIQUE DEFAULT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
) ENGINE=InnoDB;

-- ============================================================
-- Table: courses
-- ============================================================
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ============================================================
-- Table: forms
-- ============================================================
CREATE TABLE forms (
    form_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    created_by INT NOT NULL,
    course_id INT DEFAULT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
) ENGINE=InnoDB;

-- ============================================================
-- Table: questions
-- ============================================================
CREATE TABLE questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    form_id INT NOT NULL,
    question_text VARCHAR(500) NOT NULL,
    question_type ENUM('TEXT', 'RATING', 'MCQ', 'YESNO', 'FILE', 'DATE') NOT NULL,
    options VARCHAR(1000) DEFAULT NULL,
    question_order INT NOT NULL DEFAULT 1,
    FOREIGN KEY (form_id) REFERENCES forms(form_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- Table: responses
-- ============================================================
CREATE TABLE responses (
    response_id INT PRIMARY KEY AUTO_INCREMENT,
    form_id INT NOT NULL,
    user_id INT NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (form_id) REFERENCES forms(form_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    UNIQUE KEY unique_response (form_id, user_id)
) ENGINE=InnoDB;

-- ============================================================
-- Table: answers
-- ============================================================
CREATE TABLE answers (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    response_id INT NOT NULL,
    question_id INT NOT NULL,
    answer_text TEXT NOT NULL,
    FOREIGN KEY (response_id) REFERENCES responses(response_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(question_id)
) ENGINE=InnoDB;

-- ============================================================
-- Seed Data
-- ============================================================

-- Roles
INSERT INTO roles (role_name) VALUES ('ADMIN'), ('STUDENT');

-- Default Admin User (username: admin, password: admin123)
INSERT INTO users (username, password, full_name, email, role_id)
VALUES ('admin', 'admin123', 'System Administrator', 'admin@feedback.com', 1);

-- Sample Courses
INSERT INTO courses (course_name, course_code) VALUES
    ('Data Structures and Algorithms', 'CS201'),
    ('Database Management Systems', 'CS301'),
    ('Web Technologies', 'CS401');

-- ============================================================
-- End of Schema
-- ============================================================
