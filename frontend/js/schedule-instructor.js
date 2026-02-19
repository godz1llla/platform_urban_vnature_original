// =============================================
// SCHEDULE MODULE - Расписание для преподавателей
// =============================================

function initInstructorSchedule() {
    console.log('📅 Initializing Instructor Schedule Module');
    loadInstructorSchedule();
}

function loadInstructorSchedule() {
    showScheduleLoading();

    fetchWithAuth('schedule/my')
        .then(data => {
            console.log('📊 Instructor schedule data:', data);
            renderInstructorSchedule(data);
        })
        .catch(error => {
            console.error('❌ Error loading schedule:', error);
            showScheduleError('Не удалось загрузить расписание');
        })
        .finally(() => {
            hideScheduleLoading();
        });
}

function renderInstructorSchedule(scheduleData) {
    const container = document.getElementById('instructor-schedule-content');

    if (!scheduleData || scheduleData.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <p>📅 У вас пока нет занятий в расписании</p>
            </div>
        `;
        return;
    }

    // Группируем по дням недели
    const scheduleByDay = groupScheduleByDay(scheduleData);

    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    const dayNames = {
        'monday': { ru: 'Понедельник', kz: 'Дүйсенбі' },
        'tuesday': { ru: 'Вторник', kz: 'Сейсенбі' },
        'wednesday': { ru: 'Среда', kz: 'Сәрсенбі' },
        'thursday': { ru: 'Четверг', kz: 'Бейсенбі' },
        'friday': { ru: 'Пятница', kz: 'Жұма' },
        'saturday': { ru: 'Суббота', kz: 'Сенбі' }
    };

    let html = '<div class="instructor-schedule-grid">';

    days.forEach(day => {
        const dayLessons = scheduleByDay[day] || [];
        const isToday = getToday() === day;

        html += `
            <div class="instructor-schedule-day ${isToday ? 'today' : ''}">
                <h3 class="schedule-day-header">
                    <span class="day-name-ru">${dayNames[day].ru}</span>
                    <span class="day-name-kz">${dayNames[day].kz}</span>
                    ${isToday ? '<span class="today-badge">Сегодня</span>' : ''}
                </h3>
                <div class="schedule-lessons">
        `;

        if (dayLessons.length === 0) {
            html += '<p class="no-lessons">Занятий нет</p>';
        } else {
            // Сортируем по номеру пары
            dayLessons.sort((a, b) => a.pair_number - b.pair_number);

            dayLessons.forEach(lesson => {
                html += renderInstructorLesson(lesson, isToday);
            });
        }

        html += `
                </div>
            </div>
        `;
    });

    html += '</div>';
    container.innerHTML = html;
}

function renderInstructorLesson(lesson, isToday) {
    const timeNow = new Date();
    const currentTime = timeNow.getHours() * 60 + timeNow.getMinutes();

    // Парсим время начала и конца
    const [startHour, startMin] = lesson.time_start.split(':').map(Number);
    const [endHour, endMin] = lesson.time_end.split(':').map(Number);
    const lessonStart = startHour * 60 + startMin;
    const lessonEnd = endHour * 60 + endMin;

    const isNow = isToday && currentTime >= lessonStart && currentTime <= lessonEnd;
    const isUpcoming = isToday && currentTime < lessonStart && (lessonStart - currentTime) <= 60;

    let statusBadge = '';
    if (isNow) {
        statusBadge = '<span class="status-badge now">Сейчас идёт</span>';
    } else if (isUpcoming) {
        statusBadge = '<span class="status-badge upcoming">Скоро начнётся</span>';
    }

    return `
        <div class="instructor-lesson ${isNow ? 'active' : ''} ${isUpcoming ? 'upcoming' : ''}">
            <div class="lesson-header">
                <span class="pair-number">Пара ${lesson.pair_number}</span>
                <span class="lesson-time">${lesson.time_start.substring(0, 5)} - ${lesson.time_end.substring(0, 5)}</span>
                ${statusBadge}
            </div>
            <div class="lesson-subject">${lesson.subject_name_ru || lesson.subject_name_kz}</div>
            <div class="lesson-meta">
                <span class="lesson-group">👥 Группа: ${lesson.group_name}</span>
                <span class="lesson-audience">🚪 Аудитория: ${lesson.audience || '--'}</span>
            </div>
        </div>
    `;
}

function groupScheduleByDay(scheduleData) {
    const grouped = {};
    scheduleData.forEach(lesson => {
        if (!grouped[lesson.day_of_week]) {
            grouped[lesson.day_of_week] = [];
        }
        grouped[lesson.day_of_week].push(lesson);
    });
    return grouped;
}

function getToday() {
    const days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    const today = new Date().getDay();
    return days[today];
}

function showScheduleLoading() {
    const container = document.getElementById('instructor-schedule-content');
    if (container) {
        container.innerHTML = `
            <div class="loading-spinner">
                <div class="spinner"></div>
                <p>Загрузка расписания...</p>
            </div>
        `;
    }
}

function hideScheduleLoading() {
    // Loading hidden automatically when content is rendered
}

function showScheduleError(message) {
    const container = document.getElementById('instructor-schedule-content');
    if (container) {
        container.innerHTML = `
            <div class="error-message">
                <p>❌ ${message}</p>
                <button onclick="loadInstructorSchedule()" class="btn">Попробовать снова</button>
            </div>
        `;
    }
}

// Экспорт для глобального доступа
window.initInstructorSchedule = initInstructorSchedule;
window.loadInstructorSchedule = loadInstructorSchedule;
