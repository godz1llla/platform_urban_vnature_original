# ✅ ИСПРАВЛЕНИЕ БАЗЫ ДАННЫХ ЗАВЕРШЕНО

## Что было исправлено

### database/full_database.sql

1. **`group_id` теперь NULL** (строка 46)
   ```sql
   `group_id` INT UNSIGNED NULL,  -- было: NOT NULL
   ```

2. **Foreign key изменен на SET NULL** (строка 51)
   ```sql
   FOREIGN KEY (`group_id`) REFERENCES `groups`(`id`) ON DELETE SET NULL,
   -- было: ON DELETE RESTRICT
   ```

## Что это дает

- ✅ Студенты могут создаваться БЕЗ обязательной группы
- ✅ QR-код генерируется автоматически
- ✅ При удалении группы студенты остаются, group_id обнуляется

## Как применить на сервере

### Вариант 1: ALTER TABLE (если мало данных)

```sql
-- 1. Изменить поле
ALTER TABLE students MODIFY COLUMN group_id INT UNSIGNED NULL;

-- 2. Удалить старый foreign key
ALTER TABLE students DROP FOREIGN KEY students_ibfk_2;

-- 3. Добавить новый foreign key
ALTER TABLE students 
ADD CONSTRAINT students_ibfk_2 
FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE SET NULL;
```

### Вариант 2: Пересоздать таблицу (если данных нет)

```sql
DROP TABLE IF EXISTS students;
-- Затем импортировать обновленный full_database.sql
```

## Проверка

После применения создайте студента БЕЗ группы:
- Должно пройти успешно
- QR-код должен появиться автоматически
- Ошибок не должно быть

**ГОТОВО ДЛЯ ДИПЛОМА!** 🎓
