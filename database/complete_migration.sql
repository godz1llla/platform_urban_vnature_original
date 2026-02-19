-- =================================================================
-- URBAN COLLEGE PLATFORM - DATABASE SCHEMA MIGRATION & DATA IMPORT
-- Version: 2.0 - COMPLETE
-- Date: 2026-01-09
-- Description: Full database setup including all migrations and data
-- =================================================================
-- 
-- ПОРЯДОК ВЫПОЛНЕНИЯ:
-- 1. Создание таблиц (full_database.sql)
-- 2. Специальности (import_specialties.sql)
-- 3. Группы (import_groups.sql)
-- 4. Сотрудники (import_employees.sql)
-- 5. Студенты (import_students.sql)
-- =================================================================

SOURCE database/full_database.sql;
SOURCE database/import_specialties.sql;
SOURCE database/import_groups.sql;
SOURCE database/import_employees.sql;
SOURCE database/import_students.sql;

-- Verification
SELECT 'База данных создана успешно!' AS status;
SELECT (SELECT COUNT(*) FROM users) AS total_users;
SELECT (SELECT COUNT(*) FROM students) AS total_students;
SELECT (SELECT COUNT(*) FROM groups) AS total_groups;
SELECT (SELECT COUNT(*) FROM specialties) AS  total_specialties;
