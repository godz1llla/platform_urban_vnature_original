# СРОЧНОЕ SQL ИСПРАВЛЕНИЕ

## Проблема

QR-код не генерировался потому что:
- В базе данных `group_id` был `NOT NULL`
- При создании студента без группы передавался `NULL`
- SQL выдавал ошибку и студент не создавался

## Решение

Изменил схему таблицы `students`:
```sql
`group_id` INT UNSIGNED NULL,  -- было: NOT NULL
FOREIGN KEY (`group_id`) REFERENCES `groups`(`id`) ON DELETE SET NULL,  -- было: RESTRICT
```

## Как исправить на сервере

Выполните в phpMyAdmin или MySQL:

```sql
ALTER TABLE students 
MODIFY COLUMN group_id INT UNSIGNED NULL;

ALTER TABLE students 
DROP FOREIGN KEY students_ibfk_2;

ALTER TABLE students 
ADD CONSTRAINT students_ibfk_2 
FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE SET NULL;
```

Или ПЕРЕСОЗДАЙТЕ базу данных:
1. Сделайте backup существующих данных
2. Удалите таблицу `DROP TABLE students;`
3. Импортируйте обновленный `full_database.sql`

**После этого QR-коды будут генерироваться автоматически!**
