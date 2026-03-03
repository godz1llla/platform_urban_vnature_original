// Модуль домашних заданий

function initHomeworkModule() {
    console.log('✅ initHomeworkModule вызван');
    const user = JSON.parse(localStorage.getItem('user'));

    // Показываем кнопку создания для преподавателей и админов
    const actionHeader = document.getElementById('homeworkActionHeader');
    if (actionHeader && (user.role === 'admin' || user.role === 'instructor')) {
        actionHeader.style.display = 'block';
        document.getElementById('addHomeworkBtn').onclick = openCreateHomeworkModal;
    }

    loadHomework();
}

async function loadHomework() {
    const list = document.getElementById('homeworkList');
    list.innerHTML = '<div class="loader-container"><div class="loader"></div></div>';

    try {
        const response = await fetchWithAuth('homework');
        if (!response.ok) {
            list.innerHTML = '<p class="error-msg">Ошибка загрузки заданий</p>';
            return;
        }

        const homeworks = await response.json();
        displayHomework(homeworks);
    } catch (error) {
        console.error('Error loading homework:', error);
    }
}

function displayHomework(homeworks) {
    const list = document.getElementById('homeworkList');
    const user = JSON.parse(localStorage.getItem('user'));

    if (homeworks.length === 0) {
        list.innerHTML = '<div class="card" style="grid-column: 1/-1; text-align: center; padding: 40px;">' +
            '<i class="bx bx-info-circle" style="font-size: 48px; color: var(--grey); margin-bottom: 15px;"></i>' +
            '<p>Заданий пока нет</p></div>';
        return;
    }

    list.innerHTML = homeworks.map(hw => `
        <div class="card homework-card">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
                <span class="badge" style="background: var(--light-blue); color: var(--blue); font-size: 12px;">${hw.subject_name}</span>
                ${(user.role === 'admin' || hw.instructor_id == user.user_id) ?
            `<button class="btn btn-sm btn-danger" onclick="deleteHomework(${hw.id})"><i class="bx bx-trash"></i></button>` : ''}
            </div>
            <h3 style="margin-bottom: 10px;">${hw.title}</h3>
            <p style="color: var(--grey); font-size: 14px; margin-bottom: 15px; line-height: 1.5;">${hw.description || 'Нет описания'}</p>
            <div style="border-top: 1px solid #eee; padding-top: 15px; margin-top: auto; display: flex; justify-content: space-between; font-size: 13px;">
                <span><i class="bx bx-user"></i> ${hw.instructor_name}</span>
                <span style="color: ${isOverdue(hw.due_date) ? 'var(--error)' : 'var(--grey)'}">
                    <i class="bx bx-calendar"></i> Срок: ${formatDate(hw.due_date)}
                </span>
            </div>
        </div>
    `).join('');
}

function isOverdue(dateStr) {
    if (!dateStr) return false;
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    return new Date(dateStr) < today;
}

function formatDate(dateStr) {
    if (!dateStr) return 'Не указан';
    return new Date(dateStr).toLocaleDateString('ru-RU');
}

async function openCreateHomeworkModal() {
    // Используем динамическое создание модалки как в subjects.js
    const subjects = await (await fetchWithAuth('subjects')).json();
    const groups = await (await fetchWithAuth('groups')).json();

    const overlay = document.createElement('div');
    overlay.className = 'dynamic-modal-overlay';
    overlay.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.8);z-index:999999;display:flex;justify-content:center;align-items:center;';

    const modal = document.createElement('div');
    modal.style.cssText = 'background:white;border-radius:12px;width:95%;max-width:500px;box-shadow:0 10px 40px rgba(0,0,0,0.5);max-height:90vh;overflow-y:auto;';

    modal.innerHTML = `
        <div style="padding:20px;border-bottom:1px solid #eee;display:flex;justify-content:space-between;align-items:center;">
            <h3 style="margin:0;">Создать домашнее задание</h3>
            <button onclick="this.closest('.dynamic-modal-overlay').remove()" style="background:none;border:none;font-size:24px;cursor:pointer;">&times;</button>
        </div>
        <form id="createHomeworkForm" style="padding:20px;">
            <div class="form-group" style="margin-bottom:15px;">
                <label style="display:block;margin-bottom:5px;">Предмет *</label>
                <select id="hwSubject" class="input" required style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;">
                    <option value="">Выберите предмет...</option>
                    ${subjects.map(s => `<option value="${s.id}">${s.name}</option>`).join('')}
                </select>
            </div>
            <div class="form-group" style="margin-bottom:15px;">
                <label style="display:block;margin-bottom:5px;">Группа *</label>
                <select id="hwGroup" class="input" required style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;">
                    <option value="">Выберите группу...</option>
                    ${groups.map(g => `<option value="${g.id}">${g.name}</option>`).join('')}
                </select>
            </div>
            <div class="form-group" style="margin-bottom:15px;">
                <label style="display:block;margin-bottom:5px;">Тема/Заголовок *</label>
                <input type="text" id="hwTitle" class="input" required style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;">
            </div>
            <div class="form-group" style="margin-bottom:15px;">
                <label style="display:block;margin-bottom:5px;">Описание</label>
                <textarea id="hwDesc" class="input" rows="4" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;"></textarea>
            </div>
            <div class="form-group" style="margin-bottom:20px;">
                <label style="display:block;margin-bottom:5px;">Срок сдачи</label>
                <input type="date" id="hwDueDate" class="input" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;">
            </div>
            <div style="display:flex;gap:10px;justify-content:flex-end;">
                <button type="button" onclick="this.closest('.dynamic-modal-overlay').remove()" class="btn btn-secondary">Отмена</button>
                <button type="submit" class="btn btn-primary">Опубликовать</button>
            </div>
        </form>
    `;

    overlay.appendChild(modal);
    document.body.appendChild(overlay);

    document.getElementById('createHomeworkForm').onsubmit = async (e) => {
        e.preventDefault();
        const data = {
            subject_id: document.getElementById('hwSubject').value,
            group_id: document.getElementById('hwGroup').value,
            title: document.getElementById('hwTitle').value,
            description: document.getElementById('hwDesc').value,
            due_date: document.getElementById('hwDueDate').value
        };

        try {
            const res = await fetchWithAuth('homework', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });

            if (res.ok) {
                showToast('Задание успешно создано!', 'success');
                overlay.remove();
                loadHomework();
            } else {
                const err = await res.json();
                showToast(err.error || 'Ошибка при создании', 'error');
            }
        } catch (error) {
            console.error(error);
            showToast('Серверная ошибка', 'error');
        }
    };
}

async function deleteHomework(id) {
    if (!confirm('Вы уверены, что хотите удалить это задание?')) return;

    try {
        const res = await fetchWithAuth(`homework/${id}`, { method: 'DELETE' });
        if (res.ok) {
            showToast('Задание удалено', 'success');
            loadHomework();
        } else {
            showToast('Ошибка при удалении', 'error');
        }
    } catch (error) { console.error(error); }
}
