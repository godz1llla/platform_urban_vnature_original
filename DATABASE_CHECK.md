# Проверка базы данных: full_database.sql

## ✅ ПРОВЕРКА ЗАВЕРШЕНА

### Таблицы для модулей платформы:

#### 1. Базовые таблицы пользователей:
- ✅ **users** — основная таблица пользователей (admin, student, instructor, cafeteria_operator)
- ✅ **students** — расширенная инфо о студентах (group_id, student_code, qr_token)

#### 2. Этап 1-2: Группы
- ✅ **groups** — учебные группы (name, course)

#### 3. Этап 3: Предметы
- ✅ **subjects** — учебные предметы (name, description)
- ✅ **subject_instructors** — связь M:N (предмет ↔ преподаватели)

#### 4. Этап 4: Расписание
- ✅ **lessons** — расписание занятий (group_id, subject_id, instructor_user_id, day_of_week, start_time, end_time, room)

#### 5. Модуль Столовой:
- ✅ **cafeteria_categories** — категории питания (с ценой price_per_portion)
- ✅ **cafeteria_assignments** — назначения студентам
- ✅ **cafeteria_transactions** — история выдачи

#### 6. Модуль Посещаемости:
- ✅ **attendance** — записи посещаемости

---

## Структура ключевых таблиц

### students
```sql
- id INT UNSIGNED
- user_id INT UNSIGNED (FK → users)
- group_id INT UNSIGNED (FK → groups, NULL)
- student_code VARCHAR(50) UNIQUE
- qr_token VARCHAR(255) UNIQUE
- balance DECIMAL(10,2) DEFAULT 0.00
```

### groups
```sql
- id INT UNSIGNED
- name VARCHAR(100) UNIQUE
- course INT DEFAULT 1
```

### subjects
```sql
- id INT UNSIGNED
- name VARCHAR(255) UNIQUE
- description TEXT
```

### subject_instructors (M:N)
```sql
- id INT UNSIGNED
- subject_id INT UNSIGNED (FK → subjects, CASCADE)
- instructor_user_id INT UNSIGNED (FK → users, CASCADE)
- UNIQUE (subject_id, instructor_user_id)
```

### lessons (Расписание)
```sql
- id INT UNSIGNED
- group_id INT UNSIGNED (FK → groups, CASCADE)
- subject_id INT UNSIGNED (FK → subjects, CASCADE)
- instructor_user_id INT UNSIGNED (FK → users, RESTRICT)
- day_of_week ENUM('monday', 'tuesday', ...)
- start_time TIME
- end_time TIME
- room VARCHAR(100)
```

---

## Foreign Keys и связи

### ✅ Корректные CASCADE/RESTRICT:

1. **students.group_id** → groups(id) ON DELETE SET NULL
   - При удалении группы студенты остаются без группы

2. **subject_instructors** → subjects/users ON DELETE CASCADE
   - При удалении предмета/преподавателя связи удаляются

3. **lessons.group_id** → groups(id) ON DELETE CASCADE
   - При удалении группы расписание удаляется

4. **lessons.subject_id** → subjects(id) ON DELETE CASCADE
   - При удалении предмета расписание удаляется

5. **lessons.instructor_user_id** → users(id) ON DELETE RESTRICT
   - Нельзя удалить преподавателя с активным расписанием

---

## Индексы

### ✅ Оптимизация запросов:

- `students.user_id` — индекс
- `students.group_id` — индекс
- `subject_instructors.subject_id` — индекс
- `subject_instructors.instructor_user_id` — индекс
- `lessons.group_id` — индекс
- `lessons.instructor_user_id` — индекс
- `lessons.day_of_week, start_time` — составной индекс

---

## Итого

**Всего таблиц:** 10

**Критичные для этапов 1-4:**
1. users ✅
2. students ✅
3. groups ✅  
4. subjects ✅
5. subject_instructors ✅
6. lessons ✅

**Дополнительные (уже работающие):**
7. cafeteria_categories ✅
8. cafeteria_assignments ✅
9. cafeteria_transactions ✅
10. attendance ✅

---

## ✅ БАЗА ДАННЫХ ГОТОВА!

Все таблицы на месте, связи корректны, индексы добавлены.

**Можно импортировать:** `database/full_database.sql`
