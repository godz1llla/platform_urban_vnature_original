-- DATABASE MIGRATION: Instructor Subjects & Group Curator
-- Date: 2026-01-09
-- Description: Adds support for instructors to have multiple subjects and optionally be group curators

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ========================================
-- Create instructor_subjects table (many-to-many)
-- ========================================
CREATE TABLE IF NOT EXISTS `instructor_subjects` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `instructor_id` INT UNSIGNED NOT NULL COMMENT 'ID преподавателя (users.id)',
  `subject_id` INT UNSIGNED NOT NULL COMMENT 'ID предмета (subjects.id)',
  `assigned_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_instructor_subject` (`instructor_id`, `subject_id`),
  FOREIGN KEY (`instructor_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`id`) ON DELETE CASCADE,
  INDEX `idx_instructor` (`instructor_id`),
  INDEX `idx_subject` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Add curator_id column to groups table
-- ========================================
ALTER TABLE `groups` 
ADD COLUMN IF NOT EXISTS `curator_id` INT UNSIGNED NULL COMMENT 'Куратор группы (преподаватель)' AFTER `course`,
ADD CONSTRAINT `fk_groups_curator` 
  FOREIGN KEY (`curator_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
ADD INDEX `idx_curator` (`curator_id`);

SET FOREIGN_KEY_CHECKS = 1;

-- ========================================
-- Verification queries
-- ========================================
-- Check that instructor_subjects table was created
SHOW CREATE TABLE instructor_subjects;

-- Check that groups table has curator_id
SHOW CREATE TABLE `groups`;
