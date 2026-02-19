-- ============================================================================
-- МИГРАЦИЯ v2.1: Модуль Расписания
-- Дата: 25.01.2026
-- Описание: Создание таблицы расписания с поддержкой номера пары
-- ============================================================================

-- Создаем таблицу schedule (если её нет)
CREATE TABLE IF NOT EXISTS schedule (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    group_id INT UNSIGNED NOT NULL,
    subject_id INT UNSIGNED NOT NULL,
    instructor_id INT UNSIGNED NOT NULL,
    audience VARCHAR(50) DEFAULT NULL COMMENT 'Номер аудитории',
    day_of_week ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday') NOT NULL,
    pair_number TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Номер пары (1-4)',
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
