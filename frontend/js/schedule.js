// Модуль управления расписанием

let allLessons = [];
let currentUserRole = null;
let allGroups = [];
let allSubjects = [];
let allInstructors = [];

// Дни недели
const DAYS = {
    'monday': 'Понедельник',
    'tuesday': 'Вторник',
    'wednesday': 'Среда',
    'thursday': 'Четверг',
    'friday': 'Пятница',
    'saturday': 'Суббота'
};

// ============================================================================
// INITIALIZATION
// ============================================================================

async function initScheduleModule() {
    // Получить роль пользователя
    const user = JSON.parse(localStorage.getItem('user'));
    currentUserRole = user?.role;

    await loadSchedule();

    // Только для админа
    if (currentUserRole === 'admin') {
        document.getElementById('createLessonBtn')?.addEventListener('click', openCreateLessonModal);
        await loadScheduleMetadata();
    }
}

async function loadScheduleMetadata() {
    // Загрузить группы, предметы, преподавателей для формы
    try {
        const [groupsRes, subjectsRes, instructorsRes] = await Promise.all([
            fetchWithAuth('groups'),
            fetchWithAuth('subjects'),
            fetchWithAuth('users?role=instructor')
        ]);

        allGroups = await groupsRes.json();
        allSubjects = await subjectsRes.json();
        allInstructors = await instructorsRes.json();
    } catch (error) {
        console.error('Error loading metadata:', error);
    }
}

// ============================================================================
// SCHEDULE LOADING
// ============================================================================

async function loadSchedule() {
    try {
        const response = await fetchWithAuth('schedule');
        if (!response.ok) {
            showToast('Ошибка загрузки расписания', 'error');
            return;
        }

        allLessons = await response.json();
        displayScheduleGrid(allLessons);
    } catch (error) {
        console.error('Error loading schedule:', error);
        showToast('Ошибка загрузки расписания', 'error');
    }
}

// ============================================================================
// SCHEDULE GRID DISPLAY
// ============================================================================

function displayScheduleGrid(lessons) {
    const container = document.getElementById('scheduleGrid');
    if (!container) return;

    // Группировка уроков по дням и времени
    const schedule = {};

    lessons.forEach(lesson => {
        const key = `${lesson.day_of_week}_${lesson.start_time}`;
        if (!schedule[key]) {
            schedule[key] = {
                day: lesson.day_of_week,
                time: `${lesson.start_time.slice(0, 5)}-${lesson.end_time.slice(0, 5)}`,
                lessons: []
            };
        }
        schedule[key].lessons.push(lesson);
    });

    // Отображение как список (упрощенная версия вместо сетки)
    if (Object.keys(schedule).length === 0) {
        container.innerHTML = '<p>Расписание пусто</p>';
        return;
    }

    let html = '<div class="schedule-list">';

    Object.keys(DAYS).forEach(day => {
        const dayLessons = Object.values(schedule).filter(s => s.day === day);

        if (dayLessons.length > 0) {
            html += `<div class="schedule-day">`;
            html += `<h3>${DAYS[day]}</h3>`;

            dayLessons.sort((a, b) => a.time.localeCompare(b.time)).forEach(slot => {
                slot.lessons.forEach(lesson => {
                    html += `
                        <div class="schedule-item">
                            <div class="schedule-time">${slot.time}</div>
                            <div class="schedule-details">
                                <strong>${lesson.subject_name}</strong><br>
                                <span>${lesson.group_name} | ${lesson.instructor_name}</span><br>
                                <span class="room">Ауд. ${lesson.room || '-'}</span>
                            </div>
                            ${currentUserRole === 'admin' ? `
                                <div class="schedule-actions">
                                    <button class="btn btn-sm btn-danger" onclick="deleteLesson(${lesson.id})">
                                        <i class='bx bx-trash'></i>
                                    </button>
                                </div>
                            ` : ''}
                        </div>
                    `;
                });
            });

            html += `</div>`;
        }
    });

    html += '</div>';
    container.innerHTML = html;
}

// ============================================================================
// LESSON CRUD
// ============================================================================

function openCreateLessonModal() {
    const modal = document.getElementById('createLessonModal');
    const form = document.getElementById('createLessonForm');

    form.reset();
    populateLessonFormSelects();
    modal.hidden = false;
}

function closeLessonModal() {
    document.getElementById('createLessonModal').hidden = true;
}

function populateLessonFormSelects() {
    // Группы
    const groupSelect = document.getElementById('lessonGroupId');
    groupSelect.innerHTML = '<option value="">Выберите группу...</option>' +
        allGroups.map(g => `<option value="${g.id}">${g.name}</option>`).join('');

    // Предметы
    const subjectSelect = document.getElementById('lessonSubjectId');
    subjectSelect.innerHTML = '<option value="">Выберите предмет...</option>' +
        allSubjects.map(s => `<option value="${s.id}">${s.name}</option>`).join('');

    // Преподаватели
    const instructorSelect = document.getElementById('lessonInstructorId');
    instructorSelect.innerHTML = '<option value="">Выберите преподавателя...</option>' +
        allInstructors.map(i => `<option value="${i.id}">${i.full_name}</option>`).join('');
}

async function createLesson(event) {
    event.preventDefault();

    const data = {
        group_id: parseInt(document.getElementById('lessonGroupId').value),
        subject_id: parseInt(document.getElementById('lessonSubjectId').value),
        instructor_user_id: parseInt(document.getElementById('lessonInstructorId').value),
        day_of_week: document.getElementById('lessonDayOfWeek').value,
        start_time: document.getElementById('lessonStartTime').value + ':00',
        end_time: document.getElementById('lessonEndTime').value + ':00',
        room: document.getElementById('lessonRoom').value
    };

    try {
        const response = await fetchWithAuth('schedule', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });

        if (!response.ok) {
            const error = await response.json();
            showToast(error.error || 'Ошибка создания урока', 'error');
            return;
        }

        showToast('Урок создан', 'success');
        closeLessonModal();
        loadSchedule();
    } catch (error) {
        console.error('Error creating lesson:', error);
        showToast('Ошибка создания урока', 'error');
    }
}

async function deleteLesson(lessonId) {
    if (!confirm('Удалить урок из расписания?')) return;

    try {
        const response = await fetchWithAuth(`schedule/${lessonId}`, {
            method: 'DELETE'
        });

        if (!response.ok) {
            showToast('Ошибка удаления', 'error');
            return;
        }

        showToast('Урок удалён', 'success');
        loadSchedule();
    } catch (error) {
        console.error('Error deleting lesson:', error);
        showToast('Ошибка удаления', 'error');
    }
}

// ============================================================================
// DASHBOARD WIDGET (для студента/преподавателя)
// ============================================================================

async function loadTodayScheduleWidget() {
    const widget = document.getElementById('todayScheduleWidget');
    if (!widget) return;

    try {
        const response = await fetchWithAuth('schedule/my');
        if (!response.ok) return;

        const lessons = await response.json();

        // Определить сегодняшний день недели
        const today = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'][new Date().getDay()];

        const todayLessons = lessons.filter(l => l.day_of_week === today);

        if (todayLessons.length === 0) {
            widget.innerHTML = '<p>Сегодня занятий нет</p>';
            return;
        }

        widget.innerHTML = todayLessons.map(l => {
            const time = `${l.start_time.slice(0, 5)}-${l.end_time.slice(0, 5)}`;
            if (currentUserRole === 'student') {
                return `<div class="widget-item">${time} | ${l.subject_name} | ${l.instructor_name} | Ауд. ${l.room || '-'}</div>`;
            } else {
                return `<div class="widget-item">${time} | ${l.group_name} | ${l.subject_name} | Ауд. ${l.room || '-'}</div>`;
            }
        }).join('');

    } catch (error) {
        console.error('Error loading today schedule:', error);
    }
}
