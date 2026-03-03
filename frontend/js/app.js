// Главный файл приложения

// Sidebar навигация
// Главный файл приложения

// Инициализация приложения при загрузке
document.addEventListener('DOMContentLoaded', initApp);

async function initApp() {
    console.log('URBAN COLLEGE PLATFORM загружена');

    // 1. Загрузка данных пользователя
    await loadUserInfo();

    // 2. Инициализация навигации
    initNavigation();

    // 3. Инициализация hamburger menu
    initSidebarToggle();

    // 4. Загрузка данных для активной секции
    loadActiveSectionData();
}

// Навигация sidebar
function initNavigation() {
    const navItems = document.querySelectorAll('.nav-item');
    const sections = document.querySelectorAll('.content-section');
    const sidebar = document.getElementById('sidebar');

    navItems.forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();

            const sectionId = item.dataset.section;

            // Убрать активный класс
            navItems.forEach(i => i.classList.remove('active'));
            sections.forEach(s => s.classList.remove('active'));

            // Добавить активный класс
            item.classList.add('active');
            const targetSection = document.getElementById(sectionId);
            if (targetSection) {
                targetSection.classList.add('active');
            }

            // Закрыть sidebar на мобильных
            if (sidebar.classList.contains('mobile-open')) {
                sidebar.classList.remove('mobile-open');
            }

            // Загрузить данные для секции
            if (sectionId === 'dashboard') {
                loadDashboard();
            } else if (sectionId === 'cafeteria') {
                loadActiveCafeteriaTab();
            } else if (sectionId === 'attendance') {
                initAttendanceModule();
            } else if (sectionId === 'users') {
                if (typeof initUsersModule === 'function') initUsersModule();
            } else if (sectionId === 'groups') {
                if (typeof initGroupsModule === 'function') initGroupsModule();
            } else if (sectionId === 'subjects') {
                if (typeof initSubjectsModule === 'function') initSubjectsModule();
            } else if (sectionId === 'schedule') {
                if (typeof initScheduleModule === 'function') initScheduleModule();
            } else if (sectionId === 'grades') {
                if (typeof initGradesModule === 'function') initGradesModule();
            } else if (sectionId === 'homework') {
                if (typeof initHomeworkModule === 'function') initHomeworkModule();
            }
        });
    });

    // Клик вне sidebar
    const sidebarToggle = document.getElementById('sidebarToggle');
    document.addEventListener('click', (e) => {
        if (sidebar.classList.contains('mobile-open')) {
            if (!sidebar.contains(e.target) && !sidebarToggle.contains(e.target)) {
                sidebar.classList.remove('mobile-open');
            }
        }
    });
}

// Hamburger menu
function initSidebarToggle() {
    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebar = document.getElementById('sidebar');

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', () => {
            sidebar.classList.toggle('mobile-open');
        });
    }
}

// Загрузчик данных секций
function loadActiveSectionData() {
    const activeSection = document.querySelector('.content-section.active');
    if (!activeSection) return;

    const sectionId = activeSection.id;
    if (sectionId === 'dashboard') {
        loadDashboard();
    } else if (sectionId === 'cafeteria') {
        loadActiveCafeteriaTab();
    } else if (sectionId === 'attendance') {
        initAttendanceModule();
    } else if (sectionId === 'users') {
        if (typeof initUsersModule === 'function') initUsersModule();
    } else if (sectionId === 'groups') {
        if (typeof initGroupsModule === 'function') initGroupsModule();
    } else if (sectionId === 'subjects') {
        if (typeof initSubjectsModule === 'function') initSubjectsModule();
    } else if (sectionId === 'schedule') {
        const user = JSON.parse(localStorage.getItem('user'));
        if (user && user.role === 'instructor') {
            if (typeof initInstructorSchedule === 'function') initInstructorSchedule();
        } else if (sectionId === 'homework') {
            if (typeof initHomeworkModule === 'function') initHomeworkModule();
        } else {
            if (typeof initScheduleModule === 'function') initScheduleModule();
        }
    }
}

function loadActiveCafeteriaTab() {
    const activeTab = document.querySelector('.tab-btn.active');
    if (activeTab) {
        const tabName = activeTab.dataset.tab;

        if (tabName === 'serve') {
            // Вкладка "Выдача питания" для оператора
            if (typeof initCafeteriaOperator === 'function') {
                initCafeteriaOperator();
            }
        } else if (tabName === 'categories') {
            loadCategories();
        } else if (tabName === 'assignments') {
            loadAssignments();
        } else if (tabName === 'history') {
            loadHistory();
        }
    }
}



// ============================================================================
// DASHBOARD MODULE
// ============================================================================

async function loadDashboard() {
    const container = document.getElementById('dashboardContent');
    container.innerHTML = '<div class="loader-container"><div class="loader"></div></div>'; // Spinner

    try {
        const response = await fetchWithAuth('dashboard/stats');

        if (!response.ok) {
            return await handleApiError(response);
        }

        const data = await response.json();
        renderDashboard(data);
    } catch (error) {
        console.error('Failed to load dashboard:', error);
        container.innerHTML = '<p class="error-msg">Ошибка загрузки данных дашборда</p>';
    }
}

function renderDashboard(data) {
    const container = document.getElementById('dashboardContent');
    let html = '';

    // === STUDENT DASHBOARD ===
    if (data.role === 'student') {
        const student = data;
        const cafeteria = student.cafeteria;
        const limits = cafeteria.daily_limit ? `${cafeteria.remaining} / ${cafeteria.daily_limit}` : 'Нет лимита';
        const limitColor = cafeteria.remaining > 0 ? 'success' : 'error';
        const hasAssignment = cafeteria.has_assignment;

        html = `
            <div class="student-welcome-card">
                <h3 class="student-welcome-title">Привет, ${data.student_code}! 👋</h3>
                <p class="student-welcome-subtitle">Группа: ${data.group_name || 'Не назначена'} • Хорошего дня в колледже</p>
            </div>

            <div class="dashboard-grid">
                <!-- Карта питания -->
                <div class="stat-card blue qr-code-section">
                    <div class="stat-icon"><i class='bx bx-id-card'></i></div>
                    
                    <div class="qr-preview" style="text-align: center; margin-bottom: 16px;">
                        <canvas id="dashboardQrCode"></canvas>
                    </div>
                    
                    ${hasAssignment ? `
                        <div style="text-align: center;">
                            <div class="stat-value" style="color: var(--${limitColor})">${limits}</div>
                            <div class="stat-label">Осталось обедов на сегодня</div>
                            <p style="font-size: 13px; color: var(--grey); margin-top: 8px;">
                                Категория: <strong>${cafeteria.category_name}</strong>
                            </p>
                        </div>
                    ` : `
                        <div style="text-align: center;">
                            <p class="error-msg">Питание не назначено</p>
                        </div>
                    `}
                </div>

                <!-- Посещаемость (Заглушка) -->
                <div class="stat-card green">
                    <div class="stat-icon"><i class='bx bx-check-circle'></i></div>
                    <div class="stat-value">Присутствует</div>
                    <div class="stat-label">Статус сегодня</div>
                </div>

                <!-- Расписание -->
                <div class="schedule-list">
                    <h4 style="margin-bottom: 16px;">Расписание на сегодня</h4>
                    
                    ${data.schedule && data.schedule.length > 0 ? data.schedule.map(lesson => `
                    <div class="schedule-item">
                        <div class="schedule-time">${lesson.start_time ? lesson.start_time.substring(0, 5) : ''}</div>
                        <div class="schedule-info">
                            <h4>${lesson.subject_name}</h4>
                            <p>Кабинет ${lesson.room || 'Не указан'} • ${lesson.instructor_name || 'Не назначен'}</p>
                        </div>
                    </div>
                    `).join('') : '<p style="color: var(--grey); font-size: 14px; text-align: center; padding: 20px;">Занятий сегодня нет</p>'}
                </div>
            </div>
        `;

        container.innerHTML = html;

        // Генерация QR кода если есть токен (нужно взять из localStorage или запросить отдельно)
        // Для простоты пока используем student_id, но лучше токен
        if (data.student_id) {
            generateQRCode('dashboardQrCode', data.student_id.toString());
        }

    }
    // === ADMIN DASHBOARD ===
    else if (data.role === 'admin') {
        html = `
            <div class="dashboard-grid">
                <!-- Студенты -->
                <div class="stat-card blue">
                    <div class="stat-icon"><i class='bx bx-user'></i></div>
                    <div class="stat-value">${data.students_count}</div>
                    <div class="stat-label">Всего студентов</div>
                </div>

                <!-- Выдано обедов -->
                <div class="stat-card red">
                    <div class="stat-icon"><i class='bx bx-dish'></i></div>
                    <div class="stat-value">${data.cafeteria.meals_served_today}</div>
                    <div class="stat-label">Выдано обедов сегодня</div>
                </div>

                <!-- Назначения -->
                <div class="stat-card orange">
                    <div class="stat-icon"><i class='bx bx-list-check'></i></div>
                    <div class="stat-value">${data.cafeteria.active_assignments}</div>
                    <div class="stat-label">Активных назначений питания</div>
                </div>
            </div>
        `;
        container.innerHTML = html;
    }
    // === OPERATOR DASHBOARD ===
    else if (data.role === 'cafeteria_operator') {
        html = `
            <div class="dashboard-grid">
                <!-- Обслужил лично -->
                <div class="stat-card purple">
                    <div class="stat-icon"><i class='bx bx-user-check'></i></div>
                    <div class="stat-value">${data.served_by_me}</div>
                    <div class="stat-label">Обслужено вами сегодня</div>
                </div>

                <!-- Всего по столовой -->
                <div class="stat-card blue">
                    <div class="stat-icon"><i class='bx bx-stats'></i></div>
                    <div class="stat-value">${data.total_served_today}</div>
                    <div class="stat-label">Всего выдано сегодня</div>
                </div>
                
                <!-- Быстрое действие -->
                <div class="stat-card" style="justify-content: center; align-items: center; cursor: pointer;" onclick="switchToSection('cafeteria')">
                     <div class="stat-icon" style="background: var(--light-grey); color: var(--primary-black);"><i class='bx bx-qr-scan'></i></div>
                     <h4 style="margin: 0;">Перейти к сканеру</h4>
                </div>
            </div>
        `;
        container.innerHTML = html;
    }
    // === CURATOR DASHBOARD ===
    else if (data.role === 'curator') {
        html = `
            <div class="dashboard-grid">
                <!-- Группы -->
                <div class="stat-card blue" onclick="switchToSection('groups')" style="cursor: pointer;">
                    <div class="stat-icon"><i class='bx bx-group'></i></div>
                    <div class="stat-value">Группы</div>
                    <div class="stat-label">Просмотр студентов</div>
                </div>

                <!-- Посещаемость -->
                <div class="stat-card green" onclick="switchToSection('attendance')" style="cursor: pointer;">
                    <div class="stat-icon"><i class='bx bx-qr-scan'></i></div>
                    <div class="stat-value">Посещаемость</div>
                    <div class="stat-label">Проверка присутствия</div>
                </div>

                <!-- Расписание (если нужно) -->
                <!-- <div class="stat-card purple" onclick="switchToSection('schedule')" style="cursor: pointer;">
                     <div class="stat-icon"><i class='bx bx-calendar'></i></div>
                     <div class="stat-value">Расписание</div>
                     <div class="stat-label">Расписание занятий</div>
                </div> -->
            </div>
        `;
        container.innerHTML = html;
    }
}

// Вспомогательная функция для генерации QR (если QRious уже подключен)
function generateQRCode(elementId, text) {
    if (typeof QRious !== 'undefined') {
        new QRious({
            element: document.getElementById(elementId),
            value: text,
            size: 150
        });
    } else {
        console.warn('QRious library not loaded');
    }
}

// ============================================================================
// CAFETERIA TAB SWITCHER
// ============================================================================

// Обработчики вкладок столовой
document.addEventListener('DOMContentLoaded', () => {
    const cafeteriaTabButtons = document.querySelectorAll('.tab-btn[data-tab]');

    cafeteriaTabButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            // Удалить active у всех кнопок
            cafeteriaTabButtons.forEach(b => b.classList.remove('active'));
            // Добавить active к нажатой
            btn.classList.add('active');

            // Загрузить данные для вкладки
            loadActiveCafeteriaTab();
        });
    });
});
