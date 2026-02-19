// МОДУЛЬ ПОЛЬЗОВАТЕЛЕЙ (ПОЛНАЯ ВЕРСИЯ v2.0)

let currentUsersTab = 'students';
let allUsers = [];
// Кэш справочников
let usersGroupsCache = [];
let usersSubjectsCache = [];
let usersSpecialtiesCache = [];
let activeUserModal = null;

function initUsersModule() {
    console.log('✅ Users Module v2.0 Loaded');
    loadUsers();

    // Предзагрузка справочников
    loadGroupsForDropdown();
    loadSubjectsForDropdown();
    loadSpecialtiesForDropdown();

    const createBtn = document.getElementById('createUserBtn');
    if (createBtn) createBtn.replaceWith(createBtn.cloneNode(true)); // Сброс старых листенеров
    document.getElementById('createUserBtn')?.addEventListener('click', openCreateUserModal);

    const search = document.getElementById('usersSearchInput');
    if (search) search.addEventListener('input', filterUsers);

    document.querySelectorAll('[data-users-tab]').forEach(tab => {
        tab.addEventListener('click', () => switchUsersTab(tab.dataset.usersTab));
    });
}

// === ЗАГРУЗЧИКИ ДАННЫХ ===

async function loadGroupsForDropdown() {
    try {
        const res = await fetchWithAuth('groups');
        if (res.ok) usersGroupsCache = await res.json();
    } catch (e) { console.error(e); }
}

async function loadSubjectsForDropdown() {
    try {
        const res = await fetchWithAuth('subjects');
        if (res.ok) usersSubjectsCache = await res.json();
    } catch (e) { console.error(e); }
}

async function loadSpecialtiesForDropdown() {
    try {
        const res = await fetchWithAuth('specialties');
        if (res.ok) usersSpecialtiesCache = await res.json();
    } catch (e) { console.error(e); }
}

async function loadUsers() {
    try {
        const res = await fetchWithAuth('users');
        if (!res.ok) return;
        allUsers = await res.json();
        filterUsers();
    } catch (e) { console.error(e); }
}

// === ТАБЛИЦА ===

function switchUsersTab(tab) {
    currentUsersTab = tab;
    document.querySelectorAll('[data-users-tab]').forEach(t => t.classList.remove('active'));
    document.querySelector(`[data-users-tab="${tab}"]`).classList.add('active');

    // Меняем шапку таблицы
    const thead = document.querySelector('#usersTableBody').closest('table').querySelector('thead tr');
    if (thead) {
        if (tab === 'students') {
            thead.innerHTML = `
                <th>ФИО</th>
                <th>Группа / Спец.</th>
                <th>Контакты</th>
                <th>Статус</th>
                <th>Действия</th>
            `;
        } else {
            thead.innerHTML = `
                <th>ФИО</th>
                <th>Email</th>
                <th>Роль / Должность</th>
                <th>Инфо</th>
                <th>Действия</th>
            `;
        }
    }
    filterUsers();
}

function filterUsers() {
    const term = (document.getElementById('usersSearchInput')?.value || '').toLowerCase();

    const roleMap = {
        'students': 'student',
        'instructors': 'instructor',
        'operators': 'cafeteria_operator' // Операторы и админы могут быть тут
    };

    let targetRole = roleMap[currentUsersTab];

    const filtered = allUsers.filter(u => {
        // Логика фильтрации вкладок
        let roleMatch = false;
        if (currentUsersTab === 'operators') {
            roleMatch = (u.role === 'cafeteria_operator' || u.role === 'admin');
        } else {
            roleMatch = (u.role === targetRole);
        }

        const searchMatch = u.full_name.toLowerCase().includes(term) ||
            u.email.toLowerCase().includes(term) ||
            (u.student_code && u.student_code.toLowerCase().includes(term));

        return roleMatch && searchMatch;
    });

    renderUsersTable(filtered);
}

// УЛУЧШЕННАЯ ФУНКЦИЯ renderUsersTable
function renderUsersTable(users) {
    const tbody = document.getElementById('usersTableBody');
    if (!tbody) return;

    if (!users.length) {
        tbody.innerHTML = '<tr><td colspan="5" class="text-center p-3 text-muted">Никого не найдено</td></tr>';
        return;
    }

    tbody.innerHTML = users.map(u => {
        if (currentUsersTab === 'students') {
            return `
                <tr>
                    <td>
                        <div style="font-weight:500">${u.full_name}</div>
                        <small style="color:#718096">${u.email}</small><br>
                        <small style="color:#a0aec0">ИИН: ${u.iin || '-'}</small>
                    </td>
                    <td>
                        <div>${u.group_name || 'Без группы'}</div>
                        <small style="color:#718096;display:block">${u.specialty_name_kz || u.specialty_name_ru || ''}</small>
                        <small style="color:#a0aec0">Код: ${u.student_code || ''}</small>
                    </td>
                    <td>
                        <div style="font-size:12px">${u.phone || '-'}</div>
                    </td>
                    <td>
                        <span class="badge" style="background:${u.academic_leave ? '#feb2b2' : '#c6f6d5'};color:${u.academic_leave ? '#9b2c2c' : '#22543d'}">
                            ${u.academic_leave ? 'Академ' : 'Активен'}
                        </span>
                    </td>
                    <td>
                        <button class="icon-btn" onclick="editUser(${u.id})"><i class='bx bx-edit'></i></button>
                        <button class="icon-btn delete" onclick="deleteUser(${u.id})"><i class='bx bx-trash'></i></button>
                    </td>
                </tr>
            `;
        } else {
            const detail = u.role === 'instructor'
                ? (u.subjects_str ? `Предметы: ${u.subjects_str.substring(0, 30)}...` : '-')
                : '-';

            return `
                <tr>
                    <td>${u.full_name}</td>
                    <td>${u.email}</td>
                    <td>
                        <div>${roleLabel(u.role)}</div>
                        <small style="color:#718096">${u.position || ''}</small>
                    </td>
                    <td><small>${detail}</small></td>
                    <td>
                        <button class="icon-btn" onclick="editUser(${u.id})"><i class='bx bx-edit'></i></button>
                        <button class="icon-btn delete" onclick="deleteUser(${u.id})"><i class='bx bx-trash'></i></button>
                    </td>
                </tr>
            `;
        }
    }).join('');
}

function roleLabel(role) {
    const map = { 'admin': 'Админ', 'instructor': 'Преподаватель', 'student': 'Студент', 'cafeteria_operator': 'Оператор' };
    return map[role] || role;
}

// === УНИВЕРСАЛЬНАЯ ФУНКЦИЯ ФОРМЫ (CREATE/EDIT) ===

function renderUserForm(data = null) {
    const isEdit = !!data;
    const user = data || {};

    // Генераторы опций
    const makeOpts = (list, selectedId, labelField = 'name') => {
        return `<option value="">Не выбрано</option>` + list.map(item =>
            `<option value="${item.id}" ${item.id == selectedId ? 'selected' : ''}>${item[labelField]}</option>`
        ).join('');
    };

    const groupOpts = makeOpts(usersGroupsCache, user.group_id);
    const specOpts = makeOpts(usersSpecialtiesCache, user.specialty_id, 'name_kz'); // Название спец. на казахском как пример

    // Предметы (чекбоксы)
    const subjCheckboxes = usersSubjectsCache.map(s => {
        const checked = user.subjects && user.subjects.some(sub => sub.id == s.id) ? 'checked' : '';
        return `<label style="display:block;margin-bottom:4px;cursor:pointer">
            <input type="checkbox" name="subject_ids[]" value="${s.id}" ${checked}> ${s.name}
        </label>`;
    }).join('') || '<div class="text-muted">Нет предметов</div>';

    return `
    <form id="userForm" style="padding: 20px;">
        <!-- ВЕРХНЯЯ ЧАСТЬ: ОСНОВНОЕ -->
        <h4 style="margin-top:0">Учетные данные</h4>
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 15px;">
            <input type="text" name="full_name" placeholder="ФИО *" value="${user.full_name || ''}" required class="input">
            <input type="email" name="email" placeholder="Email *" value="${user.email || ''}" required class="input">
            <input type="password" name="password" placeholder="${isEdit ? 'Пароль (пусто = не менять)' : 'Пароль *'}" ${!isEdit ? 'required' : ''} class="input">
            <select name="role" id="roleSelector" class="input">
                <option value="student" ${user.role === 'student' ? 'selected' : ''}>Студент</option>
                <option value="instructor" ${user.role === 'instructor' ? 'selected' : ''}>Преподаватель</option>
                <option value="cafeteria_operator" ${user.role === 'cafeteria_operator' ? 'selected' : ''}>Оператор столовой</option>
                <option value="admin" ${user.role === 'admin' ? 'selected' : ''}>Администратор</option>
            </select>
        </div>

        <!-- СЕКЦИЯ: СОТРУДНИКИ -->
        <div id="sectionStaff" style="display:${user.role !== 'student' ? 'block' : 'none'}; border:1px solid #eee; padding:15px; border-radius:8px;">
            <h4 style="margin-top:0">Служебные данные</h4>
            <div style="margin-bottom:10px;">
                <label>Должность</label>
                <input type="text" name="position" value="${user.position || ''}" class="input" placeholder="Напр: Зам. директора">
            </div>
            
            <!-- Только для преподавателей -->
            <div id="sectionInstructor" style="display:${user.role === 'instructor' ? 'block' : 'none'};">
                <div style="margin: 10px 0;">
                    <label>Кураторство группы</label>
                    <select name="curator_group_id" class="input">${makeOpts(usersGroupsCache, user.curator_group_id)}</select>
                </div>
                <div style="margin-top:10px;">
                    <label>Предметы:</label>
                    <div style="max-height:100px; overflow-y:auto; border:1px solid #ddd; padding:8px; border-radius:4px; margin-top:5px;">
                        ${subjCheckboxes}
                    </div>
                </div>
            </div>
        </div>

        <!-- СЕКЦИЯ: СТУДЕНТЫ (20+ ПОЛЕЙ) -->
        <div id="sectionStudent" style="display:${(!user.role || user.role === 'student') ? 'block' : 'none'}; margin-top:15px;">
            
            <div style="background:#f8f9fa; padding:15px; border-radius:8px; margin-bottom:15px; border:1px solid #e2e8f0;">
                <h4 style="margin:0 0 10px 0; color:#2d3748">Учеба</h4>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                    <div><label>Группа</label><select name="group_id" class="input">${groupOpts}</select></div>
                    <div><label>Специальность</label><select name="specialty_id" class="input">${specOpts}</select></div>
                    <div><label>Форма обучения</label><input type="text" name="education_form" value="${user.education_form || 'Күндізгі'}" class="input"></div>
                    <div><label>Язык обучения</label>
                        <select name="education_language" class="input">
                            <option value="kazakh" ${user.education_language === 'kazakh' ? 'selected' : ''}>Казахский</option>
                            <option value="russian" ${user.education_language === 'russian' ? 'selected' : ''}>Русский</option>
                        </select>
                    </div>
                    <div><label>Финансирование</label>
                        <select name="funding_type" class="input">
                            <option value="budget" ${user.funding_type === 'budget' ? 'selected' : ''}>Бюджет</option>
                            <option value="paid" ${user.funding_type === 'paid' ? 'selected' : ''}>Платное</option>
                        </select>
                    </div>
                    <div><label>Дата зачисления</label><input type="date" name="enrollment_date" value="${user.enrollment_date || ''}" class="input"></div>
                    <div><label>№ Приказа</label><input type="text" name="enrollment_order" value="${user.enrollment_order || ''}" class="input"></div>
                </div>
                <div style="margin-top:10px; display:flex; gap:20px;">
                    <label><input type="checkbox" name="academic_leave" value="1" ${user.academic_leave ? 'checked' : ''}> Академ. отпуск</label>
                    <label><input type="checkbox" name="dual_education" value="1" ${user.dual_education ? 'checked' : ''}> Дуальное</label>
                </div>
            </div>

            <div style="background:#f8f9fa; padding:15px; border-radius:8px; margin-bottom:15px; border:1px solid #e2e8f0;">
                <h4 style="margin:0 0 10px 0; color:#2d3748">Личные данные</h4>
                <div style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap:10px;">
                    <div><label>ИИН</label><input type="text" name="iin" value="${user.iin || ''}" class="input" maxlength="12" pattern="\\d{12}" title="ИИН должен состоять из 12 цифр"></div>
                    <div><label>Дата рождения</label><input type="date" name="date_of_birth" value="${user.date_of_birth || ''}" class="input"></div>
                    <div><label>Пол</label>
                        <select name="gender" class="input">
                            <option value="male" ${user.gender === 'male' ? 'selected' : ''}>Мужской</option>
                            <option value="female" ${user.gender === 'female' ? 'selected' : ''}>Женский</option>
                        </select>
                    </div>
                    <div><label>Нация</label><input type="text" name="nationality" value="${user.nationality || ''}" class="input"></div>
                    <div style="grid-column: span 2;"><label>Гражданство</label><input type="text" name="citizenship" value="${user.citizenship || 'ҚАЗАҚСТАН'}" class="input"></div>
                </div>
            </div>

            <div style="background:#f8f9fa; padding:15px; border-radius:8px; border:1px solid #e2e8f0;">
                <h4 style="margin:0 0 10px 0; color:#2d3748">Контакты</h4>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                    <div><label>Телефон</label><input type="text" name="phone" value="${user.phone || ''}" class="input"></div>
                    <div><label>Город/Село</label><input type="text" name="city" value="${user.city || ''}" class="input"></div>
                    <div style="grid-column: 1/-1;"><label>Полный адрес</label><input type="text" name="address" value="${user.address || ''}" class="input"></div>
                    <div><label>Область</label><input type="text" name="region" value="${user.region || ''}" class="input"></div>
                    <div><label>Район</label><input type="text" name="district" value="${user.district || ''}" class="input"></div>
                </div>
            </div>
        </div>

        <div style="margin-top:20px; display:flex; justify-content:flex-end; gap:10px;">
            <button type="button" class="btn-cancel" style="padding:10px 20px; background:#e2e8f0; border:none; border-radius:5px; cursor:pointer;">Отмена</button>
            <button type="submit" style="padding:10px 20px; background:#3182ce; color:white; border:none; border-radius:5px; cursor:pointer;">Сохранить</button>
        </div>
    </form>`;
}

// === УЛУЧШЕННАЯ ЛОГИКА МОДАЛКИ ===

function setupModalLogic(overlay, userId = null) {
    const form = overlay.querySelector('form');
    const roleSel = overlay.querySelector('#roleSelector');
    const secStudent = overlay.querySelector('#sectionStudent');
    const secStaff = overlay.querySelector('#sectionStaff');
    const secInstr = overlay.querySelector('#sectionInstructor');
    const submitBtn = form.querySelector('[type="submit"]');

    // Закрытие по клику на фон
    overlay.onclick = (e) => {
        if (e.target === overlay) { overlay.remove(); activeUserModal = null; }
    };

    // Переключатель роли
    roleSel.addEventListener('change', () => {
        const r = roleSel.value;
        if (r === 'student') {
            secStudent.style.display = 'block';
            secStaff.style.display = 'none';
        } else {
            secStudent.style.display = 'none';
            secStaff.style.display = 'block';
            secInstr.style.display = (r === 'instructor') ? 'block' : 'none';
        }
    });

    // Кнопка Отмена
    overlay.querySelector('.btn-cancel').onclick = () => { overlay.remove(); activeUserModal = null; };

    // Submit handler
    form.onsubmit = async (e) => {
        e.preventDefault();

        // Индикатор загрузки
        submitBtn.disabled = true;
        submitBtn.textContent = 'Сохранение...';

        const fd = new FormData(e.target);

        // Сбор данных
        const payload = Object.fromEntries(fd.entries());

        // Обработка чекбоксов и списков
        if (payload.role === 'instructor') {
            const boxes = overlay.querySelectorAll('input[name="subject_ids[]"]:checked');
            payload.subject_ids = Array.from(boxes).map(cb => parseInt(cb.value));
        }

        payload.academic_leave = overlay.querySelector('[name="academic_leave"]').checked ? 1 : 0;
        payload.dual_education = overlay.querySelector('[name="dual_education"]').checked ? 1 : 0;

        if (!payload.password) delete payload.password; // Если пусто, не шлём

        try {
            const method = userId ? 'PUT' : 'POST';
            const url = userId ? `users/${userId}` : 'users';

            const r = await fetchWithAuth(url, {
                method: method,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            if (r.ok) {
                showToast(userId ? 'Обновлено!' : 'Создано!', 'success');
                overlay.remove();
                activeUserModal = null;
                loadUsers();
            } else {
                const err = await r.json();
                showToast(err.error || 'Ошибка', 'error');
                submitBtn.disabled = false;
                submitBtn.textContent = 'Сохранить';
            }
        } catch (ex) {
            console.error(ex);
            submitBtn.disabled = false;
            submitBtn.textContent = 'Сохранить';
        }
    };
}

// === EXPORTS ===

window.openCreateUserModal = function () {
    if (activeUserModal) activeUserModal.remove();

    const overlay = document.createElement('div');
    overlay.className = 'dynamic-modal-overlay';
    overlay.style.cssText = `position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9000; display:flex; justify-content:center; align-items:center;`;

    // Вставляем форму создания (пустые данные)
    overlay.innerHTML = `<div style="background:white; width:650px; max-height:90vh; overflow-y:auto; border-radius:8px;">${renderUserForm(null)}</div>`;

    document.body.appendChild(overlay);
    activeUserModal = overlay;

    setupModalLogic(overlay, null);
};

window.editUser = async function (id) {
    try {
        const res = await fetchWithAuth(`users/${id}`);
        if (!res.ok) { showToast('Ошибка загрузки', 'error'); return; }

        const user = await res.json();

        if (activeUserModal) activeUserModal.remove();
        const overlay = document.createElement('div');
        overlay.className = 'dynamic-modal-overlay';
        overlay.style.cssText = `position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9000; display:flex; justify-content:center; align-items:center;`;

        // Вставляем форму редактирования (с данными)
        overlay.innerHTML = `<div style="background:white; width:650px; max-height:90vh; overflow-y:auto; border-radius:8px;">${renderUserForm(user)}</div>`;

        document.body.appendChild(overlay);
        activeUserModal = overlay;

        setupModalLogic(overlay, id);

    } catch (e) { console.error(e); }
};

window.deleteUser = async function (id) {
    if (!confirm('Удалить этого пользователя безвозвратно?')) return;
    try {
        const r = await fetchWithAuth(`users/${id}`, { method: 'DELETE' });
        if (r.ok) {
            showToast('Удалено', 'success');
            loadUsers();
        } else {
            showToast('Ошибка', 'error');
        }
    } catch (e) { console.error(e); }
};
