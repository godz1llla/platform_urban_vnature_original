-- =================================================================
-- URBAN COLLEGE PLATFORM - COMPLETE DATABASE WITH SCHEDULE
-- Version: 2.1.0
-- Date: 2026-01-25
-- Description: Full database setup with ALL data including schedule
-- =================================================================
-- 
-- ЧТО ВКЛЮЧЕНО:
-- ✅ Схема БД (таблицы users, students, groups, subjects, schedule и др.)
-- ✅ 7 специальностей
-- ✅ 45 групп
-- ✅ 31 сотрудник
-- ✅ 681 студент
-- ✅ 102 записи расписания
-- =================================================================

-- Запуск одной командой:
-- mysql -u root -p urban_college < database/complete_with_schedule.sql
-- =================================================================

-- 1. СХЕМА БД
SOURCE full_database.sql;

-- 2. ТАБЛИЦА РАСПИСАНИЯ (если её нет в full_database.sql)
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

-- 3. ИМПОРТ ДАННЫХ
SOURCE import_specialties.sql;
SOURCE import_groups.sql;
SOURCE import_employees.sql;
SOURCE import_students.sql;

-- 4. ИМПОРТ РАСПИСАНИЯ
SOURCE import_schedule_full.sql;

-- =================================================================
-- VERIFICATION - Проверка
-- =================================================================
SELECT '✅ База данных создана успешно!' AS status;
SELECT 
    (SELECT COUNT(*) FROM users) AS 'Пользователей',
    (SELECT COUNT(*) FROM students) AS 'Студентов', 
    (SELECT COUNT(*) FROM `groups`) AS 'Групп',
    (SELECT COUNT(*) FROM specialties) AS 'Специальностей',
    (SELECT COUNT(*) FROM schedule) AS 'Записей расписания';

SELECT '🎉 Готово! Все данные импортированы.' AS result;
