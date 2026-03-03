-- Миграция v3: Консолидация расписания и добавление недель
-- Перенос данных из lessons в schedule (если данных нет в schedule)

-- 1. Добавляем колонку week_number в таблицу schedule
ALTER TABLE `schedule` ADD COLUMN `week_number` TINYINT UNSIGNED NOT NULL DEFAULT 1 AFTER `group_id`;

-- 2. Добавляем индексы
ALTER TABLE `schedule` ADD INDEX `idx_schedule_week` (`week_number`);
ALTER TABLE `schedule` ADD INDEX `idx_group_week` (`group_id`, `week_number`);

-- 3. Перенос данных из lessons в schedule (лучше сделать через INSERT IGNORE или аналогичное)
-- Мы сопоставляем колонки:
-- lessons.instructor_user_id -> schedule.instructor_id
-- lessons.room -> schedule.audience
-- lessons.start_time -> schedule.time_start
-- lessons.end_time -> schedule.time_end

INSERT IGNORE INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT group_id, subject_id, instructor_user_id, room, day_of_week, pair_number, start_time, end_time
FROM `lessons`;

-- 4. Удаление старой таблицы lessons (опционально, но рекомендуется для чистоты)
-- DROP TABLE `lessons`;
