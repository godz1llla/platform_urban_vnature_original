// =============================================
// SCHEDULE MODULE - Расписание для студентов
// =============================================

let currentDay = null;

function initScheduleModule() {
    console.log('📅 Initializing Schedule Module');
    loadMySchedule();
    highlightCurrentDay();
}

function loadMySchedule() {
    showLoading();

    fetchWithAuth('schedule/my')
        .then(data => {
            console.log('📊 Schedule data:', data);
            renderSchedule(data);
        })
        .catch(error => {
            console.error('❌ Error loading schedule:', error);
            showError('Не удалось загрузить расписание');
        })
        .finally(() => {
            hideLoading();
        });
}

function renderSchedule(scheduleData) {
    const container = document.getElementById('schedule-content');

    if (!scheduleData || scheduleData.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <p>📅 Расписание пока не добавлено</p>
            </div>
        `;
        return;
    }

    // Группируем по дням недели
    const scheduleByDay = groupByDay(scheduleData);

    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    const dayNames = {
        'monday': { ru: 'Понедельник', kz: 'Дүйсенбі' },
        'tuesday': { ru: 'Вторник', kz: 'Сейсенбі' },
        'wednesday': { ru: 'Среда', kz: 'Сәрсенбі' },
        'thursday': { ru: 'Четверг', kz: 'Бейсенбі' },
        'friday': { ru: 'Пятница', kz: 'Жұма' },
        'saturday': { ru: 'Суббота', kz: 'Сенбі' }
    };

    let html = '<div class="schedule-grid">';

    days.forEach(day => {
        const dayLessons = scheduleByDay[day] || [];
        const isToday = getCurrentDay() === day;

        html += `
            <div class="schedule-day ${isToday ? 'today' : ''}">
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
                html += renderLesson(lesson);
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

function renderLesson(lesson) {
    return `
        <div class="schedule-lesson">
            <div class="lesson-header">
                <span class="pair-number">Пара ${lesson.pair_number}</span>
                <span class="lesson-time">${lesson.time_start.substring(0, 5)} - ${lesson.time_end.substring(0, 5)}</span>
            </div>
            <div class="lesson-subject">${lesson.subject_name_ru || lesson.subject_name_kz}</div>
            <div class="lesson-meta">
                <span class="lesson-instructor">👨‍🏫 ${lesson.instructor_name || 'Не указан'}</span>
                <span class="lesson-audience">🚪 ${lesson.audience || '--'}</span>
            </div>
        </div>
    `;
}

function groupByDay(scheduleData) {
    const grouped = {};
    scheduleData.forEach(lesson => {
        if (!grouped[lesson.day_of_week]) {
            grouped[lesson.day_of_week] = [];
        }
        grouped[lesson.day_of_week].push(lesson);
    });
    return grouped;
}

function getCurrentDay() {
    const days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    const today = new Date().getDay();
    return days[today];
}

function highlightCurrentDay() {
    currentDay = getCurrentDay();
}

function showLoading() {
    const container = document.getElementById('schedule-content');
    if (container) {
        container.innerHTML = `
            <div class="loading-spinner">
                <div class="spinner"></div>
                <p>Загрузка расписания...</p>
            </div>
        `;
    }
}

function hideLoading() {
    // Loading hidden automatically when content is rendered
}

function showError(message) {
    const container = document.getElementById('schedule-content');
    if (container) {
        container.innerHTML = `
            <div class="error-message">
                <p>❌ ${message}</p>
                <button onclick="loadMySchedule()" class="btn">Попробовать снова</button>
            </div>
        `;
    }
}

// Экспорт для глобального доступа
window.initScheduleModule = initScheduleModule;
window.loadMySchedule = loadMySchedule;
