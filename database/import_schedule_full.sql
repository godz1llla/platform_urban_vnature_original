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
    (SELECT id FROM subjects WHERE name LIKE '%Кураторлық сағат%' OR name LIKE '%Кураторлық сағат%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Математика%' OR name LIKE '%Математика%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Биология%' OR name LIKE '%Биология%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%География%' OR name LIKE '%География%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Математика Дүниежүзі тарихы%' OR name LIKE '%Математика Дүниежүзі тарихы%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Информатика%' OR name LIKE '%Информатика%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%География Ағылшын тілі%' OR name LIKE '%География Ағылшын тілі%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Қазақ тілі%' OR name LIKE '%Қазақ тілі%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Дүниежүзі тарихы%' OR name LIKE '%Дүниежүзі тарихы%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Алғашқы әскери және технологиялық дайындық%' OR name LIKE '%Алғашқы әскери және технологиялық дайындық%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Қазақ әдебиеті%' OR name LIKE '%Қазақ әдебиеті%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Дене тәрбиесі%' OR name LIKE '%Дене тәрбиесі%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Химия%' OR name LIKE '%Химия%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Графика және жобалау%' OR name LIKE '%Графика және жобалау%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Дене тәрбиесі%' OR name LIKE '%Дене тәрбиесі%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Русская литература%' OR name LIKE '%Русская литература%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Қазақ тілі Қазақ әдебиеті%' OR name LIKE '%Қазақ тілі Қазақ әдебиеті%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Физика%' OR name LIKE '%Физика%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Ағылшын тілі%' OR name LIKE '%Ағылшын тілі%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Физическая культура%' OR name LIKE '%Физическая культура%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Русский язык%' OR name LIKE '%Русский язык%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ООМ 2%' OR name LIKE '%ООМ 2%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ООМ 1%' OR name LIKE '%ООМ 1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Физическая культура%' OR name LIKE '%Физическая культура%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%География%' OR name LIKE '%География%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Математика%' OR name LIKE '%Математика%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Физическая культура%' OR name LIKE '%Физическая культура%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Русская литература%' OR name LIKE '%Русская литература%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%БМ 1%' OR name LIKE '%БМ 1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%БМ 1%' OR name LIKE '%БМ 1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%БМ 1%' OR name LIKE '%БМ 1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%БМ 2%' OR name LIKE '%БМ 2%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%БМ 2%' OR name LIKE '%БМ 2%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%БМ 2%' OR name LIKE '%БМ 2%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Кураторский час%' OR name LIKE '%Кураторский час%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%БМ 1%' OR name LIKE '%БМ 1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%БМ 1%' OR name LIKE '%БМ 1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%БМ 1%' OR name LIKE '%БМ 1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%БМ 1%' OR name LIKE '%БМ 1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' OR name LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-4%' OR name LIKE '%ЖММ-4%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-3%' OR name LIKE '%ЖММ-3%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-3 Администрирование процесса установки сетевых устройств инфокоммуникационных систем%' OR name LIKE '%ПМ-3 Администрирование процесса установки сетевых устройств инфокоммуникационных систем%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ООМ-1%' OR name LIKE '%ООМ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' OR name LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-1%' OR name LIKE '%ЖММ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-3%' OR name LIKE '%ЖММ-3%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-3 Администрирование процесса установки сетевых устройств инфокоммуникационных систем%' OR name LIKE '%ПМ-3 Администрирование процесса установки сетевых устройств инфокоммуникационных систем%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ-4 Желілік құрылғылар мен бағдарламалық жасақтаманы конфигурациялау процесін басқару%' OR name LIKE '%КМ-4 Желілік құрылғылар мен бағдарламалық жасақтаманы конфигурациялау процесін басқару%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%№ 202%' OR name LIKE '%№ 202%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' OR name LIKE '%КМ-3 Электр монтаждау жұмыстарын жүргізу және аяқтау%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-4%' OR name LIKE '%ЖММ-4%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ООМ-1%' OR name LIKE '%ООМ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Английский язык%' OR name LIKE '%Английский язык%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-4 Администрирование процесса конфигурирования сетевых устройств и программного обеспечения%' OR name LIKE '%ПМ-4 Администрирование процесса конфигурирования сетевых устройств и программного обеспечения%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ-4 Тестілеу%' OR name LIKE '%КМ-4 Тестілеу%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ-4 Тестілеу%' OR name LIKE '%КМ-4 Тестілеу%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%№ 202%' OR name LIKE '%№ 202%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Английский язык%' OR name LIKE '%Английский язык%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ-5 Ұйымның серверлік жабдықтарын жинақтау, монтаждау, баптау және қызмет көрсету%' OR name LIKE '%КМ-5 Ұйымның серверлік жабдықтарын жинақтау, монтаждау, баптау және қызмет көрсету%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ-4 Тестілеу%' OR name LIKE '%КМ-4 Тестілеу%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ-4 Тестілеу%' OR name LIKE '%КМ-4 Тестілеу%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%№ 202%' OR name LIKE '%№ 202%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%№ 202%' OR name LIKE '%№ 202%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ-4 Желілік құрылғылар мен бағдарламалық жасақтаманы конфигурациялау процесін басқару%' OR name LIKE '%КМ-4 Желілік құрылғылар мен бағдарламалық жасақтаманы конфигурациялау процесін басқару%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ООМ-1%' OR name LIKE '%ООМ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ -7 Настройка и ослуживание серверного оборудования организации%' OR name LIKE '%ПМ -7 Настройка и ослуживание серверного оборудования организации%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-1%' OR name LIKE '%ЖММ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-1%' OR name LIKE '%ЖММ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-1%' OR name LIKE '%ЖММ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Английский язык%' OR name LIKE '%Английский язык%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Ағылшын тілі%' OR name LIKE '%Ағылшын тілі%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%КМ 4 Желдететін техникаға жоспарлы техникалық қызмет көрсетту жұмыстарын орындау%' OR name LIKE '%КМ 4 Желдететін техникаға жоспарлы техникалық қызмет көрсетту жұмыстарын орындау%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ -7 Настройка и ослуживание серверного оборудования организации%' OR name LIKE '%ПМ -7 Настройка и ослуживание серверного оборудования организации%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-1%' OR name LIKE '%ЖММ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Ағылшын тілі%' OR name LIKE '%Ағылшын тілі%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%Английский язык%' OR name LIKE '%Английский язык%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ООМ-1%' OR name LIKE '%ООМ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-1%' OR name LIKE '%ЖММ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ООМ-1%' OR name LIKE '%ООМ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ООМ-1%' OR name LIKE '%ООМ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-4%' OR name LIKE '%ЖММ-4%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ЖММ-1%' OR name LIKE '%ЖММ-1%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' OR name LIKE '%ПМ-8 Обеспечение работоспособности IT устройств%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
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
    (SELECT id FROM subjects WHERE name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' OR name LIKE '%ПМ-9 Обеспечение информационной безопасности локальных вычислительных сетей и Internet%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%Валиев%' AND role = 'instructor' LIMIT 1),
    '№215',
    'friday',
    4,
    '13:50:00',
    '15:10:00'
);
