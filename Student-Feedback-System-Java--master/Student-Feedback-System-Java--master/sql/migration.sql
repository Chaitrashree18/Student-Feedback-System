-- ============================================================
-- Student Feedback System - Database Migration Script
-- Run this ONCE against your existing database to add new features.
-- ============================================================

USE student_feedback_db;

-- 1. Add USN column to users table (if not already present)
ALTER TABLE users ADD COLUMN usn VARCHAR(20) UNIQUE DEFAULT NULL AFTER user_id;

-- 2. Update question_type ENUM to include FILE and DATE types
ALTER TABLE questions MODIFY COLUMN question_type ENUM('TEXT', 'RATING', 'MCQ', 'YESNO', 'FILE', 'DATE') NOT NULL;
