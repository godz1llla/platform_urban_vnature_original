// groups.js - ИСПРАВЛЕННЫЙ

// Защита от повторного объявления (если users.js уже объявил)
if (typeof allGroups === 'undefined') {
    var allGroups = [];
}
var activeGroupModal = null;
var currentGroupContext = null;

// ============================================================================
// ИНИЦИАЛИЗАЦИЯ
// ============================================================================

function initGroupsModule() {
    console.log('✅ Groups Module Loaded');
    loadGroups();
    // Привязку кнопок делаем через глобальное делегирование (см. конец файла)
    // чтобы точно работало при любой загрузке
}

async function loadGroups() {
    try {
        const response = await fetchWithAuth('groups');
        if (!response.ok) {
            // Если ошибка 401, она обработается в utils.js
            return;
        }
        allGroups = await response.json();
        renderGroupsTable(allGroups);
    } catch (e) { console.error(e); }
}

function renderGroupsTable(list) {
    const tbody = document.getElementById('groupsTableBody');
    if (!tbody) return;

    if (!list || list.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" class="text-center p-3 text-muted">Групп пока нет</td></tr>';
        return;
    }

    tbody.innerHTML = list.map(g => `
        <tr>
            <td>${g.name}</td>
            <td>${g.course} курс</td>
            <td>${g.student_count || 0}</td>
            <td>
                <button class="icon-btn btn-primary" onclick="openGroupStudents(${g.id}, '${g.name}')" title="Студенты">
                    <i class='bx bx-user-check'></i>
                </button>
                <button class="icon-btn btn-secondary" onclick="editGroup(${g.id})" title="Редактировать">
                    <i class='bx bx-edit'></i>
                </button>
                <button class="icon-btn delete" onclick="deleteGroup(${g.id}, '${g.name}')" title="Удалить">
                    <i class='bx bx-trash'></i>
                </button>
            </td>
        </tr>
    `).join('');
}

// ============================================================================
// СОЗДАНИЕ ГРУППЫ (CREATE)
// ============================================================================

window.openCreateGroupModal = function () {
    const overlay = createCleanModal();

    overlay.innerHTML = `
        <div style="background:white;width:350px;padding:25px;border-radius:12px;box-shadow:0 10px 40px rgba(0,0,0,0.3);">
            <h3 style="margin-top:0;">Новая группа</h3>
            <form id="createGroupFormInner" style="display:flex;flex-direction:column;gap:15px;">
                <input type="text" name="name" placeholder="Название (например: ИС-1-21)" required style="padding:10px;border:1px solid #ddd;border-radius:6px;">
                <select name="course" required style="padding:10px;border:1px solid #ddd;border-radius:6px;">
                    <option value="1">1 курс</option>
                    <option value="2">2 курс</option>
                    <option value="3">3 курс</option>
                    <option value="4">4 курс</option>
                </select>
                <div style="display:flex;justify-content:flex-end;gap:10px;margin-top:10px;">
                    <button type="button" class="btn-close" style="padding:8px 15px;background:#eee;border:none;border-radius:5px;cursor:pointer;">Отмена</button>
                    <button type="submit" style="padding:8px 15px;background:#5a67d8;color:white;border:none;border-radius:5px;cursor:pointer;">Создать</button>
                </div>
            </form>
        </div>
    `;
    document.body.appendChild(overlay);

    overlay.querySelector('.btn-close').onclick = () => overlay.remove();

    overlay.querySelector('form').onsubmit = async (e) => {
        e.preventDefault();
        // Собираем данные формы
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData.entries());

        try {
            const r = await fetchWithAuth('groups', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });

            if (r.ok) {
                showToast('Группа успешно создана', 'success');
                overlay.remove();
                loadGroups();
            } else {
                const err = await r.json();
                showToast(err.error || 'Ошибка при создании', 'error');
            }
        } catch (ex) { console.error(ex); }
    };
};

// ============================================================================
// РЕДАКТИРОВАНИЕ (UPDATE)
// ============================================================================

window.editGroup = function (id) {
    // Находим группу в локальном списке
    const group = allGroups.find(g => g.id == id);
    if (!group) return showToast('Ошибка: данные группы не найдены', 'error');

    const overlay = createCleanModal();

    overlay.innerHTML = `
        <div style="background:white;width:350px;padding:25px;border-radius:12px;box-shadow:0 10px 40px rgba(0,0,0,0.3);">
            <h3>Редактировать группу</h3>
            <form style="display:flex;flex-direction:column;gap:15px;">
                <input type="text" name="name" value="${group.name}" required style="padding:10px;border:1px solid #ddd;border-radius:6px;">
                <select name="course" required style="padding:10px;border:1px solid #ddd;border-radius:6px;">
                    <option value="1" ${group.course == 1 ? 'selected' : ''}>1 курс</option>
                    <option value="2" ${group.course == 2 ? 'selected' : ''}>2 курс</option>
                    <option value="3" ${group.course == 3 ? 'selected' : ''}>3 курс</option>
                    <option value="4" ${group.course == 4 ? 'selected' : ''}>4 курс</option>
                </select>
                <div style="display:flex;justify-content:flex-end;gap:10px;margin-top:10px;">
                    <button type="button" class="btn-close" style="padding:8px 15px;background:#eee;border:none;border-radius:5px;cursor:pointer;">Отмена</button>
                    <button type="submit" style="padding:8px 15px;background:#5a67d8;color:white;border:none;border-radius:5px;cursor:pointer;">Сохранить</button>
                </div>
            </form>
        </div>
    `;
    document.body.appendChild(overlay);

    overlay.querySelector('.btn-close').onclick = () => overlay.remove();

    overlay.querySelector('form').onsubmit = async (e) => {
        e.preventDefault();
        const data = Object.fromEntries(new FormData(e.target));

        try {
            const r = await fetchWithAuth(`groups/${id}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });
            if (r.ok) {
                showToast('Группа обновлена', 'success');
                overlay.remove();
                loadGroups();
            } else {
                const err = await r.json();
                showToast(err.error || 'Ошибка', 'error');
            }
        } catch (ex) { console.error(ex); }
    };
};

// ============================================================================
// УДАЛЕНИЕ (DELETE)
// ============================================================================

window.deleteGroup = async function (id, name) {
    if (!confirm(`Вы уверены, что хотите удалить группу "${name}"?\nВсе студенты в ней потеряют привязку.`)) return;

    try {
        const r = await fetchWithAuth(`groups/${id}`, { method: 'DELETE' });
        const d = await r.json();

        if (!r.ok || d.success === false) {
            showToast(d.error || 'Ошибка удаления', 'error');
        } else {
            showToast('Группа удалена', 'success');
            loadGroups();
        }
    } catch (e) { console.error(e); }
};

// ============================================================================
// СПИСОК СТУДЕНТОВ ГРУППЫ (LOGIC)
// ============================================================================

window.openGroupStudents = async function (groupId, groupName) {
    currentGroupContext = groupId;
    const overlay = createCleanModal();

    // Верстка для модалки списка
    overlay.innerHTML = `
        <div style="background:white;width:550px;max-height:85vh;display:flex;flex-direction:column;border-radius:12px;box-shadow:0 10px 40px rgba(0,0,0,0.3);">
            <div style="padding:20px;border-bottom:1px solid #eee;display:flex;justify-content:space-between;align-items:center;">
                <h3 style="margin:0;">Студенты: ${groupName}</h3>
                <span class="close-x" style="cursor:pointer;font-size:24px;">&times;</span>
            </div>
            
            <div style="padding:15px;background:#f8f9fa;border-bottom:1px solid #eee;display:flex;gap:10px;">
                <select id="grpAddSelect" style="flex:1;padding:8px;border-radius:5px;border:1px solid #ddd;">
                    <option>Загрузка студентов...</option>
                </select>
                <button id="grpAddBtn" style="padding:8px 15px;background:#48bb78;color:white;border:none;border-radius:5px;">Добавить</button>
            </div>

            <div style="flex:1;overflow-y:auto;padding:0;">
                <table style="width:100%;border-collapse:collapse;">
                    <tbody id="grpStudentsTable">
                        <tr><td style="text-align:center;padding:20px;">Загрузка списка...</td></tr>
                    </tbody>
                </table>
            </div>
            <div style="padding:15px;text-align:right;border-top:1px solid #eee;">
                <button class="btn-close" style="padding:8px 20px;background:#718096;color:white;border:none;border-radius:5px;">Закрыть</button>
            </div>
        </div>
    `;
    document.body.appendChild(overlay);

    const closeMe = () => { overlay.remove(); currentGroupContext = null; loadGroups(); };
    overlay.querySelectorAll('.close-x, .btn-close').forEach(el => el.onclick = closeMe);

    // Логика загрузки
    await updateGroupStudentsList(groupId);
    updateFreeStudentsList(overlay);

    // Обработка кнопки добавления
    overlay.querySelector('#grpAddBtn').onclick = async () => {
        const studId = overlay.querySelector('#grpAddSelect').value;
        if (!studId) return showToast('Выберите студента из списка', 'error');

        try {
            const r = await fetchWithAuth(`groups/${groupId}/add-student`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ student_id: studId })
            });
            if (r.ok) {
                showToast('Добавлен!', 'success');
                await updateGroupStudentsList(groupId);
                updateFreeStudentsList(overlay); // Обновить список свободных
            } else {
                showToast('Ошибка добавления', 'error');
            }
        } catch (e) { }
    };
};

async function updateGroupStudentsList(groupId) {
    const tbody = document.getElementById('grpStudentsTable');
    if (!tbody) return;

    try {
        const r = await fetchWithAuth(`groups/${groupId}/students`);
        if (!r.ok) return;
        const list = await r.json();

        if (list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="2" style="text-align:center;padding:20px;color:#888;">Пусто</td></tr>';
            return;
        }

        tbody.innerHTML = list.map(s => `
            <tr style="border-bottom:1px solid #f0f0f0;">
                <td style="padding:12px 20px;">
                    <strong>${s.full_name}</strong>
                    <div style="font-size:12px;color:#666;">${s.student_code || '--'}</div>
                </td>
                <td style="padding:12px 20px;text-align:right;">
                    <button onclick="removeStud(${s.id}, ${groupId})" style="border:none;background:transparent;color:#f56565;cursor:pointer;">
                        <i class='bx bx-trash' style="font-size:18px;"></i>
                    </button>
                </td>
            </tr>
        `).join('');
    } catch (e) { }
}

async function updateFreeStudentsList(overlay) {
    // Получаем студентов, у которых НЕТ группы
    try {
        const r = await fetchWithAuth('users?role=student');
        if (!r.ok) return;
        const all = await r.json();
        const free = all.filter(u => u.role === 'student' && !u.group_name && !u.group_id); // Фильтр свободных

        const sel = overlay.querySelector('#grpAddSelect');
        if (free.length === 0) {
            sel.innerHTML = '<option value="">Нет свободных студентов</option>';
            sel.disabled = true;
        } else {
            sel.innerHTML = '<option value="">Выберите студента...</option>' +
                free.map(u => `<option value="${u.id}">${u.full_name}</option>`).join('');
            sel.disabled = false;
        }
    } catch (e) { }
}

window.removeStud = async function (sid, gid) {
    if (!confirm('Убрать из группы?')) return;
    try {
        const r = await fetchWithAuth(`groups/${gid}/remove-student`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ student_id: sid })
        });
        if (r.ok) {
            updateGroupStudentsList(gid);
            // Нужно обновить селект свободных в активном оверлее
            const overlay = document.querySelector('.dynamic-modal-overlay'); // Грязный хак, но работает для одного модального окна
            if (overlay) updateFreeStudentsList(overlay);
        }
    } catch (e) { }
};

// ============================================================================
// УТИЛИТА: ЧИСТАЯ МОДАЛКА
// ============================================================================
function createCleanModal() {
    const old = document.querySelectorAll('.dynamic-modal-overlay');
    old.forEach(el => el.remove());

    const div = document.createElement('div');
    div.className = 'dynamic-modal-overlay';
    div.style.cssText = `
        position:fixed; top:0; left:0; width:100%; height:100%;
        background:rgba(0,0,0,0.5); z-index:9999;
        display:flex; justify-content:center; align-items:center;
        backdrop-filter:blur(2px); animation: fadeIn 0.2s;
    `;
    div.onclick = (e) => {
        if (e.target === div) div.remove();
    };
    return div;
}

// ============================================================================
// AUTO-START
// ============================================================================

document.addEventListener('DOMContentLoaded', () => {
    // 1. Инициализируем модуль
    initGroupsModule();

    // 2. ГЛОБАЛЬНЫЙ ОБРАБОТЧИК КЛИКОВ (ЖЕЛЕЗОБЕТОННО)
    // Это решит проблему, даже если скрипт загрузится раньше HTML кнопки
    document.body.addEventListener('click', function (e) {
        // Ищем клик по кнопке с ID createGroupBtn
        // или по иконке внутри этой кнопки
        const target = e.target.closest('#createGroupBtn');
        if (target) {
            e.preventDefault(); // На случай если это ссылка или form submit
            openCreateGroupModal();
        }
    });
});
