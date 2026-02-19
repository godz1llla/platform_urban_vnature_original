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

function initCuratorAttendance() {
    loadCuratorAttendanceReport();
}

async function loadCuratorAttendanceReport() {
    const container = document.getElementById('curatorReportContent');
    container.innerHTML = '<div class="loader-container"><div class="loader"></div></div>';

    try {
        const response = await fetchWithAuth('attendance/absent-report');
        if (!response.ok) throw new Error('Failed to load report');

        const data = await response.json(); // { "Group A": [student1, student2], ... }

        let html = '';
        if (Object.keys(data).length === 0) {
            html = `
                <div class="alert alert-success" style="padding: 20px; text-align: center;">
                    <i class='bx bx-check-circle' style="font-size: 3rem;"></i>
                    <h3>Все студенты присутствуют!</h3>
                    <p>Отличная посещаемость сегодня.</p>
                </div>
            `;
        } else {
            html = '<div class="dashboard-grid">'; // Используем grid для карточек

            // Сортировка групп по алфавиту
            const groupNames = Object.keys(data).sort();

            for (const groupName of groupNames) {
                const students = data[groupName];
                html += `
                    <div class="card" style="border-top: 4px solid var(--danger);">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                            <h4 style="margin: 0;">${groupName}</h4>
                            <span class="badge" style="background: var(--danger); color: white;">
                                ${students.length}
                            </span>
                        </div>
                        
                        <div style="max-height: 300px; overflow-y: auto;">
                            <ul class="student-list" style="list-style: none; padding: 0; margin: 0;">
                                ${students.map(s => `
                                    <li style="padding: 10px; border-bottom: 1px solid #eee; display: flex; align-items: center; gap: 10px;">
                                        <div style="width: 30px; height: 30px; background: #eee; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #777;">
                                            <i class='bx bx-user'></i>
                                        </div>
                                        <div>
                                            <div style="font-weight: 500;">${s.full_name}</div>
                                            <!-- <div style="font-size: 0.8rem; color: #777;">${s.student_code}</div> -->
                                        </div>
                                    </li>
                                `).join('')}
                            </ul>
                        </div>
                    </div>
                 `;
            }
            html += '</div>';
        }

        container.innerHTML = html;

    } catch (e) {
        console.error(e);
        container.innerHTML = `
            <div class="alert alert-danger">
                Ошибка загрузки отчета об отсутствии. Попробуйте обновить страницу.
            </div>
        `;
    }
}
