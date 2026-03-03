/**
 * Schedule Management Module
 * Handles visual grid editing and cloning
 */

let currentScheduleData = [];
let allSubjects = [];
let allInstructors = [];
let editingLessonId = null;

const DAYS = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
const DAY_LABELS = {
    'monday': 'Пн', 'tuesday': 'Вт', 'wednesday': 'Ср',
    'thursday': 'Чт', 'friday': 'Пт', 'saturday': 'Сб'
};

const TIME_SLOTS = [
    { pair: 1, start: '08:30', end: '10:00' },
    { pair: 2, start: '10:10', end: '11:40' },
    { pair: 3, start: '12:10', end: '13:40' },
    { pair: 4, start: '13:50', end: '15:20' },
    { pair: 5, start: '15:30', end: '17:00' }
];

async function initScheduleManagement() {
    console.log('Initializing Schedule Management...');
    try {
        const [groups, subjects, instructors] = await Promise.all([
            fetchWithAuth('groups'),
            fetchWithAuth('subjects'),
            fetchWithAuth('users?role=instructor')
        ]);

        allSubjects = subjects;
        allInstructors = instructors;

        // Fill Group Select
        const groupSelect = document.getElementById('manageGroupId');
        groupSelect.innerHTML = groups.map(g => `<option value="${g.id}">${g.name}</option>`).join('');

        // Fill Modal Selects
        const subjectSelect = document.getElementById('cellSubjectId');
        subjectSelect.innerHTML = '<option value="">Выберите предмет...</option>' +
            subjects.map(s => `<option value="${s.id}">${s.name}</option>`).join('');

        const instructorSelect = document.getElementById('cellInstructorId');
        instructorSelect.innerHTML = '<option value="">Выберите преподавателя...</option>' +
            instructors.map(u => `<option value="${u.id}">${u.full_name}</option>`).join('');

        if (groups.length > 0) {
            loadManagementSchedule();
        }
    } catch (error) {
        console.error('Failed to init schedule management:', error);
        showToast('Ошибка загрузки данных', 'error');
    }
}

async function loadManagementSchedule() {
    const groupId = document.getElementById('manageGroupId').value;
    const weekNum = document.getElementById('manageWeekNum').value;

    if (!groupId) return;

    const gridContainer = document.getElementById('scheduleManageGrid');
    gridContainer.innerHTML = '<div class="loading-spinner"><div class="spinner"></div></div>';

    try {
        const lessons = await fetchWithAuth(`schedule?group_id=${groupId}&week_number=${weekNum}`);
        currentScheduleData = lessons;
        renderScheduleGrid(lessons);
    } catch (error) {
        console.error('Failed to load schedule:', error);
        gridContainer.innerHTML = '<div class="error-message">Ошибка загрузки расписания</div>';
    }
}

function renderScheduleGrid(lessons) {
    const gridContainer = document.getElementById('scheduleManageGrid');
    gridContainer.innerHTML = '';

    // 1. Header Row
    gridContainer.appendChild(createDiv('grid-header', 'Время'));
    DAYS.forEach(day => {
        gridContainer.appendChild(createDiv('grid-header', DAY_LABELS[day]));
    });

    // 2. Time Slots Rows
    TIME_SLOTS.forEach(slot => {
        // Time Cell
        const timeCell = document.createElement('div');
        timeCell.className = 'grid-time-cell';
        timeCell.innerHTML = `<strong>${slot.pair} пара</strong><span>${slot.start} - ${slot.end}</span>`;
        gridContainer.appendChild(timeCell);

        // Day Cells
        DAYS.forEach(day => {
            const cell = document.createElement('div');
            cell.className = 'grid-cell';
            const lesson = lessons.find(l => l.day_of_week === day && parseInt(l.pair_number) === slot.pair);

            if (lesson) {
                cell.classList.add('has-lesson');
                cell.innerHTML = `
                    <div class="grid-lesson-card">
                        <div class="grid-lesson-subject">${lesson.subject_name}</div>
                        <div class="grid-lesson-instr">${lesson.instructor_name}</div>
                        <div class="grid-lesson-room">${lesson.audience || '-'}</div>
                    </div>
                `;
            } else {
                cell.innerHTML = '<div class="grid-cell-empty"><i class="bx bx-plus"></i></div>';
            }

            cell.onclick = () => openCellModal(day, slot.pair, lesson);
            gridContainer.appendChild(cell);
        });
    });
}

function createDiv(className, text) {
    const div = document.createElement('div');
    div.className = className;
    div.innerText = text;
    return div;
}

function openCellModal(day, pair, lesson = null) {
    editingLessonId = lesson ? lesson.id : null;
    document.getElementById('cellDay').value = day;
    document.getElementById('cellPair').value = pair;

    document.getElementById('cellModalTitle').innerText = lesson ? 'Редактировать урок' : 'Добавить урок';

    // Fill form
    document.getElementById('cellSubjectId').value = lesson ? lesson.subject_id : '';
    document.getElementById('cellInstructorId').value = lesson ? lesson.instructor_id : '';
    document.getElementById('cellRoom').value = lesson ? lesson.audience : '';

    const slot = TIME_SLOTS.find(s => s.pair === pair);
    document.getElementById('cellStartTime').value = lesson ? lesson.time_start.substring(0, 5) : slot.start;
    document.getElementById('cellEndTime').value = lesson ? lesson.time_end.substring(0, 5) : slot.end;

    document.getElementById('deleteCellBtn').style.display = lesson ? 'block' : 'none';

    document.getElementById('editScheduleCellModal').classList.remove('hidden');
}

function closeCellModal() {
    document.getElementById('editScheduleCellModal').classList.add('hidden');
}

// Handle Form Submission
document.getElementById('cellForm').onsubmit = async (e) => {
    e.preventDefault();

    const data = {
        group_id: document.getElementById('manageGroupId').value,
        week_number: document.getElementById('manageWeekNum').value,
        day_of_week: document.getElementById('cellDay').value,
        pair_number: document.getElementById('cellPair').value,
        subject_id: document.getElementById('cellSubjectId').value,
        instructor_id: document.getElementById('cellInstructorId').value,
        audience: document.getElementById('cellRoom').value,
        time_start: document.getElementById('cellStartTime').value,
        time_end: document.getElementById('cellEndTime').value
    };

    try {
        let result;
        if (editingLessonId) {
            result = await fetchWithAuth(`schedule/${editingLessonId}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            });
        } else {
            result = await fetchWithAuth('schedule', {
                method: 'POST',
                body: JSON.stringify(data)
            });
        }

        showToast(editingLessonId ? 'Обновлено' : 'Добавлено', 'success');
        closeCellModal();
        loadManagementSchedule();
    } catch (error) {
        handleApiError(error);
    }
};

document.getElementById('deleteCellBtn').onclick = async () => {
    if (!editingLessonId || !confirm('Удалить эту запись?')) return;

    try {
        await fetchWithAuth(`schedule/${editingLessonId}`, { method: 'DELETE' });
        showToast('Удалено', 'success');
        closeCellModal();
        loadManagementSchedule();
    } catch (error) {
        handleApiError(error);
    }
};

async function cloneScheduleToCourse() {
    const groupId = document.getElementById('manageGroupId').value;
    const fromWeek = document.getElementById('manageWeekNum').value;

    if (!groupId || !confirm(`Вы уверены, что хотите скопировать расписание ${fromWeek}-й недели на ВЕСЬ КУРС (со 2 по 8 недели)? Это перезапишет существующие данные.`)) {
        return;
    }

    // Target weeks: 1-8 (excluding source)
    const toWeeks = [1, 2, 3, 4, 5, 6, 7, 8].filter(w => w != fromWeek);

    try {
        const result = await fetchWithAuth('schedule/clone', {
            method: 'POST',
            body: JSON.stringify({
                group_id: groupId,
                from_week: fromWeek,
                to_weeks: toWeeks
            })
        });

        showToast('Расписание успешно размножено на весь курс!', 'success');
    } catch (error) {
        handleApiError(error);
    }
}

function saveManagementSchedule() {
    showToast('Все изменения уже сохранены автоматически при редактировании ячеек', 'info');
}
