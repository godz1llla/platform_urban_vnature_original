// Модуль Журнала (Grades) с программными модалками (ИСПРАВЛЕННЫЙ)

let allGrades = [];
let activeGradeModal = null;
let currentUser = null;

function initGradesModule() {
    console.log('✅ initGradesModule вызван');

    const userStr = localStorage.getItem('user');
    if (userStr) {
        currentUser = JSON.parse(userStr);
    }

    loadGrades();

    const addBtn = document.getElementById('addGradeBtn');
    if (addBtn) {
        if (currentUser?.role === 'instructor' || currentUser?.role === 'admin') {
            addBtn.addEventListener('click', openAddGradeModal);
            addBtn.style.display = 'inline-block';
        } else {
            addBtn.style.display = 'none';
        }
    }
}

async function loadGrades() {
    try {
        let endpoint = 'grades';
        if (currentUser?.role === 'student') endpoint = 'grades/my';

        const response = await fetchWithAuth(endpoint);
        if (!response.ok) {
            showToast('Ошибка загрузки оценок', 'error');
            return;
        }

        allGrades = await response.json();
        displayGrades(allGrades);
    } catch (error) {
        console.error('Error loading grades:', error);
        showToast('Ошибка загрузки оценок', 'error');
    }
}

function displayGrades(grades) {
    const tbody = document.getElementById('gradesTableBody');
    if (!tbody) return;

    if (grades.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align: center;">Оценок пока нет</td></tr>';
        return;
    }

    if (currentUser?.role === 'student') {
        displayStudentGrades(grades);
        return;
    }

    tbody.innerHTML = grades.map(g => `
        <tr>
            <td data-label="Студент">${g.student_name}</td>
            <td data-label="Предмет">${g.subject_name}</td>
            <td data-label="Оценка">${g.grade_value}</td>
            <td data-label="Тип">${getGradeTypeLabel(g.grade_type)}</td>
            <td data-label="Дата">${g.date}</td>
            <td data-label="Действия">
                <button class="icon-btn" onclick="editGrade(${g.id})"><i class='bx bx-edit'></i></button>
                <button class="icon-btn delete" onclick="deleteGrade(${g.id}, '${escapeHtml(g.student_name)}')"><i class='bx bx-trash'></i></button>
            </td>
        </tr>
    `).join('');
}

function displayStudentGrades(gradesBySubject) {
    const container = document.getElementById('gradesTableBody');
    if (!gradesBySubject || gradesBySubject.length === 0) {
        container.innerHTML = '<p style="text-align: center; padding: 40px;">Оценок пока нет</p>';
        return;
    }

    // Здесь для студента переписываем контейнер полностью (т.к. у него не таблица, а карточки)
    // Либо нужно было менять структуру HTML, но оставим как есть, просто заменим содержимое tbody на div-ы не очень правильно семантически, но сработает
    // Лучше найти родителя tbody (table) и заменить его, или вставить внутрь tbody одну большую ячейку

    // ХАК: вставляем в tbody одну строку с одной ячейкой на всю ширину
    const html = gradesBySubject.map(subject => `
        <div style="background: white; border-radius: 8px; padding: 20px; margin-bottom: 20px; border: 1px solid #eee;">
            <h3 style="margin: 0 0 10px 0;">${subject.subject_name}</h3>
            <div style="margin-bottom: 15px;">
                <strong>Средний балл:</strong> 
                <span style="font-size: 20px; font-weight:bold; color: ${getGradeColor(subject.average)};">${subject.average}</span>
            </div>
            <table style="width: 100%; border-collapse: collapse; font-size: 14px;">
                <thead>
                    <tr style="background: #f9f9f9; border-bottom: 1px solid #eee;">
                        <th style="padding: 8px; text-align: left;">Тип</th>
                        <th style="padding: 8px; text-align: left;">Оценка</th>
                        <th style="padding: 8px; text-align: left;">Дата</th>
                        <th style="padding: 8px; text-align: left;">Комментарий</th>
                    </tr>
                </thead>
                <tbody>
                    ${subject.grades.map(g => `
                        <tr style="border-bottom: 1px solid #f0f0f0;">
                            <td style="padding: 8px;">${getGradeTypeLabel(g.grade_type)}</td>
                            <td style="padding: 8px; font-weight: bold; color: ${getGradeColor(g.grade_value)};">${g.grade_value}</td>
                            <td style="padding: 8px;">${g.date}</td>
                            <td style="padding: 8px; color: #666;">${g.comment || '-'}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
    `).join('');

    // Меняем таблицу на карточки
    const table = container.closest('table');
    if (table) {
        const wrapper = document.createElement('div');
        wrapper.innerHTML = html;
        table.parentNode.replaceChild(wrapper, table);
    }
}

function getGradeTypeLabel(type) {
    const labels = {
        'exam': 'Экзамен',
        'quiz': 'Тест',
        'homework': 'ДЗ',
        'attendance': 'Посещаемость',
        'midterm': 'Межсессия',
        'final': 'Итоговая',
        'classwork': 'Классная работа'
    };
    return labels[type] || type;
}

function getGradeColor(value) {
    if (value >= 85) return '#10b981';
    if (value >= 70) return '#3b82f6';
    if (value >= 50) return '#f59e0b';
    return '#ef4444';
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// ============================================================================
// МОДАЛКА
// ============================================================================

async function openAddGradeModal() {
    if (activeGradeModal) document.body.removeChild(activeGradeModal);

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
        max-height: 90vh; overflow-y: auto;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
    `;

    modal.innerHTML = `
        <div style="padding: 20px; border-bottom: 1px solid #eee;">
            <h3 style="margin: 0;">Выставить оценку</h3>
        </div>
        <form id="dynGradeForm" style="padding: 20px;">
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Студент *</label>
                <select id="dynGradeStudent" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;">
                    <option value="">Загрузка...</option>
                </select>
            </div>
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Предмет *</label>
                <select id="dynGradeSubject" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;">
                    <option value="">Загрузка...</option>
                </select>
            </div>
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Оценка (0-100) *</label>
                <input type="number" id="dynGradeValue" min="0" max="100" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;">
            </div>
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Тип *</label>
                <select id="dynGradeType" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;">
                    <option value="exam">Экзамен</option>
                    <option value="quiz">Тест</option>
                    <option value="homework">ДЗ</option>
                    <option value="attendance">Посещаемость</option>
                    <option value="midterm">Межсессия</option>
                    <option value="final">Итоговая</option>
                    <option value="classwork">Классная работа</option>
                </select>
            </div>
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Комментарий</label>
                <textarea id="dynGradeComment" rows="3" style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;"></textarea>
            </div>
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 5px; font-weight: 500;">Дата *</label>
                <input type="date" id="dynGradeDate" value="${new Date().toISOString().split('T')[0]}" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;">
            </div>
            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <button type="button" id="cancelGradeBtn" style="padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 6px; cursor: pointer;">Отмена</button>
                <button type="submit" style="padding: 10px 20px; background: #E12553; color: white; border: none; border-radius: 6px; cursor: pointer;">Выставить</button>
            </div>
        </form>
    `;

    overlay.appendChild(modal);
    document.body.appendChild(overlay);
    activeGradeModal = overlay;

    document.getElementById('cancelGradeBtn').addEventListener('click', closeDynamicGradeModal);

    document.getElementById('dynGradeForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const data = {
            student_user_id: parseInt(document.getElementById('dynGradeStudent').value),
            subject_id: parseInt(document.getElementById('dynGradeSubject').value),
            grade_value: parseFloat(document.getElementById('dynGradeValue').value),
            grade_type: document.getElementById('dynGradeType').value,
            comment: document.getElementById('dynGradeComment').value,
            date: document.getElementById('dynGradeDate').value
        };

        try {
            const response = await fetchWithAuth('grades', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });

            if (!response.ok) {
                const error = await response.json();
                showToast(error.error || 'Ошибка', 'error');
                return;
            }
            showToast('Оценка выставлена!', 'success');
            closeDynamicGradeModal();
            loadGrades();
        } catch (error) {
            console.error('Error:', error);
            showToast('Ошибка выставления оценки', 'error');
        }
    });

    overlay.addEventListener('click', (e) => {
        if (e.target === overlay) closeDynamicGradeModal();
    });

    await loadStudentsForGrade();
    await loadSubjectsForGrade();
}

async function loadStudentsForGrade() {
    try {
        // !!! ИСПРАВЛЕНИЕ: users&role=student вместо users?role=student
        const response = await fetchWithAuth('users&role=student');
        if (!response.ok) return;

        const students = await response.json();
        const select = document.getElementById('dynGradeStudent');

        if (students.length === 0) {
            select.innerHTML = '<option value="">Нет студентов</option>';
            select.disabled = true;
            return;
        }

        select.disabled = false;
        select.innerHTML = '<option value="">Выберите студента...</option>' +
            students.map(s => `<option value="${s.id}">${s.full_name} ${s.group_name ? '(' + s.group_name + ')' : ''}</option>`).join('');
    } catch (error) { console.error('Error:', error); }
}

async function loadSubjectsForGrade() {
    try {
        const response = await fetchWithAuth('subjects');
        if (!response.ok) return;

        const subjects = await response.json();
        const select = document.getElementById('dynGradeSubject');

        let filteredSubjects = subjects;
        // Если нужно, здесь можно отфильтровать предметы для преподавателя (хотя лучше на бэке)

        if (filteredSubjects.length === 0) {
            select.innerHTML = '<option value="">Нет предметов</option>';
            select.disabled = true;
            return;
        }

        select.disabled = false;
        select.innerHTML = '<option value="">Выберите предмет...</option>';

        // Используем Set для дополнительной гарантии уникальности имен в UI
        const seenNames = new Set();
        const options = filteredSubjects
            .filter(s => {
                if (seenNames.has(s.name)) return false;
                seenNames.add(s.name);
                return true;
            })
            .map(s => `<option value="${s.id}">${s.name}</option>`)
            .join('');

        select.innerHTML += options;
    } catch (error) { console.error('Error:', error); }
}

async function deleteGrade(gradeId, studentName) {
    if (!confirm(`Удалить оценку студента "${studentName}"?`)) return;
    try {
        const response = await fetchWithAuth(`grades/${gradeId}`, { method: 'DELETE' });
        if (!response.ok) {
            const error = await response.json();
            showToast(error.error || 'Ошибка удаления', 'error');
            return;
        }
        showToast('Оценка удалена', 'success');
        loadGrades();
    } catch (error) { console.error('Error:', error); }
}

function closeDynamicGradeModal() {
    if (activeGradeModal) {
        document.body.removeChild(activeGradeModal);
        activeGradeModal = null;
    }
}
