-- Generated Schedule Import (Final Robust Version)
SET NAMES utf8mb4;

-- Ensure all groups and subjects exist
INSERT IGNORE INTO `groups` (name, course) VALUES ('SГБ-2501/ГБ-2501', 1);
INSERT IGNORE INTO `groups` (name, course) VALUES ('SГБ-2502', 1);
INSERT IGNORE INTO `groups` (name, course) VALUES ('SЭЛ-2501/ЭЛ-2501', 1);
INSERT IGNORE INTO `groups` (name, course) VALUES ('SЭЛ-2502/ЭЛ-2502', 1);
INSERT IGNORE INTO `groups` (name, course) VALUES ('ВТиИС-2501', 1);
INSERT IGNORE INTO `groups` (name, course) VALUES ('ГБ-2502', 1);
INSERT IGNORE INTO `groups` (name, course) VALUES ('ПО-2501', 1);
INSERT IGNORE INTO `groups` (name, course) VALUES ('ПО-2502', 1);
INSERT IGNORE INTO `subjects` (name) VALUES ('Алғашқы әскери және технологиялық  дайындық');
INSERT IGNORE INTO `subjects` (name) VALUES ('Английский язык');
INSERT IGNORE INTO `subjects` (name) VALUES ('Ағылшын тілі');
INSERT IGNORE INTO `subjects` (name) VALUES ('Биология');
INSERT IGNORE INTO `subjects` (name) VALUES ('Все6мирная история');
INSERT IGNORE INTO `subjects` (name) VALUES ('Всемирная История');
INSERT IGNORE INTO `subjects` (name) VALUES ('Всемирная история');
INSERT IGNORE INTO `subjects` (name) VALUES ('Всемирная история Физическая культура');
INSERT IGNORE INTO `subjects` (name) VALUES ('География');
INSERT IGNORE INTO `subjects` (name) VALUES ('География Английский язык');
INSERT IGNORE INTO `subjects` (name) VALUES ('География Ағылшын тілі');
INSERT IGNORE INTO `subjects` (name) VALUES ('Глобалыные компетенции');
INSERT IGNORE INTO `subjects` (name) VALUES ('Графика және жобалау');
INSERT IGNORE INTO `subjects` (name) VALUES ('Графика и проектирование');
INSERT IGNORE INTO `subjects` (name) VALUES ('Дене тәрбиесі');
INSERT IGNORE INTO `subjects` (name) VALUES ('Дүниежүзі тарихы');
INSERT IGNORE INTO `subjects` (name) VALUES ('Жаһандық құзыреттер');
INSERT IGNORE INTO `subjects` (name) VALUES ('Информатика');
INSERT IGNORE INTO `subjects` (name) VALUES ('Казахский язык и литература');
INSERT IGNORE INTO `subjects` (name) VALUES ('Казахский язык и литература Математика');
INSERT IGNORE INTO `subjects` (name) VALUES ('Кураторлық сағат');
INSERT IGNORE INTO `subjects` (name) VALUES ('Кураторский час');
INSERT IGNORE INTO `subjects` (name) VALUES ('Математика');
INSERT IGNORE INTO `subjects` (name) VALUES ('Математика Всемирная история');
INSERT IGNORE INTO `subjects` (name) VALUES ('Математика Дүниежүзі тарихы');
INSERT IGNORE INTO `subjects` (name) VALUES ('Начально военная и технологическая подготовка');
INSERT IGNORE INTO `subjects` (name) VALUES ('Орыс тілі және әдебиеті');
INSERT IGNORE INTO `subjects` (name) VALUES ('Орыс тілі және әдебиеті Дене тәрбиесі');
INSERT IGNORE INTO `subjects` (name) VALUES ('Русская литература');
INSERT IGNORE INTO `subjects` (name) VALUES ('Русский язык');
INSERT IGNORE INTO `subjects` (name) VALUES ('Русский язык Русская литература');
INSERT IGNORE INTO `subjects` (name) VALUES ('Физика');
INSERT IGNORE INTO `subjects` (name) VALUES ('Физическая культура');
INSERT IGNORE INTO `subjects` (name) VALUES ('Химия');
INSERT IGNORE INTO `subjects` (name) VALUES ('химия');
INSERT IGNORE INTO `subjects` (name) VALUES ('Қазақ тілі');
INSERT IGNORE INTO `subjects` (name) VALUES ('Қазақ тілі Қазақ әдебиеті');
INSERT IGNORE INTO `subjects` (name) VALUES ('Қазақ әдебиеті');

TRUNCATE TABLE `schedule`;

-- Group: SГБ-2501/ГБ-2501, Day: monday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Кураторлық сағат' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Махин%' or full_name = 'Махин А.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№310', 'monday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Кураторлық сағат');

-- Group: SГБ-2502, Day: monday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Всемирная История' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Байдильдина%' or full_name = 'Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303', 'monday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Всемирная История');

-- Group: ГБ-2502, Day: monday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Английский язык' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Төребаева%' or full_name = 'Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№304', 'monday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Английский язык');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: monday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Казахский язык и литература' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'monday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Казахский язык и литература');

-- Group: ПО-2501, Day: monday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'monday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География');

-- Group: ПО-2502, Day: monday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Хамитова%' or full_name = 'Хамитова М.М.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№301', 'monday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Химия');

-- Group: ВТиИС-2501, Day: monday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'monday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика');

-- Group: SГБ-2501/ГБ-2501, Day: monday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'monday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика');

-- Group: SГБ-2502, Day: monday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Английский язык' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Төребаева%' or full_name = 'Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№304', 'monday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Английский язык');

-- Group: ГБ-2502, Day: monday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Биология' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Раймбаева%' or full_name = 'Раймбаева Ж.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№205', 'monday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Биология');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: monday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'monday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: monday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Қарсақбаева%' or full_name = 'Қарсақбаева Т.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№301', 'monday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Химия');

-- Group: ПО-2501, Day: monday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ тілі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'monday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ тілі');

-- Group: ПО-2502, Day: monday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№326', 'monday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика');

-- Group: ВТиИС-2501, Day: monday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'monday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті');

-- Group: SГБ-2501/ГБ-2501, Day: monday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Биология' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Раймбаева%' or full_name = 'Раймбаева Ж.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№205', 'monday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Биология');

-- Group: SГБ-2502, Day: monday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Информатика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Орынбасар%' or full_name = 'Орынбасар Ж.А.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№219', 'monday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Информатика');

-- Group: ГБ-2502, Day: monday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№326', 'monday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: monday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ тілі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'monday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ тілі');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: monday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Английский язык' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Төребаева%' or full_name = 'Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№304', 'monday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Английский язык');

-- Group: ПО-2501, Day: monday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'monday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті');

-- Group: ПО-2502, Day: monday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Графика и проектирование' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'monday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Графика и проектирование');

-- Group: ВТиИС-2501, Day: monday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е..') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'monday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География');

-- Group: SГБ-2501/ГБ-2501, Day: monday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'monday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: monday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'monday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: monday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Информатика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Орынбасар%' or full_name = 'Орынбасар Ж.А.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№219', 'monday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Информатика');

-- Group: ПО-2501, Day: monday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'monday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика');

-- Group: ПО-2502, Day: monday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Английский язык' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Төребаева%' or full_name = 'Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№304', 'monday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Английский язык');

-- Group: ВТиИС-2501, Day: monday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ тілі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'monday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ тілі');

-- Group: SГБ-2501/ГБ-2501, Day: tuesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика Дүниежүзі тарихы' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б. Олжабаева Б.О.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201 №303', 'tuesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика Дүниежүзі тарихы');

-- Group: SГБ-2502, Day: tuesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Хамитова%' or full_name = 'Хамитова М.М.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№301', 'tuesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Химия');

-- Group: ГБ-2502, Day: tuesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Начально военная и технологическая подготовка' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Махин%' or full_name = 'Махин А.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№310', 'tuesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Начально военная и технологическая подготовка');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: tuesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Информатика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Орынбасар%' or full_name = 'Орынбасар Ж.А.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№219', 'tuesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Информатика');

-- Group: ПО-2501, Day: tuesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Биология' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Раймбаева%' or full_name = 'Раймбаева Ж.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№205', 'tuesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Биология');

-- Group: ПО-2502, Day: tuesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русский язык' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'tuesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русский язык');

-- Group: ВТиИС-2501, Day: tuesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Ағылшын тілі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Төребаева%' or full_name = 'Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№304', 'tuesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Ағылшын тілі');

-- Group: SГБ-2501/ГБ-2501, Day: tuesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Информатика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Орынбасар%' or full_name = 'Орынбасар Ж.А.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№219', 'tuesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Информатика');

-- Group: SГБ-2502, Day: tuesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Начально военная и технологическая подготовка' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Махин%' or full_name = 'Махин А.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№310', 'tuesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Начально военная и технологическая подготовка');

-- Group: ГБ-2502, Day: tuesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География Английский язык' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е .                                Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302               №304', 'tuesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География Английский язык');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: tuesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Дене тәрбиесі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт алаңы', 'tuesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Дене тәрбиесі');

-- Group: ПО-2501, Day: tuesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика Дүниежүзі тарихы' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б. Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201 №303', 'tuesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика Дүниежүзі тарихы');

-- Group: ПО-2502, Day: tuesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Казахский язык и литература' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'tuesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Казахский язык и литература');

-- Group: ВТиИС-2501, Day: tuesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Кураторлық сағат' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№326', 'tuesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Кураторлық сағат');

-- Group: SГБ-2501/ГБ-2501, Day: tuesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География Ағылшын тілі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е .                            Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302               №304', 'tuesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География Ағылшын тілі');

-- Group: SГБ-2502, Day: tuesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русский язык' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'tuesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русский язык');

-- Group: ГБ-2502, Day: tuesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физическая культура' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт зал', 'tuesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физическая культура');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: tuesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Кураторлық сағат' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'tuesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Кураторлық сағат');

-- Group: ПО-2501, Day: tuesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Кураторлық сағат' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Раймбаева%' or full_name = 'Раймбаева Ж.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№205', 'tuesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Кураторлық сағат');

-- Group: ПО-2502, Day: tuesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Всемирная история Физическая культура' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Байдильдина%' or full_name = 'Байдильдина К.Е. Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303 спорт зал', 'tuesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Всемирная история Физическая культура');

-- Group: ВТиИС-2501, Day: tuesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика Дүниежүзі тарихы' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б. Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201 №303', 'tuesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика Дүниежүзі тарихы');

-- Group: SГБ-2501/ГБ-2501, Day: tuesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ тілі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'tuesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ тілі');

-- Group: SГБ-2502, Day: tuesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География Английский язык' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е. Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302     №304', 'tuesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География Английский язык');

-- Group: ГБ-2502, Day: tuesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русский язык' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'tuesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русский язык');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: tuesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика Дүниежүзі тарихы' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б. Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№301 №303', 'tuesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика Дүниежүзі тарихы');

-- Group: ВТиИС-2501, Day: tuesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%%' or full_name = '') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '', 'tuesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'химия');

-- Group: SГБ-2501/ГБ-2501, Day: wednesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Дүниежүзі тарихы' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Олжабаева%' or full_name = 'Олжабаева Б.О.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303', 'wednesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Дүниежүзі тарихы');

-- Group: SГБ-2502, Day: wednesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Кураторский час' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'wednesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Кураторский час');

-- Group: ГБ-2502, Day: wednesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'wednesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: wednesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'wednesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ әдебиеті');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: wednesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Графика и проектирование' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'wednesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Графика и проектирование');

-- Group: ПО-2501, Day: wednesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Алғашқы әскери және технологиялық  дайындық' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Махин%' or full_name = 'Махин А.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№310', 'wednesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Алғашқы әскери және технологиялық  дайындық');

-- Group: ПО-2502, Day: wednesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№326', 'wednesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физика');

-- Group: ВТиИС-2501, Day: wednesday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Биология' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Раймбаева%' or full_name = 'Раймбаева Ж.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№205', 'wednesday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Биология');

-- Group: SГБ-2501/ГБ-2501, Day: wednesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Алғашқы әскери және технологиялық  дайындық' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Махин%' or full_name = 'Махин А.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№310', 'wednesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Алғашқы әскери және технологиялық  дайындық');

-- Group: SГБ-2502, Day: wednesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'wednesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География');

-- Group: ГБ-2502, Day: wednesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№326', 'wednesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физика');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: wednesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Қарсақбаева%' or full_name = 'Қарсақбаева Т.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№301', 'wednesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Химия');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: wednesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Кураторский час' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Байдильдина%' or full_name = 'Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303', 'wednesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Кураторский час');

-- Group: ПО-2501, Day: wednesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'wednesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ әдебиеті');

-- Group: ПО-2502, Day: wednesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Кураторский час' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Орынбасар%' or full_name = 'Орынбасар Ж.А.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№219', 'wednesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Кураторский час');

-- Group: ВТиИС-2501, Day: wednesday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті Дене тәрбиесі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г. Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204 спорт алаңы', 'wednesday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті Дене тәрбиесі');

-- Group: SГБ-2501/ГБ-2501, Day: wednesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'wednesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ әдебиеті');

-- Group: SГБ-2502, Day: wednesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№326', 'wednesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физика');

-- Group: ГБ-2502, Day: wednesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Графика и проектирование' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'wednesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Графика и проектирование');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: wednesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Дүниежүзі тарихы' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Байдильдина%' or full_name = 'Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303', 'wednesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Дүниежүзі тарихы');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: wednesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Биология' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Раймбаева%' or full_name = 'Раймбаева Ж.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№205', 'wednesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Биология');

-- Group: ПО-2501, Day: wednesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті Дене тәрбиесі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г. Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204 спорт алаңы', 'wednesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті Дене тәрбиесі');

-- Group: ПО-2502, Day: wednesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'wednesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География');

-- Group: ВТиИС-2501, Day: wednesday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Хамитова%' or full_name = 'Хамитова М.М.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№301', 'wednesday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Химия');

-- Group: SГБ-2501/ГБ-2501, Day: wednesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Дене тәрбиесі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт алаңы', 'wednesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Дене тәрбиесі');

-- Group: SГБ-2502, Day: wednesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Графика и проектирование' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'wednesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Графика и проектирование');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: wednesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті Дене тәрбиесі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г. Жарманов К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204       спорт алаңы', 'wednesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Орыс тілі және әдебиеті Дене тәрбиесі');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: wednesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'География' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'wednesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'География');

-- Group: ПО-2501, Day: wednesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Дүниежүзі тарихы' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Байдильдина%' or full_name = 'Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303', 'wednesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Дүниежүзі тарихы');

-- Group: ПО-2502, Day: wednesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%%' or full_name = '') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '', 'wednesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'химия');

-- Group: ВТиИС-2501, Day: wednesday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'wednesday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ әдебиеті');

-- Group: SГБ-2501/ГБ-2501, Day: thursday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Хамитова%' or full_name = 'Хамитова М.М.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№301', 'thursday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Химия');

-- Group: ГБ-2502, Day: thursday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика Всемирная история' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.         Олжабаева Б.О.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201        №303', 'thursday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика Всемирная история');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: thursday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Алғашқы әскери және технологиялық  дайындық' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Махин%' or full_name = 'Махин А.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№310', 'thursday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Алғашқы әскери және технологиялық  дайындық');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: thursday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русская литература' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'thursday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русская литература');

-- Group: ПО-2501, Day: thursday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Жаһандық құзыреттер' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'thursday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Жаһандық құзыреттер');

-- Group: ПО-2502, Day: thursday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Казахский язык и литература Математика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209     №326', 'thursday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Казахский язык и литература Математика');

-- Group: ВТиИС-2501, Day: thursday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Графика және жобалау' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'thursday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Графика және жобалау');

-- Group: SГБ-2501/ГБ-2501, Day: thursday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Графика және жобалау' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'thursday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Графика және жобалау');

-- Group: SГБ-2502, Day: thursday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Математика Всемирная история' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.         Олжабаева Б.О.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201        №303', 'thursday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Математика Всемирная история');

-- Group: ГБ-2502, Day: thursday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Хамитова%' or full_name = 'Хамитова М.М.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№301', 'thursday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Химия');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: thursday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Жаһандық құзыреттер' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'thursday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Жаһандық құзыреттер');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: thursday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физическая культура' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт зал', 'thursday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физическая культура');

-- Group: ПО-2501, Day: thursday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Дене тәрбиесі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт зал', 'thursday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Дене тәрбиесі');

-- Group: ПО-2502, Day: thursday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русская литература' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'thursday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русская литература');

-- Group: ВТиИС-2501, Day: thursday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Алғашқы әскери және технологиялық  дайындық' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Махин%' or full_name = 'Махин А.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№310', 'thursday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Алғашқы әскери және технологиялық  дайындық');

-- Group: SГБ-2501/ГБ-2501, Day: thursday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Дене тәрбиесі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт алаңы', 'thursday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Дене тәрбиесі');

-- Group: SГБ-2502, Day: thursday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физическая культура' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт зал', 'thursday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физическая культура');

-- Group: ГБ-2502, Day: thursday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русская литература' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'thursday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русская литература');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: thursday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Ағылшын тілі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Төребаева%' or full_name = 'Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№ 204', 'thursday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Ағылшын тілі');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: thursday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Казахский язык и литература Математика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209     №326', 'thursday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Казахский язык и литература Математика');

-- Group: ПО-2501, Day: thursday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Графика және жобалау' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'thursday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Графика және жобалау');

-- Group: ПО-2502, Day: thursday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Биология' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Раймбаева%' or full_name = 'Раймбаева Ж.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№205', 'thursday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Биология');

-- Group: ВТиИС-2501, Day: thursday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Жаһандық құзыреттер' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'thursday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Жаһандық құзыреттер');

-- Group: SГБ-2502, Day: thursday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русская литература' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'thursday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русская литература');

-- Group: ГБ-2502, Day: thursday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Кураторский час' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Төребаева%' or full_name = 'Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№304', 'thursday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Кураторский час');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: thursday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Графика және жобалау' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Садувакас%' or full_name = 'Садувакас Ш.Б.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№201', 'thursday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Графика және жобалау');

-- Group: ПО-2501, Day: thursday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%%' or full_name = '') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '', 'thursday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'химия');

-- Group: ПО-2502, Day: thursday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Все6мирная история' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Байдильдина%' or full_name = 'Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303', 'thursday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Все6мирная история');

-- Group: SГБ-2501/ГБ-2501, Day: friday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ тілі Қазақ әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'friday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ тілі Қазақ әдебиеті');

-- Group: SГБ-2502, Day: friday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Всемирная история' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Байдильдина%' or full_name = 'Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303', 'friday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Всемирная история');

-- Group: ГБ-2502, Day: friday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русский язык Русская литература' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'friday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русский язык Русская литература');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: friday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Дене тәрбиесі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт алаңы', 'friday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Дене тәрбиесі');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: friday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Глобалыные компетенции' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'friday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Глобалыные компетенции');

-- Group: ПО-2501, Day: friday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Химия' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Хамитова%' or full_name = 'Хамитова М.М.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№301', 'friday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Химия');

-- Group: ПО-2502, Day: friday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Начально военная и технологическая подготовка' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Махин%' or full_name = 'Махин А.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№310', 'friday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Начально военная и технологическая подготовка');

-- Group: ВТиИС-2501, Day: friday, Pair: 1
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№326', 'friday', 1, '09:00:00', '10:20:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физика');

-- Group: SГБ-2501/ГБ-2501, Day: friday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№326', 'friday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физика');

-- Group: SГБ-2502, Day: friday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русский язык Русская литература' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'friday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русский язык Русская литература');

-- Group: ГБ-2502, Day: friday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Информатика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Орынбасар%' or full_name = 'Орынбасар Ж.А.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№219', 'friday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Информатика');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: friday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Биология' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Раймбаева%' or full_name = 'Раймбаева Ж.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№205', 'friday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Биология');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: friday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Начально военная и технологическая подготовка' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Махин%' or full_name = 'Махин А.С.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№310', 'friday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Начально военная и технологическая подготовка');

-- Group: ПО-2501, Day: friday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ тілі Қазақ әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'friday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ тілі Қазақ әдебиеті');

-- Group: ПО-2502, Day: friday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Глобалыные компетенции' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жұмаканов%' or full_name = 'Жұмаканов А.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№302', 'friday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Глобалыные компетенции');

-- Group: ВТиИС-2501, Day: friday, Pair: 2
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Дүниежүзі тарихы' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Байдильдина%' or full_name = 'Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303', 'friday', 2, '10:30:00', '11:50:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Дүниежүзі тарихы');

-- Group: SГБ-2501/ГБ-2501, Day: friday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Ағылшын тілі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Төребаева%' or full_name = 'Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№30ң', 'friday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2501/ГБ-2501' OR name LIKE '%SГБ-2501/ГБ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Ағылшын тілі');

-- Group: SГБ-2502, Day: friday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Биология' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Раймбаева%' or full_name = 'Раймбаева Ж.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№205', 'friday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Биология');

-- Group: ГБ-2502, Day: friday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Всемирная история' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Олжабаева%' or full_name = 'Олжабаева Б.О.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303', 'friday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Всемирная история');

-- Group: SЭЛ-2501/ЭЛ-2501, Day: friday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ тілі Қазақ әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'friday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2501/ЭЛ-2501' OR name LIKE '%SЭЛ-2501/ЭЛ-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ тілі Қазақ әдебиеті');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: friday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Всемирная история' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Байдильдина%' or full_name = 'Байдильдина К.Е.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№303', 'friday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Всемирная история');

-- Group: ПО-2501, Day: friday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физика' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Амангельдиев%' or full_name = 'Амангельдиев А.Н.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№326', 'friday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физика');

-- Group: ПО-2502, Day: friday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русский язык Русская литература' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'friday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2502' OR name LIKE '%ПО-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русский язык Русская литература');

-- Group: ВТиИС-2501, Day: friday, Pair: 3
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Дене тәрбиесі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт зал', 'friday', 3, '12:20:00', '13:40:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Дене тәрбиесі');

-- Group: SГБ-2502, Day: friday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физическая культура' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт зал', 'friday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SГБ-2502' OR name LIKE '%SГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физическая культура');

-- Group: ГБ-2502, Day: friday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Физическая культура' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Жарманов%' or full_name = 'Жарманов Е.Р.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  'спорт зал', 'friday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ГБ-2502' OR name LIKE '%ГБ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Физическая культура');

-- Group: SЭЛ-2502/ЭЛ-2502, Day: friday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Русский язык Русская литература' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Мусалаева%' or full_name = 'Мусалаева О.Г.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№204', 'friday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'SЭЛ-2502/ЭЛ-2502' OR name LIKE '%SЭЛ-2502/ЭЛ-2502%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Русский язык Русская литература');

-- Group: ПО-2501, Day: friday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Ағылшын тілі' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Төребаева%' or full_name = 'Төребаева А.Қ.') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№304', 'friday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ПО-2501' OR name LIKE '%ПО-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Ағылшын тілі');

-- Group: ВТиИС-2501, Day: friday, Pair: 4
INSERT INTO `schedule` (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
SELECT 
  (SELECT id FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%' LIMIT 1),
  (SELECT id FROM `subjects` WHERE name = 'Қазақ тілі Қазақ әдебиеті' LIMIT 1),
  IFNULL((SELECT id FROM `users` WHERE (full_name LIKE '%Уатхан%' or full_name = 'Уатхан К') AND role IN ('instructor', 'admin') LIMIT 1), (SELECT id FROM `users` WHERE full_name = 'Не указано' LIMIT 1)),
  '№209', 'friday', 4, '13:50:00', '15:10:00'
FROM DUAL WHERE EXISTS (SELECT 1 FROM `groups` WHERE name = 'ВТиИС-2501' OR name LIKE '%ВТиИС-2501%')
  AND EXISTS (SELECT 1 FROM `subjects` WHERE name = 'Қазақ тілі Қазақ әдебиеті');

