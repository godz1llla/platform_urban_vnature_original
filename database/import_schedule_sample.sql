-- ============================================================================
-- ТЕСТОВЫЕ ДАННЫЕ РАСПИСАНИЯ
-- ============================================================================
-- Примечание: Этот файл содержит примеры данных расписания
-- для тестирования функционала до полного парсинга HTML файла

-- Очистка существующих данных
TRUNCATE TABLE schedule;

-- Группа ГД-124 (ID: найти в базе)
-- Понедельник
INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГД-124' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru = 'Математика' LIMIT 1),
    (SELECT id FROM users WHERE last_name = 'Садувакас' AND role = 'instructor' LIMIT 1),
    '№201',
    'monday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГД-124' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru = 'Информатика' LIMIT 1),
    (SELECT id FROM users WHERE last_name = 'Орынбасар' AND role = 'instructor' LIMIT 1),
    '№219',
    'monday',
    2,
    '10:30:00',
    '11:50:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГД-124' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru = 'География' LIMIT 1),
    (SELECT id FROM users WHERE last_name = 'Жұмаканов' AND role = 'instructor' LIMIT 1),
    '№302',
    'monday',
    3,
    '12:20:00',
    '13:40:00'
);

-- Вторник
INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГД-124' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru = 'Математика' LIMIT 1),
    (SELECT id FROM users WHERE last_name = 'Садувакас' AND role = 'instructor' LIMIT 1),
    '№201',
    'tuesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГД-124' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru = 'Информатика' LIMIT 1),
    (SELECT id FROM users WHERE last_name = 'Орынбасар' AND role = 'instructor' LIMIT 1),
    '№219',
    'tuesday',
    2,
    '10:30:00',
    '11:50:00'
);

-- Среда
INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГД-124' LIMIT 1),
    (SELECT id FROM subjects WHERE name_kz = 'Қазақ тілі' LIMIT 1),
    (SELECT id FROM users WHERE last_name = 'Уатхан' AND role = 'instructor' LIMIT 1),
    '№209',
    'wednesday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГД-124' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru = 'География' LIMIT 1),
    (SELECT id FROM users WHERE last_name = 'Жұмаканов' AND role = 'instructor' LIMIT 1),
    '№302',
    'wednesday',
    2,
    '10:30:00',
    '11:50:00'
);

-- Четверг
INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГД-124' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru = 'Химия' LIMIT 1),
    (SELECT id FROM users WHERE last_name = 'Хамитова' AND role = 'instructor' LIMIT 1),
    '№301',
    'thursday',
    1,
    '09:00:00',
    '10:20:00'
);

-- Пятница  
INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГД-124' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru = 'Биология' LIMIT 1),
    (SELECT id FROM users WHERE last_name = 'Раймбаева' AND role = 'instructor' LIMIT 1),
    '№205',
    'friday',
    1,
    '09:00:00',
    '10:20:00'
);

INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = 'ГД-124' LIMIT 1),
    (SELECT id FROM subjects WHERE name_ru = 'Русский язык' LIMIT 1),
    (SELECT id FROM users WHERE last_name = 'Мусалаева' AND role = 'instructor' LIMIT 1),
    '№204',
    'friday',
    2,
    '10:30:00',
    '11:50:00'
);

-- ============================================================================
-- ПРИМЕЧАНИЯ
-- ============================================================================
-- После успешного тестирования нужно будет:
-- 1. Доработать parse_schedule.py для полного парсинга HTML
-- 2. Запустить скрипт: python3 database/parse_schedule.py
-- 3. Получить файл import_schedule_full.sql с полными данными
-- 4. Импортировать: SOURCE import_schedule_full.sql;
