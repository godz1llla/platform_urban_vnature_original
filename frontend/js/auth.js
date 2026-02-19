// Аутентификация

// Проверка авторизации при загрузке страницы
async function checkAuth() {
    const token = getToken();

    if (!token) {
        window.location.href = '/frontend/login.html';
        return null;
    }

    try {
        const response = await fetchWithAuth('auth/me');

        if (!response.ok) {
            removeToken();
            window.location.href = '/frontend/login.html';
            return null;
        }

        const user = await response.json();
        return user;
    } catch (error) {
        console.error('Auth check failed:', error);
        return null;
    }
}

// Отображение информации о пользователе
function displayUserInfo(user) {
    const userInfo = document.getElementById('userInfo');

    if (!userInfo) return;

    const userName = userInfo.querySelector('.user-name');
    const userRole = userInfo.querySelector('.user-role');

    userName.textContent = user.full_name;

    const roleNames = {
        'admin': 'Администратор',
        'student': 'Студент',
        'instructor': 'Преподаватель',
        'cafeteria_operator': 'Оператор столовой'
    };

    userRole.textContent = roleNames[user.role] || user.role;
}

// Выход из системы
function logout() {
    removeToken();
    window.location.href = '/frontend/login.html';
}

// Загрузка информации о пользователе (вызывается из app.js)
async function loadUserInfo() {
    const user = await checkAuth();

    if (user) {
        displayUserInfo(user);
        window.currentUser = user;
        localStorage.setItem('user', JSON.stringify(user));
        applyRoleVisibility(user.role);
    }

    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', logout);
    }
}

// Применить видимость элементов в зависимости от роли
function applyRoleVisibility(role) {
    console.log('🔧 applyRoleVisibility вызван с ролью:', role);

    // Все пункты меню (используем data-section, т.к. ID нет)
    const dashboardNav = document.querySelector('[data-section="dashboard"]');
    const myCardNav = document.querySelector('[data-section="my-card"]');
    const attendanceNav = document.querySelector('[data-section="attendance"]');
    const journalNav = document.querySelector('[data-section="grades"]');
    const homeworkNav = document.querySelector('[data-section="homework"]');
    const cafeteriaNav = document.querySelector('[data-section="cafeteria"]');
    const usersNav = document.querySelector('[data-section="users"]');
    const groupsNav = document.querySelector('[data-section="groups"]');
    const subjectsNav = document.querySelector('[data-section="subjects"]');
    const scheduleNav = document.querySelector('[data-section="schedule"]');

    console.log('📋 Найденные элементы:', {
        dashboardNav: !!dashboardNav,
        myCardNav: !!myCardNav,
        attendanceNav: !!attendanceNav,
        journalNav: !!journalNav,
        homeworkNav: !!homeworkNav,
        cafeteriaNav: !!cafeteriaNav,
        usersNav: !!usersNav,
        groupsNav: !!groupsNav,
        subjectsNav: !!subjectsNav,
        scheduleNav: !!scheduleNav
    });

    // Скрыть все пункты меню сначала
    if (dashboardNav) dashboardNav.style.display = 'none';
    if (myCardNav) myCardNav.style.display = 'none';
    if (attendanceNav) attendanceNav.style.display = 'none';
    if (journalNav) journalNav.style.display = 'none';
    if (homeworkNav) homeworkNav.style.display = 'none';
    if (cafeteriaNav) cafeteriaNav.style.display = 'none';

    // АДМИНСКИЕ ПУНКТЫ - скрыть по умолчанию
    if (usersNav) usersNav.style.display = 'none';
    if (groupsNav) groupsNav.style.display = 'none';
    if (subjectsNav) subjectsNav.style.display = 'none';
    if (scheduleNav) scheduleNav.style.display = 'none';

    console.log('✅ Все пункты меню скрыты');

    // Показать пункты в зависимости от роли
    switch (role) {
        case 'student':
            console.log('👨‍🎓 Настройка для студента');
            // Студент видит только свою карту и посещаемость
            if (dashboardNav) {
                dashboardNav.style.display = 'flex';
                console.log('✅ Показан "Дашборд"');
            }
            if (myCardNav) {
                myCardNav.style.display = 'flex';
                console.log('✅ Показана "Моя карта питания"');
            }
            if (attendanceNav) {
                attendanceNav.style.display = 'flex';
                console.log('✅ Показана "Посещаемость"');
            }
            switchToSection('dashboard');
            break;

        case 'cafeteria_operator':
            console.log('🍽️ Настройка для оператора столовой');
            // Оператор столовой видит только столовую
            if (cafeteriaNav) {
                cafeteriaNav.style.display = 'flex';
                console.log('✅ Показана "Столовая"');
            }
            switchToSection('cafeteria');

            // Скрыть табы управления (категории, назначения)
            const categoryTab = document.querySelector('[data-tab="categories"]');
            const assignmentTab = document.querySelector('[data-tab="assignments"]');
            if (categoryTab) categoryTab.style.display = 'none';
            if (assignmentTab) assignmentTab.style.display = 'none';
            break;

        case 'instructor':
            console.log('👨‍🏫 Настройка для преподавателя');
            // Преподаватель видит дашборд, посещаемость, журнал, ДЗ
            if (dashboardNav) {
                dashboardNav.style.display = 'flex';
                console.log('✅ Показан "Дашборд"');
            }
            if (attendanceNav) {
                attendanceNav.style.display = 'flex';
                console.log('✅ Показана "Посещаемость"');
            }
            if (journalNav) {
                journalNav.style.display = 'flex';
                console.log('✅ Показан "Журнал"');
            }
            if (homeworkNav) {
                homeworkNav.style.display = 'flex';
                console.log('✅ Показаны "Домашние задания"');
            }
            switchToSection('dashboard');
            break;

        case 'admin':
            console.log('👨‍💼 Настройка для админа');
            // Админ видит ВСЕ
            if (dashboardNav) dashboardNav.style.display = 'flex';
            if (attendanceNav) attendanceNav.style.display = 'flex';
            if (journalNav) journalNav.style.display = 'flex';
            if (homeworkNav) homeworkNav.style.display = 'flex';
            if (cafeteriaNav) cafeteriaNav.style.display = 'flex';

            // ТОЛЬКО АДМИН видит управление
            if (usersNav) {
                usersNav.style.display = 'flex';
                console.log('✅ Показан "Пользователи"');
            }
            if (groupsNav) {
                groupsNav.style.display = 'flex';
                console.log('✅ Показан "Группы"');
            }
            if (subjectsNav) {
                subjectsNav.style.display = 'flex';
                console.log('✅ Показан "Предметы"');
            }
            if (scheduleNav) {
                scheduleNav.style.display = 'flex';
                console.log('✅ Показано "Расписание"');
            }

            console.log('✅ Показаны все пункты меню');
            switchToSection('dashboard');
            break;

        default:
            console.log('⚠️ Неизвестная роль:', role);
            // Для неизвестных ролей показать дашборд
            if (dashboardNav) dashboardNav.style.display = 'flex';
            switchToSection('dashboard');
    }

    console.log('✅ applyRoleVisibility завершен');
}

// Переключение на секцию
function switchToSection(sectionId) {
    console.log('🔄 switchToSection вызвана для:', sectionId);

    // Убрать active со всех nav items и секций
    document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
    document.querySelectorAll('.section').forEach(section => section.classList.remove('active'));

    // Активировать нужную секцию и nav item
    const section = document.getElementById(sectionId);
    const navItem = document.querySelector(`[data-section="${sectionId}"]`);

    console.log('🔍 Найдено:', {
        section: !!section,
        navItem: !!navItem
    });

    if (section) {
        section.classList.add('active');
        console.log('✅ Секция активирована:', sectionId);
    } else {
        console.error('❌ Секция НЕ найдена:', sectionId);
    }

    if (navItem) {
        navItem.classList.add('active');
        console.log('✅ Nav item активирован');
    } else {
        console.error('❌ Nav item НЕ найден для:', sectionId);
    }
}
