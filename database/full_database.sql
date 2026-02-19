-- =================================================================
-- URBAN COLLEGE PLATFORM - COMPLETE DATABASE WITH DATA IMPORT
-- Version: 2.0
-- Date: 2026-01-09
-- Description: Extended schema with student/employee data from CSV
-- =================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables (clean start)
DROP TABLE IF EXISTS `cafeteria_transactions`;
DROP TABLE IF EXISTS `cafeteria_assignments`;
DROP TABLE IF EXISTS `cafeteria_categories`;
DROP TABLE IF EXISTS `attendance_records`;
DROP TABLE IF EXISTS `grades`;
DROP TABLE IF EXISTS `instructor_subjects`;
DROP TABLE IF EXISTS `students`;
DROP TABLE IF EXISTS `groups`;
DROP TABLE IF EXISTS `subjects`;
DROP TABLE IF EXISTS `specialties`;
DROP TABLE IF EXISTS `users`;

-- ========================================
-- Таблица: specialties (Специальности)
-- ========================================
CREATE TABLE `specialties` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(50) NOT NULL UNIQUE COMMENT 'Код специальности (4S06120102)',
  `name_kz` VARCHAR(255) NOT NULL COMMENT 'Название на казахском',
  `name_ru` VARCHAR(255) NULL COMMENT 'Название на русском',
  `duration_months` TINYINT UNSIGNED NULL COMMENT 'Срок обучения в месяцах',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Таблица: users (Пользователи)
-- ========================================
CREATE TABLE `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `role` ENUM('student', 'instructor', 'admin', 'cafeteria_operator') NOT NULL DEFAULT 'student',
  `position` VARCHAR(255) NULL COMMENT 'Должность (для сотрудников)',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_email` (`email`),
  INDEX `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Таблица: subjects (Предметы/Дисциплины)
-- ========================================
CREATE TABLE `subjects` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `code` VARCHAR(50) NULL COMMENT 'Код предмета',
  `description` TEXT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Таблица: groups (Учебные группы)
-- ========================================
CREATE TABLE `groups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `course` TINYINT UNSIGNED NOT NULL COMMENT 'Курс обучения (1-4)',
  `curator_id` INT UNSIGNED NULL COMMENT 'Куратор группы (преподаватель)',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_course` (`course`),
  INDEX `idx_curator` (`curator_id`),
  FOREIGN KEY (`curator_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Таблица: students (Студенты)
-- ========================================
CREATE TABLE `students` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `student_code` VARCHAR(50) NOT NULL UNIQUE COMMENT 'Уникальный код студента',
  `group_id` INT UNSIGNED NULL,
  `specialty_id` INT UNSIGNED NULL COMMENT 'Специальность',
  `qr_token` VARCHAR(255) NOT NULL UNIQUE COMMENT 'Уникальный QR токен',
  
  -- Паспортные данные
  `iin` VARCHAR(12) NULL UNIQUE COMMENT 'ИИН (Индивидуальный идентификационный номер)',
  `gender` ENUM('male', 'female') NULL COMMENT 'Пол',
  `date_of_birth` DATE NULL COMMENT 'Дата рождения',
  `nationality` VARCHAR(50) NULL COMMENT 'Национальность',
  `citizenship` VARCHAR(50) NULL COMMENT 'Гражданство',
  
  -- Контактные данные  
  `phone` VARCHAR(20) NULL COMMENT 'Телефон',
  `address` TEXT NULL COMMENT 'Адрес проживания',
  `region` VARCHAR(100) NULL COMMENT 'Область',
  `district` VARCHAR(100) NULL COMMENT 'Район',
  `city` VARCHAR(100) NULL COMMENT 'Город',
  
  -- Образовательные данные
  `education_level` VARCHAR(100) NULL COMMENT 'Уровень образования до поступления',
  `funding_type` ENUM('budget', 'paid') NULL DEFAULT 'budget' COMMENT 'Тип финансирования',
  `education_language` ENUM('kazakh', 'russian') NULL DEFAULT 'russian' COMMENT 'Язык обучения',
  `education_form` VARCHAR(50) NULL COMMENT 'Форма обучения (дневная/заочная)',
  
  -- Административные данные
  `enrollment_date` DATE NULL COMMENT 'Дата поступления',
  `enrollment_order` VARCHAR(50) NULL COMMENT 'Номер приказа о зачислении',
  `academic_leave` BOOLEAN DEFAULT FALSE COMMENT 'Академический отпуск',
  `dual_education` BOOLEAN DEFAULT FALSE COMMENT 'Дуальное обучение',
  
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`group_id`) REFERENCES `groups`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`specialty_id`) REFERENCES `specialties`(`id`) ON DELETE SET NULL,
  INDEX `idx_student_code` (`student_code`),
  INDEX `idx_qr_token` (`qr_token`),
  INDEX `idx_iin` (`iin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Таблица: instructor_subjects (Предметы преподавателя)
-- ========================================
CREATE TABLE `instructor_subjects` (
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
-- Таблица: grades (Оценки)
-- ========================================
CREATE TABLE `grades` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` INT UNSIGNED NOT NULL,
  `subject_id` INT UNSIGNED NOT NULL,
  `instructor_id` INT UNSIGNED NOT NULL,
  `grade_value` TINYINT UNSIGNED NOT NULL COMMENT 'Оценка (2-5)',
  `grade_type` ENUM('exam','quiz','homework','attendance','midterm','final','classwork') DEFAULT 'exam',
  `date` DATE NOT NULL,
  `notes` TEXT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`instructor_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  INDEX `idx_student_subject` (`student_id`, `subject_id`),
  INDEX `idx_date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Таблица: cafeteria_categories
-- ========================================
CREATE TABLE `cafeteria_categories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `daily_limit` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `weekly_limit` TINYINT UNSIGNED NOT NULL DEFAULT 5,
  `monthly_limit` TINYINT UNSIGNED NOT NULL DEFAULT 20,
  `price_per_portion` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `created_by` INT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE RESTRICT,
  INDEX `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Таблица: cafeteria_assignments
-- ========================================
CREATE TABLE `cafeteria_assignments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` INT UNSIGNED NOT NULL,
  `category_id` INT UNSIGNED NOT NULL,
  `assigned_by` INT UNSIGNED NOT NULL,
  `assigned_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_assignment` (`student_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`category_id`) REFERENCES `cafeteria_categories`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`assigned_by`) REFERENCES `users`(`id`) ON DELETE RESTRICT,
  INDEX `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Таблица: cafeteria_transactions
-- ========================================
CREATE TABLE `cafeteria_transactions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` INT UNSIGNED NOT NULL,
  `category_id` INT UNSIGNED NOT NULL,
  `operator_id` INT UNSIGNED NOT NULL,
  `qr_identifier` VARCHAR(255) NOT NULL,
  `served_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`category_id`) REFERENCES `cafeteria_categories`(`id`) ON DELETE RESTRICT,
  FOREIGN KEY (`operator_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT,
  INDEX `idx_student_served` (`student_id`, `served_at`),
  INDEX `idx_served_date` (`served_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- Таблица: attendance_records
-- ========================================
CREATE TABLE `attendance_records` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` INT UNSIGNED NOT NULL,
  `marked_by` INT UNSIGNED NOT NULL,
  `marked_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('present', 'absent', 'late') DEFAULT 'present',
  `notes` TEXT,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`marked_by`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  INDEX `idx_student_date` (`student_id`, `marked_at`),
  INDEX `idx_date` (`marked_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- =================================================================
-- DATA IMPORT SECTION - Will be in separate files
-- =================================================================
-- See: import_specialties.sql, import_employees.sql, import_students.sql
