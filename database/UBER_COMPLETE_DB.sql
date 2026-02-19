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
-- ============================================================================
-- МИГРАЦИЯ v2.1: Модуль Расписания
-- Дата: 25.01.2026
-- Описание: Создание таблицы расписания с поддержкой номера пары
-- ============================================================================

-- Создаем таблицу schedule (если её нет)
CREATE TABLE IF NOT EXISTS schedule (
    id INT PRIMARY KEY AUTO_INCREMENT,
    group_id INT NOT NULL,
    subject_id INT NOT NULL,
    instructor_id INT NOT NULL,
    audience VARCHAR(50) DEFAULT NULL COMMENT 'Номер аудитории',
    day_of_week ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday') NOT NULL,
    pair_number INT NOT NULL DEFAULT 1 COMMENT 'Номер пары (1-4)',
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (group_id) REFERENCES `groups`(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES users(id) ON DELETE CASCADE,
    
    INDEX idx_schedule_day_pair (day_of_week, pair_number),
    INDEX idx_schedule_group (group_id, day_of_week),
    INDEX idx_schedule_instructor (instructor_id, day_of_week)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Расписание занятий';

-- Если таблица уже существует БЕЗ поля pair_number, добавляем его
-- Используем процедурный подход с проверкой
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'schedule' 
    AND COLUMN_NAME = 'pair_number'
);

SET @add_column_sql = IF(
    @column_exists = 0,
    'ALTER TABLE schedule ADD COLUMN pair_number INT NOT NULL DEFAULT 1 COMMENT "Номер пары (1-4)" AFTER day_of_week',
    'SELECT "Column pair_number already exists" AS info'
);

PREPARE stmt FROM @add_column_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Создаем индексы если их нет
CREATE INDEX IF NOT EXISTS idx_schedule_day_pair ON schedule(day_of_week, pair_number);
CREATE INDEX IF NOT EXISTS idx_schedule_group ON schedule(group_id, day_of_week);
CREATE INDEX IF NOT EXISTS idx_schedule_instructor ON schedule(instructor_id, day_of_week);

-- Готово!
SELECT 'Migration v2.1 completed successfully!' AS status;
-- ============================================================================
-- ПОЛНЫЙ ИМПОРТ РАСПИСАНИЯ
-- Сгенерировано: 2026-01-25 01:17:08
-- Записей: 102
-- ============================================================================

-- Очистка существующих данных расписания
TRUNCATE TABLE schedule;

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Кураторлық сағат%' OR name_kz LIKE '%Кураторлық сағат%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Садувакас%' AND role = 'instructor' LIMIT 1),
    '№201',
    'monday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Математика%' OR name_kz LIKE '%Математика%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Мусалаева%' AND role = 'instructor' LIMIT 1),
    '№204',
    'friday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Биология%' OR name_kz LIKE '%Биология%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Жұмаканов%' AND role = 'instructor' LIMIT 1),
    '№302',
    'friday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%География%' OR name_kz LIKE '%География%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Төребаева%' AND role = 'instructor' LIMIT 1),
    '№209',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Математика Дүниежүзі тарихы%' OR name_kz LIKE '%Математика Дүниежүзі тарихы%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Төребаева%' AND role = 'instructor' LIMIT 1),
    '№304',
    'tuesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Информатика%' OR name_kz LIKE '%Информатика%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Амангельдиев%' AND role = 'instructor' LIMIT 1),
    '№326',
    'friday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%География Ағылшын тілі%' OR name_kz LIKE '%География Ағылшын тілі%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Садувакас%' AND role = 'instructor' LIMIT 1),
    '№201',
    'friday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Қазақ тілі%' OR name_kz LIKE '%Қазақ тілі%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Жарманов%' AND role = 'instructor' LIMIT 1),
    '№301',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Дүниежүзі тарихы%' OR name_kz LIKE '%Дүниежүзі тарихы%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Раймбаева%' AND role = 'instructor' LIMIT 1),
    '№205',
    'wednesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Алғашқы әскери және технологиялық дайындық%' OR name_kz LIKE '%Алғашқы әскери және технологиялық дайындық%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Мусалаева%' AND role = 'instructor' LIMIT 1),
    '№204',
    'friday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Қазақ әдебиеті%' OR name_kz LIKE '%Қазақ әдебиеті%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Хамитова%' AND role = 'instructor' LIMIT 1),
    '№301',
    'friday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Дене тәрбиесі%' OR name_kz LIKE '%Дене тәрбиесі%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байдильдина%' AND role = 'instructor' LIMIT 1),
    '№209',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Химия%' OR name_kz LIKE '%Химия%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Садувакас%' AND role = 'instructor' LIMIT 1),
    '№201',
    'thursday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Графика және жобалау%' OR name_kz LIKE '%Графика және жобалау%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Махин%' AND role = 'instructor' LIMIT 1),
    '№310',
    'friday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Дене тәрбиесі%' OR name_kz LIKE '%Дене тәрбиесі%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Жұмаканов%' AND role = 'instructor' LIMIT 1),
    '№302',
    'friday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Русская литература%' OR name_kz LIKE '%Русская литература%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байдильдина%' AND role = 'instructor' LIMIT 1),
    '№303',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Қазақ тілі Қазақ әдебиеті%' OR name_kz LIKE '%Қазақ тілі Қазақ әдебиеті%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Амангельдиев%' AND role = 'instructor' LIMIT 1),
    '№326',
    'friday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Физика%' OR name_kz LIKE '%Физика%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байдильдина%' AND role = 'instructor' LIMIT 1),
    '№303',
    'friday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Ағылшын тілі%' OR name_kz LIKE '%Ағылшын тілі%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Жарманов%' AND role = 'instructor' LIMIT 1),
    '№204',
    'friday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'иИС-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Физическая культура%' OR name_kz LIKE '%Физическая культура%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Төребаева%' AND role = 'instructor' LIMIT 1),
    '№209',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Русский язык%' OR name_kz LIKE '%Русский язык%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Мусалаева%' AND role = 'instructor' LIMIT 1),
    '№102',
    'monday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ООМ 2%' OR name_kz LIKE '%ООМ 2%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Орынбасар%' AND role = 'instructor' LIMIT 1),
    '№219',
    'monday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ООМ 1%' OR name_kz LIKE '%ООМ 1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Махин%' AND role = 'instructor' LIMIT 1),
    '№102',
    'monday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Физическая культура%' OR name_kz LIKE '%Физическая культура%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Махин%' AND role = 'instructor' LIMIT 1),
    '№102',
    'monday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%География%' OR name_kz LIKE '%География%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Жұмаканов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'tuesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Математика%' OR name_kz LIKE '%Математика%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Амангельдиев%' AND role = 'instructor' LIMIT 1),
    '№102',
    'tuesday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Физическая культура%' OR name_kz LIKE '%Физическая культура%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Махин%' AND role = 'instructor' LIMIT 1),
    '№102',
    'tuesday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Русская литература%' OR name_kz LIKE '%Русская литература%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Мусалаева%' AND role = 'instructor' LIMIT 1),
    '№102',
    'wednesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%БМ 1%' OR name_kz LIKE '%БМ 1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'wednesday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%БМ 1%' OR name_kz LIKE '%БМ 1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'wednesday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%БМ 1%' OR name_kz LIKE '%БМ 1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'wednesday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%БМ 2%' OR name_kz LIKE '%БМ 2%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'thursday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%БМ 2%' OR name_kz LIKE '%БМ 2%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'thursday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%БМ 2%' OR name_kz LIKE '%БМ 2%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'thursday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Кураторский час%' OR name_kz LIKE '%Кураторский час%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Қасымова%' AND role = 'instructor' LIMIT 1),
    '№102',
    'thursday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%БМ 1%' OR name_kz LIKE '%БМ 1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'friday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%БМ 1%' OR name_kz LIKE '%БМ 1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'friday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%БМ 1%' OR name_kz LIKE '%БМ 1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'friday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГБР-250' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%БМ 1%' OR name_kz LIKE '%БМ 1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№102',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' OR name_kz LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Шадаев%' AND role = 'instructor' LIMIT 1),
    '№212',
    'monday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-4%' OR name_kz LIKE '%ЖММ-4%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Сатубалдина%' AND role = 'instructor' LIMIT 1),
    '№212',
    'monday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-3%' OR name_kz LIKE '%ЖММ-3%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байдильдина%' AND role = 'instructor' LIMIT 1),
    '№303',
    'monday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-3 Администрирование процесса установки сетевых устройств инфокоммуникационных систем%' OR name_kz LIKE '%ПМ-3 Администрирование процесса установки сетевых устройств инфокоммуникационных систем%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'monday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ООМ-1%' OR name_kz LIKE '%ООМ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'monday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' OR name_kz LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Шадаев%' AND role = 'instructor' LIMIT 1),
    '№212',
    'tuesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-1%' OR name_kz LIKE '%ЖММ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Шадаев%' AND role = 'instructor' LIMIT 1),
    '№212',
    'tuesday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-3%' OR name_kz LIKE '%ЖММ-3%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'tuesday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-3 Администрирование процесса установки сетевых устройств инфокоммуникационных систем%' OR name_kz LIKE '%ПМ-3 Администрирование процесса установки сетевых устройств инфокоммуникационных систем%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'tuesday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ-4 Желілік құрылғылар мен бағдарламалық жасақтаманы конфигурациялау процесін басқару%' OR name_kz LIKE '%КМ-4 Желілік құрылғылар мен бағдарламалық жасақтаманы конфигурациялау процесін басқару%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Жарманов%' AND role = 'instructor' LIMIT 1),
    '№214',
    'tuesday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%№ 202%' OR name_kz LIKE '%№ 202%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    'Не указано',
    'tuesday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' OR name_kz LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Сатубалдина%' AND role = 'instructor' LIMIT 1),
    '№212',
    'wednesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-4%' OR name_kz LIKE '%ЖММ-4%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Шадаев%' AND role = 'instructor' LIMIT 1),
    '№212',
    'wednesday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ООМ-1%' OR name_kz LIKE '%ООМ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'wednesday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Английский язык%' OR name_kz LIKE '%Английский язык%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'wednesday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-4 Администрирование процесса конфигурирования сетевых устройств и программного обеспечения%' OR name_kz LIKE '%ПМ-4 Администрирование процесса конфигурирования сетевых устройств и программного обеспечения%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'wednesday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ-4 Тестілеу%' OR name_kz LIKE '%КМ-4 Тестілеу%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Сатубалдина%' AND role = 'instructor' LIMIT 1),
    '№212',
    'thursday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ-4 Тестілеу%' OR name_kz LIKE '%КМ-4 Тестілеу%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Сатубалдина%' AND role = 'instructor' LIMIT 1),
    '№212',
    'thursday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%№ 202%' OR name_kz LIKE '%№ 202%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'thursday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Английский язык%' OR name_kz LIKE '%Английский язык%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'thursday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ-5 Ұйымның серверлік жабдықтарын жинақтау, монтаждау, баптау және қызмет көрсету%' OR name_kz LIKE '%КМ-5 Ұйымның серверлік жабдықтарын жинақтау, монтаждау, баптау және қызмет көрсету%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'thursday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ-4 Тестілеу%' OR name_kz LIKE '%КМ-4 Тестілеу%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Есимханов%' AND role = 'instructor' LIMIT 1),
    '№212',
    'friday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ-4 Тестілеу%' OR name_kz LIKE '%КМ-4 Тестілеу%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Жарманов%' AND role = 'instructor' LIMIT 1),
    '№316',
    'friday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%№ 202%' OR name_kz LIKE '%№ 202%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Сатубалдина%' AND role = 'instructor' LIMIT 1),
    '№316',
    'friday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%№ 202%' OR name_kz LIKE '%№ 202%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Жарманов%' AND role = 'instructor' LIMIT 1),
    '№214',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SЭЛ-240' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ-4 Желілік құрылғылар мен бағдарламалық жасақтаманы конфигурациялау процесін басқару%' OR name_kz LIKE '%КМ-4 Желілік құрылғылар мен бағдарламалық жасақтаманы конфигурациялау процесін басқару%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Шадаев%' AND role = 'instructor' LIMIT 1),
    '№214',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name_kz LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'monday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ООМ-1%' OR name_kz LIKE '%ООМ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'monday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ -7 Настройка и ослуживание серверного оборудования организации%' OR name_kz LIKE '%ПМ -7 Настройка и ослуживание серверного оборудования организации%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'monday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-1%' OR name_kz LIKE '%ЖММ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№202',
    'monday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-1%' OR name_kz LIKE '%ЖММ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Не%' AND role = 'instructor' LIMIT 1),
    'Не указано',
    'monday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name_kz LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'tuesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name_kz LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'tuesday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-1%' OR name_kz LIKE '%ЖММ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'tuesday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Английский язык%' OR name_kz LIKE '%Английский язык%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'wednesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name_kz LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'wednesday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Ағылшын тілі%' OR name_kz LIKE '%Ағылшын тілі%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'wednesday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%КМ 4 Желдететін техникаға жоспарлы техникалық қызмет көрсетту жұмыстарын орындау%' OR name_kz LIKE '%КМ 4 Желдететін техникаға жоспарлы техникалық қызмет көрсетту жұмыстарын орындау%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'wednesday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name_kz LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'thursday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name_kz LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'thursday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ -7 Настройка и ослуживание серверного оборудования организации%' OR name_kz LIKE '%ПМ -7 Настройка и ослуживание серверного оборудования организации%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'thursday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-1%' OR name_kz LIKE '%ЖММ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Не%' AND role = 'instructor' LIMIT 1),
    'Не указано',
    'thursday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Ағылшын тілі%' OR name_kz LIKE '%Ағылшын тілі%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'friday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%Английский язык%' OR name_kz LIKE '%Английский язык%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'friday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ООМ-1%' OR name_kz LIKE '%ООМ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'friday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-1%' OR name_kz LIKE '%ЖММ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Абильмажинов%' AND role = 'instructor' LIMIT 1),
    '№312',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name_kz LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'monday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name_kz LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'monday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name_kz LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'tuesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name_kz LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'tuesday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ООМ-1%' OR name_kz LIKE '%ООМ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'tuesday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ООМ-1%' OR name_kz LIKE '%ООМ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'tuesday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-4%' OR name_kz LIKE '%ЖММ-4%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Не%' AND role = 'instructor' LIMIT 1),
    'Не указано',
    'tuesday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name_kz LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'wednesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name_kz LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'wednesday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ЖММ-1%' OR name_kz LIKE '%ЖММ-1%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Не%' AND role = 'instructor' LIMIT 1),
    'Не указано',
    'wednesday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name_kz LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'thursday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name_kz LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'thursday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name_kz LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'friday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name_kz LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'friday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name_kz LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Байболатов%' AND role = 'instructor' LIMIT 1),
    '№213',
    'friday',
    3,
    '12:20:00',
    '13:40:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name_kz LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№312',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'SТС-230' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name_kz LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);
