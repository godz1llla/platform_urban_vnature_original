# Диагностика проблемы: Модуль "Управление пользователями"

## Проблема

Кнопки в модуле "Управление пользователями" не работают:
- ❌ Кнопка "Добавить пользователя"
- ❌ Табы "Преподаватели", "Операторы столовой"

## Причина

**users.js не инициализируется при открытии секции!**

### Почему?

1. **app.js не вызывает initUsersModule()** при переключении на секцию users
2. **HTML был вставлен, но JavaScript не подключается к элементам**

## Решение

### Шаг 1: Исправить app.js

Добавить инициализацию модулей в функцию навигации:

```javascript
// В initNavigation() после строки 53:
} else if (sectionId === 'users') {
    if (typeof initUsersModule === 'function') {
        initUsersModule();
    }
} else if (sectionId === 'groups') {
    if (typeof initGroupsModule === 'function') {
        initGroupsModule();
    }
} else if (sectionId === 'subjects') {
    if (typeof initSubjectsModule === 'function') {
        initSubjectsModule();
    }
} else if (sectionId === 'schedule') {
    if (typeof initScheduleModule === 'function') {
        initScheduleModule();
    }
}
```

### Шаг 2: Проверить порядок скриптов

В index.html перед `app.js` должны быть:
```html
<script src="js/users.js"></script>
<script src="js/groups.js"></script>
<script src="js/subjects.js"></script>
<script src="js/schedule.js"></script>
<script src="js/app.js"></script>  <!-- ПОСЛЕДНИЙ! -->
```

### Шаг 3: Проверить что users.js загружен

В консоли браузера (F12):
```javascript
typeof initUsersModule
// Должно вернуть "function"
```

Если вернет "undefined" — значит users.js не загрузился.

## Что я создал (краткая справка)

### Backend (4 контроллера):
1. **UsersController.php** — CRUD пользователей
2. **GroupsController.php** — CRUD групп
3. **SubjectsController.php** — CRUD предметов
4. **ScheduleController.php** — CRUD расписания

### Frontend (4 модуля):
1. **users.js** — управление пользователями
2. **groups.js** — управление группами
3. **subjects.js** — управление предметами
4. **schedule.js** — расписание

### HTML секции (вставлены):
- ✅ Users Section (с табами)
- ✅ Groups Section
- ✅ Subjects Section
- ✅ Schedule Section

### Модалки (вставлены):
- ✅ User Modal
- ✅ Groups Modals
- ✅ Subjects Modals
- ✅ Schedule Modal

## Быстрое решение

Замените `app.js` на исправленную версию (файл приложен отдельно).

Или добавьте вручную в строку ~60 app.js:

```javascript
else if (sectionId === 'users') {
    if (typeof initUsersModule === 'function') initUsersModule();
} else if (sectionId === 'groups') {
    if (typeof initGroupsModule === 'function') initGroupsModule();
} else if (sectionId === 'subjects') {
    if (typeof initSubjectsModule === 'function') initSubjectsModule();
} else if (sectionId === 'schedule') {
    if (typeof initScheduleModule === 'function') initScheduleModule();
}
```

**После этого перезагрузите страницу (Ctrl+Shift+R)!**
