// Модуль Посещаемости - Новая версия

let currentToken = null;
let qrUpdateInterval = null;
let timerInterval = null;
let timerSeconds = 8;
let studentScanning = false;

// Инициализация модуля посещаемости
function initAttendanceModule() {
    const role = getCurrentUserRole();

    if (role === 'student') {
        document.getElementById('attendanceStudent').style.display = 'block';
        document.getElementById('attendanceTeacher').style.display = 'none';
        initStudentAttendance();
    } else if (role === 'admin' || role === 'instructor') {
        document.getElementById('attendanceTeacher').style.display = 'block';
        document.getElementById('attendanceStudent').style.display = 'none';
        document.getElementById('attendanceCurator').style.display = 'none';
        initTeacherAttendance();
    } else if (role === 'curator') {
        document.getElementById('attendanceCurator').style.display = 'block';
        document.getElementById('attendanceTeacher').style.display = 'none';
        document.getElementById('attendanceStudent').style.display = 'none';
        initCuratorAttendance();
    }
}

// ============================================================================
// TEACHER / ADMIN PART
// ============================================================================

async function initTeacherAttendance() {
    await generateAndDisplayQR();
    startQRAutoUpdate();
    loadTodayAttendedStudents();

    // Автообновление списка отмеченных студентов каждые 5 секунд
    setInterval(() => {
        loadTodayAttendedStudents();
    }, 5000);

    // Fullscreen button
    document.getElementById('fullscreenQrBtn').addEventListener('click', openFullscreenQR);
    document.getElementById('closeFullscreenBtn').addEventListener('click', closeFullscreenQR);
}

async function generateAndDisplayQR() {
    try {
        const response = await fetchWithAuth('attendance/generate-token');

        if (!response.ok) {
            showToast('Ошибка генерации токена', 'error');
            return;
        }

        const data = await response.json();
        currentToken = data.token;

        // Рисуем QR с помощью QRious
        if (typeof QRious !== 'undefined') {
            new QRious({
                element: document.getElementById('teacherQrCode'),
                value: currentToken,
                size: 300,
                level: 'H'
            });
        } else {
            console.error('QRious library not loaded');
        }

        // Запустить отсчет
        startCountdown();

    } catch (error) {
        console.error('Error generating QR:', error);
    }
}

function startQRAutoUpdate() {
    // Очистить предыдущий интервал, если есть
    if (qrUpdateInterval) {
        clearInterval(qrUpdateInterval);
    }

    qrUpdateInterval = setInterval(() => {
        generateAndDisplayQR();
    }, 8000); // Каждые 8 секунд
}

function startCountdown() {
    timerSeconds = 8;
    document.getElementById('qrTimer').textContent = timerSeconds;
    document.getElementById('qrTimerLarge').textContent = timerSeconds;

    if (timerInterval) {
        clearInterval(timerInterval);
    }

    timerInterval = setInterval(() => {
        timerSeconds--;
        document.getElementById('qrTimer').textContent = timerSeconds;
        document.getElementById('qrTimerLarge').textContent = timerSeconds;

        if (timerSeconds <= 0) {
            clearInterval(timerInterval);
        }
    }, 1000);
}

function openFullscreenQR() {
    const modal = document.getElementById('qrFullscreenModal');
    modal.hidden = false;

    // Рисуем огромный QR (800x800)
    if (typeof QRious !== 'undefined' && currentToken) {
        new QRious({
            element: document.getElementById('fullscreenQrCode'),
            value: currentToken,
            size: 800,
            level: 'H'
        });
    }
}

function closeFullscreenQR() {
    document.getElementById('qrFullscreenModal').hidden = true;
}

async function loadTodayAttendedStudents() {
    const tbody = document.getElementById('todayAttendanceTableBody');

    try {
        const today = new Date().toISOString().split('T')[0];
        const response = await fetchWithAuth(`attendance/records?from=${today}&to=${today}`);

        if (!response.ok) {
            tbody.innerHTML = '<tr><td colspan="3">Ошибка загрузки</td></tr>';
            return;
        }

        const records = await response.json();

        if (records.length === 0) {
            tbody.innerHTML = '<tr><td colspan="3" style="text-align: center;">Пока нет отметившихся студентов</td></tr>';
            return;
        }

        tbody.innerHTML = records.map(r => {
            const time = new Date(r.marked_at).toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' });

            return `
                <tr>
                    <td data-label="Время">${time}</td>
                    <td data-label="Студент">${r.student_name} (${r.student_code})</td>
                    <td data-label="Группа">${r.group_name}</td>
                </tr>
            `;
        }).join('');

    } catch (error) {
        console.error('Error loading today records:', error);
        tbody.innerHTML = '<tr><td colspan="3">Ошибка загрузки</td></tr>';
    }
}

// ============================================================================
// STUDENT PART
// ============================================================================

function initStudentAttendance() {
    document.getElementById('scanTeacherQrBtn').addEventListener('click', startStudentScanning);
    document.getElementById('stopScanBtn').addEventListener('click', stopStudentScanning);
    loadMyAttendanceStats();
}

async function startStudentScanning() {
    const video = document.getElementById('studentScanVideo');
    const scanner = document.getElementById('studentQrScanner');
    const scanBtn = document.getElementById('scanTeacherQrBtn');

    scanner.hidden = false;
    scanBtn.disabled = true;

    try {
        const stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } });
        video.srcObject = stream;
        studentScanning = true;

        scanForTeacherQR(video);
    } catch (error) {
        console.error('Error accessing camera:', error);
        showToast('Не удалось получить доступ к камере', 'error');
        scanner.hidden = true;
        scanBtn.disabled = false;
    }
}

function stopStudentScanning() {
    const video = document.getElementById('studentScanVideo');
    const scanner = document.getElementById('studentQrScanner');
    const scanBtn = document.getElementById('scanTeacherQrBtn');

    if (video.srcObject) {
        video.srcObject.getTracks().forEach(track => track.stop());
        video.srcObject = null;
    }

    studentScanning = false;
    scanner.hidden = true;
    scanBtn.disabled = false;
}

function scanForTeacherQR(video) {
    if (!studentScanning) return;

    const canvas = document.getElementById('studentScanCanvas');
    const context = canvas.getContext('2d');

    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;

    if (canvas.width > 0 && canvas.height > 0) {
        context.drawImage(video, 0, 0, canvas.width, canvas.height);
        const imageData = context.getImageData(0, 0, canvas.width, canvas.height);

        if (typeof jsQR !== 'undefined') {
            const code = jsQR(imageData.data, imageData.width, imageData.height);
            if (code) {
                studentScanning = false;
                stopStudentScanning();
                markSelfAttendance(code.data);
                return;
            }
        }
    }

    requestAnimationFrame(() => scanForTeacherQR(video));
}

async function markSelfAttendance(token) {
    try {
        const response = await fetchWithAuth('attendance/mark-self', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ token: token })
        });

        if (!response.ok) {
            const errorData = await response.json();
            showToast(errorData.error || 'Ошибка отметки', 'error');
            return;
        }

        const data = await response.json();
        showToast('✅ ' + data.message, 'success');

        // Обновить статистику
        loadMyAttendanceStats();

    } catch (error) {
        console.error('Error marking attendance:', error);
        showToast('Ошибка отметки посещаемости', 'error');
    }
}

async function loadMyAttendanceStats() {
    try {
        const response = await fetchWithAuth('attendance/my-stats');

        if (!response.ok) {
            showToast('Ошибка загрузки статистики', 'error');
            return;
        }

        const stats = await response.json();

        document.getElementById('myTotalDays').textContent = stats.total_days;
        document.getElementById('myPresentDays').textContent = stats.present_days;
        document.getElementById('myLateCount').textContent = stats.late_count;
        document.getElementById('myPercentage').textContent = `${stats.percentage}%`;

    } catch (error) {
        console.error('Error loading my attendance stats:', error);
    }
}

// Вспомогательная функция для получения роли
function getCurrentUserRole() {
    const userDataStr = localStorage.getItem('user');
    if (!userDataStr) return null;
    const userData = JSON.parse(userDataStr);
    return userData.role;
}

// Очистка интервалов при уходе со страницы
window.addEventListener('beforeunload', () => {
    if (qrUpdateInterval) clearInterval(qrUpdateInterval);
    if (timerInterval) clearInterval(timerInterval);
});

// ============================================================================
// CURATOR PART
// ============================================================================

let currentCuratorGroupId = null;

function initCuratorAttendance() {
    showCuratorGroupList();
}

// 1. Show List of Groups
async function showCuratorGroupList() {
    document.getElementById('curatorGroupList').style.display = 'block';
    document.getElementById('curatorGroupDetails').style.display = 'none';

    const container = document.getElementById('curatorGroupsContainer');
    container.innerHTML = '<div class="loader-container"><div class="loader"></div></div>';

    try {
        const response = await fetchWithAuth('groups');
        if (!response.ok) throw new Error('Failed to load groups');
        const groups = await response.json();

        container.innerHTML = groups.map(group => `
            <div class="stat-card blue" style="cursor: pointer;" onclick="openCuratorGroupDetails(${group.id}, '${group.name}')">
                <div class="stat-icon"><i class='bx bx-group'></i></div>
                <div class="stat-value" style="font-size: 1.5rem;">${group.name}</div>
                <div class="stat-label">Нажмите для отчета</div>
            </div>
        `).join('');

    } catch (e) {
        console.error(e);
        container.innerHTML = `<div class="alert alert-danger">Ошибка загрузки групп</div>`;
    }
}

// 2. Open Group Details
function openCuratorGroupDetails(groupId, groupName) {
    currentCuratorGroupId = groupId;
    document.getElementById('reportGroupName').textContent = groupName;

    // Set default date to today
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('reportDateInput').value = today;

    document.getElementById('curatorGroupList').style.display = 'none';
    document.getElementById('curatorGroupDetails').style.display = 'block';

    loadGroupDailyReport();
}

// 3. Load Report
async function loadGroupDailyReport() {
    if (!currentCuratorGroupId) return;

    const date = document.getElementById('reportDateInput').value;
    const tbody = document.getElementById('groupDailyReportBody');
    const thead = document.getElementById('groupDailyReportHead');

    tbody.innerHTML = '<tr><td colspan="100" class="text-center"><div class="loader"></div></td></tr>';
    document.getElementById('reportDateSubtitle').textContent = `Отчет за ${date}`;

    try {
        const params = new URLSearchParams({ path: `attendance/group-daily-report`, group_id: currentCuratorGroupId, date: date });
        const token = getToken();
        const response = await fetch(`/backend/api.php?${params}`, {
            headers: { 'Authorization': `Bearer ${token}`, 'Content-Type': 'application/json' }
        });
        if (!response.ok) throw new Error('Failed to load report');

        const data = await response.json();
        const { lessons, students } = data;

        // Build Header
        if (lessons.length === 0) {
            thead.innerHTML = '<tr><th>Студент</th><th>Пар нет</th></tr>';
            tbody.innerHTML = '<tr><td colspan="2" class="text-center">На эту дату нет расписания</td></tr>';
            return;
        }

        let headerHtml = '<tr><th>Студент</th>';
        lessons.forEach(l => {
            const time = l.time_start.substring(0, 5);
            headerHtml += `<th><div style="font-size: 0.8rem; color: #777;">${time}</div>${l.subject_name}<br><small>${l.type || ''}</small></th>`;
        });
        headerHtml += '</tr>';
        thead.innerHTML = headerHtml;

        // Build Body
        tbody.innerHTML = students.map(s => {
            let rowHtml = `<tr>
                <td>
                    <div style="font-weight: 500;">${s.full_name}</div>
                    <div style="font-size: 0.75rem; color: #999;">${s.student_code}</div>
                </td>`;

            lessons.forEach(l => {
                const status = s.attendance[l.id];
                let cellContent = '<span style="color: #ddd;">-</span>';

                if (status === 'present') {
                    cellContent = '<span class="badge badge-success"><i class="bx bx-check"></i></span>';
                } else {
                    cellContent = '<span class="badge badge-danger" style="opacity: 0.5;"><i class="bx bx-x"></i></span>';
                }

                rowHtml += `<td class="text-center">${cellContent}</td>`;
            });

            rowHtml += '</tr>';
            return rowHtml;
        }).join('');

    } catch (e) {
        console.error(e);
        tbody.innerHTML = '<tr><td colspan="100" class="text-center text-danger">Ошибка загрузки данных</td></tr>';
    }
}
