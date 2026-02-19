# Финальная интеграция: Инструкция по вставке HTML

## Что сделано ✅

**Backend:** Все 4 контроллера готовы (Users, Groups, Subjects, Schedule)  
**Frontend JS:** Все 4 модуля готовы (users.js, groups.js, subjects.js, schedule.js)  
**Database:** Все таблицы созданы (subjects, subject_instructors, lessons)

## Что осталось ⚠️

Вставить HTML секции и модалки в `index.html`

---

## Инструкция по вставке

### Шаг 1: Открыть index.html

Откройте файл:
```
/home/hubtech/Documents/1UUUUUUUUUUUUUUUUUUUU/frontend/index.html
```

### Шаг 2: Найти закрывающий тег `</main>`

Найдите строку примерно на линии 515:
```html
        </section>
    </main>
```

### Шаг 3: Вставить 4 секции ПЕРЕД `</main>`

**Вставить в следующем порядке:**

#### 1. Users Section
Скопировать содержимое файла:
```
/home/hubtech/Documents/1UUUUUUUUUUUUUUUUUUUU/frontend/index.html.users_section
```

#### 2. Groups Section  
Скопировать содержимое файла:
```
/home/hubtech/Documents/1UUUUUUUUUUUUUUUUUUUU/frontend/index.html.groups_section
```

#### 3. Subjects Section
Скопировать содержимое файла:
```
/home/hubtech/Documents/1UUUUUUUUUUUUUUUUUUUU/frontend/index.html.subjects_section
```

#### 4. Schedule Section
Скопировать содержимое файла:
```
/home/hubtech/Documents/1UUUUUUUUUUUUUUUUUUUU/frontend/index.html.schedule_section
```

---

### Шаг 4: Найти `<!-- Scripts -->`

Найдите строку примерно на линии 590:
```html
    <!-- Scripts -->
    <script src="js/utils.js"></script>
```

### Шаг 5: Вставить 4 модалки ПЕРЕД `<!-- Scripts -->`

**Вставить в следующем порядке:**

#### 1. User Modal
Скопировать содержимое файла:
```
/home/hubtech/Documents/1UUUUUUUUUUUUUUUUUUUU/frontend/index.html.user_modal
```

#### 2. Groups Modals
Скопировать содержимое файла:
```
/home/hubtech/Documents/1UUUUUUUUUUUUUUUUUUUU/frontend/index.html.groups_modals
```

#### 3. Subjects Modals
Скопировать содержимое файла:
```
/home/hubtech/Documents/1UUUUUUUUUUUUUUUUUUUU/frontend/index.html.subjects_modals
```

#### 4. Schedule Modal
Скопировать содержимое файла:
```
/home/hubtech/Documents/1UUUUUUUUUUUUUUUUUUUU/frontend/index.html.schedule_modal
```

---

### Шаг 6: Обновить список скриптов

Убедитесь что перед `<script src="js/app.js">` есть:
```html
<script src="js/users.js"></script>
<script src="js/groups.js"></script>
<script src="js/subjects.js"></script>
<script src="js/schedule.js"></script>
<script src="js/app.js"></script>
```

---

### Шаг 7: Обновить навигацию (если не обновлено)

В sidebar после пункта "Предметы" должно быть:
```html
<a href="#schedule" class="nav-item" data-section="schedule">
    <i class='bx bx-calendar'></i>
    <span>Расписание</span>
</a>
```

---

### Шаг 8: Проверить auth.js

В `frontend/js/auth.js` в функции `applyRoleVisibility()`:

**Для админа (около строки 182):**
```javascript
// Расписание - для админа
const scheduleNav = document.querySelector('[data-section="schedule"]');
if (scheduleNav) {
    scheduleNav.style.display = 'flex';
}
```

**Для студента (около строки 192):**
```javascript
case 'student':
    const studentScheduleNav = document.querySelector('[data-section="schedule"]');
    if (studentScheduleNav) studentScheduleNav.style.display = 'flex';
    break;
```

**Для преподавателя (около строки 200):**
```javascript
case 'instructor':
    const instructorScheduleNav = document.querySelector('[data-section="schedule"]');
    if (instructorScheduleNav) instructorScheduleNav.style.display = 'flex';
    break;
```

---

## Проверка

После всех вставок:

1. **Админ логинится:**
   - Видит меню: Dashboard, Посещаемость, Столовая, Пользователи, Группы, Предметы, Расписание
   - Может создавать пользователей, группы, предметы, уроки

2. **Студент логинится:**
   - Видит меню: Dashboard, Расписание, Моя карта
   - Видит своё расписание

3. **Преподаватель логинится:**
   - Видит меню: Dashboard, Расписание
   - Видит свои занятия

---

## Dashboard виджеты (опционально)

Если хотите добавить виджет "Расписание на сегодня" на Dashboard:

Открыть файл `/home/hubtech/Documents/1UUUUUUUUUUUUUUUUUUUU/frontend/dashboard_schedule_widget.html`

Вставить содержимое в секцию Dashboard (около строки 100).

---

## Файлы для загрузки на хостинг

### Backend:
- `database/full_database.sql`
- `backend/api.php`
- `backend/controllers/UsersController.php`
- `backend/controllers/GroupsController.php`
- `backend/controllers/SubjectsController.php`
- `backend/controllers/ScheduleController.php`

### Frontend:
- `frontend/index.html` (после вставки HTML)
- `frontend/js/auth.js`
- `frontend/js/users.js`
- `frontend/js/groups.js`
- `frontend/js/subjects.js`
- `frontend/js/schedule.js`

---

## Следующие шаги (опционально)

**Этапы 5-6 (если нужны):**
- Этап 5: Журнал оценок (Grades)
- Этап 6: Домашние задания (Homework)

**Но MVP уже готов!** Платформа функциональна для старта.
