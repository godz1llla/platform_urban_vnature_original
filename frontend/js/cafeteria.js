// Модуль столовой - FIXED (С фильтрацией списка студентов)

// ============================================================================
// ОПЕРАТОР: ВЫДАЧА (QR)
// ============================================================================

async function initCafeteriaOperator() {
    await displayOperatorQR();
    loadTodayTransactions();

    if (window.cafeteriaTimer) clearInterval(window.cafeteriaTimer);
    window.cafeteriaTimer = setInterval(() => {
        const activeTab = document.querySelector('.tab-btn.active');
        if (activeTab && activeTab.dataset.tab === 'serve') {
            loadTodayTransactions();
        }
    }, 10000);
}

async function displayOperatorQR() {
    try {
        const response = await fetchWithAuth('cafeteria/operator-qr');
        if (!response.ok) return;

        const data = await response.json();
        const canvas = document.getElementById('operatorQrCode');

        if (typeof QRious !== 'undefined' && canvas) {
            new QRious({
                element: canvas,
                value: data.qr_token,
                size: 300,
                level: 'H'
            });
        }
    } catch (e) { console.error('QR error', e); }
}

async function loadTodayTransactions() {
    const tbody = document.getElementById('todayTransactionsTableBody');
    if (!tbody) return;

    try {
        const now = new Date();
        const offset = now.getTimezoneOffset() * 60000;
        const localISOTime = (new Date(now - offset)).toISOString().slice(0, 10);
        const today = localISOTime;

        console.log('Загрузка транзакций за:', today);

        const response = await fetchWithAuth(`cafeteria/transactions&from=${today}&to=${today}`);
        if (!response.ok) return;
        const list = await response.json();

        if (list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" style="text-align:center; padding:15px; color:#888;">Сегодня выдач еще не было</td></tr>';
            return;
        }

        tbody.innerHTML = list.map(t => {
            const dateObj = new Date(t.served_at);
            const timeStr = dateObj.toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' });

            return `
                <tr>
                    <td style="font-weight:bold; color:#2d3748;">${timeStr}</td>
                    <td>
                        <div style="font-weight:500;">${t.student_name}</div>
                        <small style="color:#718096;">${t.student_code}</small>
                    </td>
                    <td>${t.group_name || '-'}</td>
                    <td><span class="badge badge-success" style="background:#c6f6d5; color:#22543d; padding:4px 8px; border-radius:12px; font-size:12px;">${t.category_name}</span></td>
                </tr>
            `;
        }).join('');

    } catch (e) {
        console.error("Ошибка загрузки:", e);
        tbody.innerHTML = '<tr><td colspan="4" style="text-align:center; color:red;">Ошибка загрузки</td></tr>';
    }
}


// ============================================================================
// КАТЕГОРИИ (УПРАВЛЕНИЕ)
// ============================================================================

async function loadCategories() {
    try {
        const response = await fetchWithAuth('cafeteria/categories');
        if (!response.ok) return;

        const list = await response.json();
        const grid = document.getElementById('categoriesGrid');
        if (!grid) return;

        if (!list || list.length === 0) {
            grid.innerHTML = '<div class="text-center text-muted" style="grid-column:1/-1; padding:20px;">Нет категорий. Создайте первую.</div>';
            return;
        }

        grid.innerHTML = list.map(cat => `
            <div class="category-card" style="border:1px solid #e0e0e0; border-radius:10px; padding:20px; background:#fff; position:relative;">
                <div class="d-flex justify-between align-center mb-3">
                    <h4 style="margin:0; font-weight:600; color:#4a5568;">${cat.name}</h4>
                    <div>
                        <button class="icon-btn" onclick="editCategory(${cat.id})" style="color:#4299e1"><i class='bx bx-edit'></i></button>
                        <button class="icon-btn delete" onclick="deleteCategory(${cat.id})" style="color:#f56565"><i class='bx bx-trash'></i></button>
                    </div>
                </div>
                <div class="stats-grid" style="display:grid; grid-template-columns:repeat(3, 1fr); gap:10px; font-size:0.85rem; text-align:center;">
                    <div style="background:#f7fafc; padding:8px; border-radius:5px;">
                        <div style="color:#718096">День</div>
                        <div style="font-weight:bold; font-size:1rem;">${cat.daily_limit}</div>
                    </div>
                    <div style="background:#f7fafc; padding:8px; border-radius:5px;">
                        <div style="color:#718096">Неделя</div>
                        <div style="font-weight:bold; font-size:1rem;">${cat.weekly_limit}</div>
                    </div>
                    <div style="background:#f7fafc; padding:8px; border-radius:5px;">
                        <div style="color:#718096">Месяц</div>
                        <div style="font-weight:bold; font-size:1rem;">${cat.monthly_limit}</div>
                    </div>
                </div>
                <div style="margin-top:15px; padding-top:10px; border-top:1px solid #f0f0f0; display:flex; justify-content:space-between; align-items:center;">
                    <small style="color:#a0aec0">Цена</small>
                    <div style="font-weight:bold; color:#38a169;">${parseFloat(cat.price_per_portion || 0).toFixed(2)} ₸</div>
                </div>
            </div>
        `).join('');
    } catch (e) { console.error(e); }
}

window.editCategory = async function (id) {
    try {
        const response = await fetchWithAuth('cafeteria/categories');
        const categories = await response.json();
        const category = categories.find(c => c.id == id);
        if (category) openCategoryModal(category);
    } catch (e) { console.error(e); }
};

window.deleteCategory = async function (id) {
    if (!confirm('Удалить категорию?')) return;
    try {
        const res = await fetchWithAuth(`cafeteria/categories/${id}`, { method: 'DELETE' });
        const data = await res.json();
        if (!res.ok || data.success === false) {
            showToast(data.error || 'Нельзя удалить: категория используется', 'error');
        } else {
            showToast('Удалено успешно', 'success');
            loadCategories();
        }
    } catch (e) { showToast('Ошибка удаления', 'error'); }
};

window.openCategoryModal = function (catData = null) {
    const old = document.querySelectorAll('#catModalOverlay');
    old.forEach(el => el.remove());

    const isEdit = !!catData;
    const vals = catData || {};

    const overlay = document.createElement('div');
    overlay.id = 'catModalOverlay';
    overlay.style.cssText = `position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:9999;display:flex;justify-content:center;align-items:center;backdrop-filter:blur(3px);`;

    overlay.innerHTML = `
        <div style="background:white;width:90%;max-width:400px;border-radius:12px;padding:25px;box-shadow:0 10px 40px rgba(0,0,0,0.2);">
            <div style="display:flex;justify-content:space-between;margin-bottom:20px;">
                <h3 style="margin:0;">${isEdit ? 'Редактировать' : 'Новая'} категория</h3>
                <span class="close-x" style="cursor:pointer;font-size:20px;">&times;</span>
            </div>
            <form id="activeCategoryForm" style="display:flex;flex-direction:column;gap:15px;">
                <div>
                    <label style="font-size:12px;color:#666;">Название</label>
                    <input type="text" name="name" value="${vals.name || ''}" required style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;">
                </div>
                <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:10px;">
                    <div><label style="font-size:11px;">День</label><input type="number" name="d" value="${vals.daily_limit || 1}" required style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;"></div>
                    <div><label style="font-size:11px;">Неделя</label><input type="number" name="w" value="${vals.weekly_limit || 5}" required style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;"></div>
                    <div><label style="font-size:11px;">Месяц</label><input type="number" name="m" value="${vals.monthly_limit || 20}" required style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;"></div>
                </div>
                <div>
                    <label style="font-size:12px;color:#666;">Цена за порцию (₸)</label>
                    <input type="number" name="p" value="${vals.price_per_portion || 0}" step="0.01" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;">
                </div>
                <div style="display:flex;justify-content:flex-end;gap:10px;margin-top:10px;">
                    <button type="button" class="btn-cancel" style="padding:10px 20px;border:none;background:#f0f0f0;border-radius:6px;cursor:pointer;">Отмена</button>
                    <button type="submit" style="padding:10px 20px;border:none;background:#5a67d8;color:white;border-radius:6px;cursor:pointer;">Сохранить</button>
                </div>
            </form>
        </div>
    `;

    document.body.appendChild(overlay);

    const form = overlay.querySelector('form');
    const closeMe = () => overlay.remove();

    overlay.querySelector('.close-x').onclick = closeMe;
    overlay.querySelector('.btn-cancel').onclick = closeMe;

    form.onsubmit = async (e) => {
        e.preventDefault();
        const payload = {
            name: form.querySelector('[name="name"]').value,
            daily_limit: form.querySelector('[name="d"]').value,
            weekly_limit: form.querySelector('[name="w"]').value,
            monthly_limit: form.querySelector('[name="m"]').value,
            price_per_portion: form.querySelector('[name="p"]').value
        };

        try {
            const url = isEdit ? `cafeteria/categories/${catData.id}` : 'cafeteria/categories';
            const method = isEdit ? 'PUT' : 'POST';
            const r = await fetchWithAuth(url, {
                method: method,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            if (!r.ok) {
                const err = await r.json();
                showToast(err.error || 'Ошибка', 'error');
            } else {
                showToast('Сохранено!', 'success');
                closeMe();
                loadCategories();
            }
        } catch (e) { console.error(e); }
    };
};

// ============================================================================
// НАЗНАЧЕНИЯ
// ============================================================================

async function loadAssignments() {
    try {
        const response = await fetchWithAuth('cafeteria/assignments');
        if (!response.ok) return;

        const list = await response.json();
        const tbody = document.getElementById('assignmentsTableBody');

        if (!list.length) {
            tbody.innerHTML = '<tr><td colspan="6" class="text-center p-3 text-muted">Список пуст</td></tr>';
            return;
        }

        tbody.innerHTML = list.map(a => `
            <tr>
                <td>${a.student_code}</td>
                <td>${a.student_name}</td>
                <td>${a.group_name || '-'}</td>
                <td><span class="badge badge-primary">${a.category_name}</span></td>
                <td>${new Date(a.assigned_at).toLocaleDateString()}</td>
                <td>
                    <button class="icon-btn delete" onclick="unassignStudent(${a.student_id})" title="Удалить">
                        <i class='bx bx-trash'></i>
                    </button>
                </td>
            </tr>
        `).join('');

    } catch (e) { console.error(e); }
}

window.unassignStudent = async function (id) {
    if (!confirm('Снять назначение с этого студента?')) return;
    try {
        const res = await fetchWithAuth(`cafeteria/assign/${id}`, { method: 'DELETE' });
        if (res.ok) {
            showToast('Успешно удалено', 'success');
            loadAssignments();
        } else {
            showToast('Ошибка при удалении', 'error');
        }
    } catch (e) { console.error(e); }
};

// МОДАЛКА НАЗНАЧЕНИЯ (ИСПРАВЛЕНО: ТОЛЬКО СВОБОДНЫЕ СТУДЕНТЫ)
window.openAssignModal = function () {
    const overlay = document.createElement('div');
    overlay.style.cssText = `position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:9999;display:flex;justify-content:center;align-items:center;backdrop-filter:blur(3px);`;

    overlay.innerHTML = `
        <div style="background:white;width:90%;max-width:350px;border-radius:10px;padding:25px;">
            <h3 style="margin-top:0;">Назначить</h3>
            <select id="asStudent" style="width:100%;padding:10px;margin-bottom:10px;border-radius:6px;border:1px solid #ddd;">
                <option>Загрузка студентов...</option>
            </select>
            <select id="asCategory" style="width:100%;padding:10px;margin-bottom:20px;border-radius:6px;border:1px solid #ddd;">
                <option>Загрузка категорий...</option>
            </select>
            <div style="display:flex;justify-content:flex-end;gap:10px;">
                <button id="asClose" style="padding:8px 15px;background:#eee;border:none;border-radius:5px;cursor:pointer;">Отмена</button>
                <button id="asSave" style="padding:8px 15px;background:#5a67d8;color:white;border:none;border-radius:5px;cursor:pointer;">OK</button>
            </div>
        </div>
    `;
    document.body.appendChild(overlay);

    // Загрузка списков
    Promise.all([
        // ИСПРАВЛЕНИЕ: Загружаем ТОЛЬКО свободных студентов
        fetchWithAuth('cafeteria/assignments/unassigned').then(r => r.json()),
        fetchWithAuth('cafeteria/categories').then(r => r.json())
    ]).then(([students, cats]) => {

        // Больше не нужно фильтровать .filter(u => u.role === 'student'), сервер уже отдал нужных

        if (students.length === 0) {
            overlay.querySelector('#asStudent').innerHTML = '<option value="">Нет свободных студентов</option>';
            overlay.querySelector('#asStudent').disabled = true;
        } else {
            overlay.querySelector('#asStudent').innerHTML = '<option value="">Выберите студента</option>' +
                students.map(s => `<option value="${s.id}">${s.full_name} (${s.email})</option>`).join('');
        }

        overlay.querySelector('#asCategory').innerHTML = '<option value="">Выберите льготу</option>' +
            cats.map(c => `<option value="${c.id}">${c.name}</option>`).join('');
    });

    overlay.querySelector('#asClose').onclick = () => overlay.remove();

    overlay.querySelector('#asSave').onclick = async () => {
        const sid = overlay.querySelector('#asStudent').value;
        const cid = overlay.querySelector('#asCategory').value;

        if (!sid || !cid) { showToast('Заполните все поля', 'error'); return; }

        try {
            const r = await fetchWithAuth('cafeteria/assign', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ student_id: sid, category_id: cid })
            });
            if (r.ok) {
                showToast('Назначено!', 'success');
                overlay.remove();
                loadAssignments();
            } else {
                const err = await r.json();
                showToast(err.error || 'Ошибка', 'error');
            }
        } catch (e) { console.error(e); }
    };
};


// ============================================================================
// ИСТОРИЯ
// ============================================================================

window.loadHistory = async function () {
    const tBody = document.getElementById('historyTableBody');
    if (tBody) tBody.innerHTML = '<tr><td colspan="4" class="text-center p-3">Загрузка...</td></tr>';

    try {
        const dateFrom = document.getElementById('filterFrom')?.value;
        const dateTo = document.getElementById('filterTo')?.value;

        let path = 'cafeteria/transactions';
        let params = [];
        if (dateFrom) params.push(`from=${dateFrom}`);
        if (dateTo) params.push(`to=${dateTo}`);
        params.push('limit=500');

        const urlWithParams = path + '&' + params.join('&');

        const res = await fetchWithAuth(urlWithParams);
        if (!res.ok) throw new Error('Failed');

        const list = await res.json();

        if (!list.length) {
            tBody.innerHTML = '<tr><td colspan="4" class="text-center p-3 text-muted">Записей не найдено</td></tr>';
            return;
        }

        tBody.innerHTML = list.map(t => `
            <tr>
                <td>${new Date(t.served_at).toLocaleString()}</td>
                <td>${t.student_name} <br> <small class="text-muted">${t.group_name || ''}</small></td>
                <td><span class="badge badge-success">${t.category_name}</span></td>
                <td>${t.operator_name || '-'}</td>
            </tr>
        `).join('');

    } catch (e) {
        if (tBody) tBody.innerHTML = '<tr><td colspan="4" class="text-center text-danger">Ошибка загрузки</td></tr>';
    }
};

window.exportHistory = function () {
    alert("Функция экспорта в разработке");
};


// ============================================================================
// ИНИЦИАЛИЗАЦИЯ
// ============================================================================

document.addEventListener('DOMContentLoaded', () => {
    const tabs = document.querySelectorAll('.tab-btn[data-tab]');
    tabs.forEach(btn => {
        btn.addEventListener('click', (e) => {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));

            e.target.classList.add('active');
            const target = document.getElementById('tab-' + e.target.dataset.tab);
            if (target) target.classList.add('active');

            const tabName = e.target.dataset.tab;
            if (tabName === 'categories') loadCategories();
            if (tabName === 'assignments') loadAssignments();
            if (tabName === 'history') loadHistory();
            if (tabName === 'serve') initCafeteriaOperator();
        });
    });

    const bindClick = (id, fn) => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('click', fn);
    };

    bindClick('addCategoryBtn', () => openCategoryModal(null));
    bindClick('assignStudentBtn', () => openAssignModal());
    bindClick('applyFiltersBtn', loadHistory);

    loadCategories();
});
