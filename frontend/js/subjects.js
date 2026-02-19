// Модуль управления предметами с программными модалками

let allSubjects = [];
let currentSubject = null;
let activeSubjectModal = null;

function initSubjectsModule() {
    console.log('✅ initSubjectsModule вызван');
    loadSubjects();

    const createBtn = document.getElementById('createSubjectBtn');
    if (createBtn) {
        createBtn.addEventListener('click', openCreateSubjectModal);
    }
}

async function loadSubjects() {
    try {
        const response = await fetchWithAuth('subjects');
        if (!response.ok) {
            showToast('Ошибка загрузки предметов', 'error');
            return;
        }

        allSubjects = await response.json();
        displaySubjects(allSubjects);
    } catch (error) {
        console.error('Error loading subjects:', error);
        showToast('Ошибка загрузки предметов', 'error');
    }
}

function displaySubjects(subjects) {
    const tbody = document.getElementById('subjectsTableBody');

    if (subjects.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" style="text-align: center;">Предметов пока нет</td></tr>';
        return;
    }

    tbody.innerHTML = subjects.map(s => `
        <tr>
            <td data-label="Название">${escapeHtml(s.name)}</td>
            <td data-label="Описание">${s.description || '-'}</td>
            <td data-label="Преподавателей">${s.instructor_count}</td>
            <td data-label="Действия">
                <button class="btn btn-sm btn-primary" onclick="openSubjectInstructors(${s.id}, '${escapeHtml(s.name)}')">
                    <i class='bx bx-user-check'></i> Преподаватели
                </button>
                <button class="btn btn-sm btn-secondary" onclick="editSubject(${s.id})">
                    <i class='bx bx-edit'></i>
                </button>
                <button class="btn btn-sm btn-danger" onclick="deleteSubject(${s.id}, '${escapeHtml(s.name)}')">
                    <i class='bx bx-trash'></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// ============================================================================
// ПРОГРАММНОЕ СОЗДАНИЕ МОДАЛОК
// ============================================================================

function openCreateSubjectModal() {
    if (activeSubjectModal) document.body.removeChild(activeSubjectModal);

    const overlay = document.createElement('div');
    overlay.className = 'dynamic-modal-overlay'; // Добавляем класс для совместимости
    overlay.style.cssText = `
        position: fixed; top: 0; left: 0;
        width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.8);
        z-index: 999999; display: flex;
        justify-content: center; align-items: center;
    `;

    const modal = document.createElement('div');
    modal.style.cssText = `
        background: white; border-radius: 12px;
        width: 90%; max-width: 500px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
    `;

    modal.innerHTML = `
        <div style="padding: 20px; border-bottom: 1px solid #eee;">
            <h3 style="margin: 0;">Создать предмет</h3>
        </div>
        <form id="dynSubjectForm" style="padding: 20px;">
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Название *</label>
                <input type="text" id="dynSubjectName" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;">
            </div>
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Описание</label>
                <textarea id="dynSubjectDesc" rows="3" style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;"></textarea>
            </div>
            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <button type="button" onclick="closeDynamicModal()" style="padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 6px; cursor: pointer;">Отмена</button>
                <button type="submit" style="padding: 10px 20px; background: #E12553; color: white; border: none; border-radius: 6px; cursor: pointer;">Создать</button>
            </div>
        </form>
    `;

    overlay.appendChild(modal);
    document.body.appendChild(overlay);
    activeSubjectModal = overlay;

    document.getElementById('dynSubjectForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const data = {
            name: document.getElementById('dynSubjectName').value,
            description: document.getElementById('dynSubjectDesc').value
        };

        try {
            const response = await fetchWithAuth('subjects', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });

            if (!response.ok) {
                const error = await response.json();
                showToast(error.error || 'Ошибка', 'error');
                return;
            }

            showToast('Предмет создан!', 'success');
            closeDynamicModal();
            loadSubjects();
        } catch (error) { console.error('Error:', error); }
    });

    overlay.addEventListener('click', (e) => {
        if (e.target === overlay) closeDynamicModal();
    });
}

async function editSubject(subjectId) {
    const subject = allSubjects.find(s => s.id === subjectId);
    if (!subject) return;

    if (activeSubjectModal) document.body.removeChild(activeSubjectModal);

    const overlay = document.createElement('div');
    overlay.className = 'dynamic-modal-overlay';
    overlay.style.cssText = `
        position: fixed; top: 0; left: 0;
        width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.8);
        z-index: 999999; display: flex;
        justify-content: center; align-items: center;
    `;

    const modal = document.createElement('div');
    modal.style.cssText = `
        background: white; border-radius: 12px;
        width: 90%; max-width: 500px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
    `;

    modal.innerHTML = `
        <div style="padding: 20px; border-bottom: 1px solid #eee;">
            <h3 style="margin: 0;">Редактировать предмет</h3>
        </div>
        <form id="dynEditSubjectForm" style="padding: 20px;">
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Название *</label>
                <input type="text" id="editSubjectName" value="${escapeHtml(subject.name)}" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;">
            </div>
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Описание</label>
                <textarea id="editSubjectDesc" rows="3" style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;">${subject.description || ''}</textarea>
            </div>
            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <button type="button" onclick="closeDynamicModal()" style="padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 6px; cursor: pointer;">Отмена</button>
                <button type="submit" style="padding: 10px 20px; background: #E12553; color: white; border: none; border-radius: 6px; cursor: pointer;">Сохранить</button>
            </div>
        </form>
    `;

    overlay.appendChild(modal);
    document.body.appendChild(overlay);
    activeSubjectModal = overlay;

    document.getElementById('dynEditSubjectForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const data = {
            name: document.getElementById('editSubjectName').value,
            description: document.getElementById('editSubjectDesc').value
        };

        try {
            const response = await fetchWithAuth(`subjects/${subjectId}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });

            if (!response.ok) {
                const error = await response.json();
                showToast(error.error || 'Ошибка', 'error');
                return;
            }

            showToast('Предмет обновлён!', 'success');
            closeDynamicModal();
            loadSubjects();
        } catch (error) { console.error('Error:', error); }
    });

    overlay.addEventListener('click', (e) => {
        if (e.target === overlay) closeDynamicModal();
    });
}

async function deleteSubject(subjectId, subjectName) {
    if (!confirm(`Удалить предмет "${subjectName}"?`)) return;

    try {
        const response = await fetchWithAuth(`subjects/${subjectId}`, { method: 'DELETE' });
        if (!response.ok) {
            const error = await response.json();
            showToast(error.error || 'Ошибка удаления', 'error');
            return;
        }
        showToast('Предмет удалён', 'success');
        loadSubjects();
    } catch (error) { console.error('Error:', error); }
}

// ============================================================================
// SUBJECT INSTRUCTORS (ИСПРАВЛЕНО)
// ============================================================================

async function openSubjectInstructors(subjectId, subjectName) {
    currentSubject = { id: subjectId, name: subjectName };
    if (activeSubjectModal) document.body.removeChild(activeSubjectModal);

    const overlay = document.createElement('div');
    overlay.className = 'dynamic-modal-overlay';
    overlay.style.cssText = `
        position: fixed; top: 0; left: 0;
        width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.8);
        z-index: 999999; display: flex;
        justify-content: center; align-items: center;
    `;

    const modal = document.createElement('div');
    modal.style.cssText = `
        background: white; border-radius: 12px;
        width: 90%; max-width: 800px;
        max-height: 90vh; overflow-y: auto;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
    `;

    modal.innerHTML = `
        <div style="padding: 20px; border-bottom: 1px solid #eee;">
            <h3 style="margin: 0;">Преподаватели предмета "${subjectName}"</h3>
        </div>
        <div style="padding: 20px;">
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Назначить преподавателя</label>
                <div style="display: flex; gap: 10px;">
                    <select id="dynAddInstructorSelect" style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 6px;">
                        <option value="">Загрузка...</option>
                    </select>
                    <button onclick="assignInstructor()" style="padding: 10px 20px; background: #E12553; color: white; border: none; border-radius: 6px; cursor: pointer;">Назначить</button>
                </div>
            </div>
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: #f5f5f5;">
                        <th style="padding: 10px; text-align: left;">ФИО</th>
                        <th style="padding: 10px; text-align: left;">Email</th>
                        <th style="padding: 10px; text-align: left;">Действия</th>
                    </tr>
                </thead>
                <tbody id="dynInstructorsBody">
                    <tr><td colspan="3" style="text-align: center; padding: 20px;">Загрузка...</td></tr>
                </tbody>
            </table>
        </div>
        <div style="padding: 20px; border-top: 1px solid #eee; text-align: right;">
            <button onclick="closeDynamicModal()" style="padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 6px; cursor: pointer;">Закрыть</button>
        </div>
    `;

    overlay.appendChild(modal);
    document.body.appendChild(overlay);
    activeSubjectModal = overlay;

    overlay.addEventListener('click', (e) => {
        if (e.target === overlay) closeDynamicModal();
    });

    await loadSubjectInstructorsDynamic(subjectId);
    await loadUnassignedInstructorsDynamic();
}

async function loadSubjectInstructorsDynamic(subjectId) {
    try {
        const response = await fetchWithAuth(`subjects/${subjectId}/instructors`);
        if (!response.ok) return;

        const instructors = await response.json();
        const tbody = document.getElementById('dynInstructorsBody');

        if (instructors.length === 0) {
            tbody.innerHTML = '<tr><td colspan="3" style="text-align: center; padding: 20px;">Преподавателей пока нет</td></tr>';
            return;
        }

        tbody.innerHTML = instructors.map(i => `
            <tr>
                <td style="padding: 10px;">${i.full_name}</td>
                <td style="padding: 10px;">${i.email}</td>
                <td style="padding: 10px;">
                    <button class="btn btn-sm btn-danger" onclick="unassignInstructor(${i.id})">
                        <i class='bx bx-x'></i> Удалить
                    </button>
                </td>
            </tr>
        `).join('');
    } catch (error) { console.error('Error:', error); }
}

async function loadUnassignedInstructorsDynamic() {
    try {
        // !!! ИСПРАВЛЕНИЕ ЗДЕСЬ !!!
        // Было: users?role=instructor (два знака ? в URL)
        // Стало: users&role=instructor
        const response = await fetchWithAuth('users&role=instructor');

        if (!response.ok) {
            console.error('Ошибка загрузки пользователей');
            document.getElementById('dynAddInstructorSelect').innerHTML = '<option>Ошибка загрузки</option>';
            return;
        }

        const allInstructors = await response.json();

        // Получаем тех, кто уже назначен, чтобы отфильтровать
        const assignedResponse = await fetchWithAuth(`subjects/${currentSubject.id}/instructors`);
        const assigned = assignedResponse.ok ? await assignedResponse.json() : [];
        const assignedIds = assigned.map(i => i.id);

        const unassigned = allInstructors.filter(i => !assignedIds.includes(i.id));

        const select = document.getElementById('dynAddInstructorSelect');
        if (unassigned.length === 0) {
            select.innerHTML = '<option value="">Нет доступных преподавателей</option>';
            select.disabled = true;
            return;
        }

        select.disabled = false;
        select.innerHTML = '<option value="">Выберите преподавателя...</option>' +
            unassigned.map(i => `<option value="${i.id}">${i.full_name}</option>`).join('');
    } catch (error) { console.error('Error:', error); }
}

async function assignInstructor() {
    const select = document.getElementById('dynAddInstructorSelect');
    const instructorId = select.value;

    if (!instructorId) {
        showToast('Выберите преподавателя', 'error');
        return;
    }

    try {
        const response = await fetchWithAuth(`subjects/${currentSubject.id}/assign-instructor`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ instructor_id: parseInt(instructorId) })
        });

        if (!response.ok) {
            const error = await response.json();
            showToast(error.error || 'Ошибка', 'error');
            return;
        }

        showToast('Преподаватель назначен', 'success');
        await loadSubjectInstructorsDynamic(currentSubject.id);
        await loadUnassignedInstructorsDynamic();
        loadSubjects();
    } catch (error) {
        console.error('Error:', error);
        showToast('Ошибка', 'error');
    }
}

async function unassignInstructor(instructorId) {
    if (!confirm('Удалить преподавателя из предмета?')) return;

    try {
        const response = await fetchWithAuth(`subjects/${currentSubject.id}/unassign-instructor`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ instructor_id: instructorId })
        });

        if (!response.ok) {
            showToast('Ошибка', 'error');
            return;
        }

        showToast('Преподаватель удалён', 'success');
        await loadSubjectInstructorsDynamic(currentSubject.id);
        await loadUnassignedInstructorsDynamic();
        loadSubjects();
    } catch (error) {
        console.error('Error:', error);
        showToast('Ошибка', 'error');
    }
}

function closeDynamicModal() {
    if (activeSubjectModal) {
        document.body.removeChild(activeSubjectModal);
        activeSubjectModal = null;
        currentSubject = null;
    }
}
