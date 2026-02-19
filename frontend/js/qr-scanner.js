// QR Scanner для выдачи питания

let videoStream = null;
let isScanning = false;
let scanInterval = null;

// Запуск камеры
async function startCamera() {
    const video = document.getElementById('qrVideo');
    const startBtn = document.getElementById('startScanBtn');

    try {
        // Запрос доступа к камере
        videoStream = await navigator.mediaDevices.getUserMedia({
            video: {
                facingMode: 'environment', // Задняя камера на мобильных
                width: { ideal: 1280 },
                height: { ideal: 720 }
            }
        });

        video.srcObject = videoStream;
        video.play();

        startBtn.style.display = 'none';
        isScanning = true;

        // Начать сканирование
        startQRScanning();

        showToast('Камера активирована', 'success');
    } catch (error) {
        console.error('Camera access error:', error);
        showToast('Не удалось получить доступ к камере', 'error');
    }
}

// Остановка камеры
function stopCamera() {
    if (videoStream) {
        videoStream.getTracks().forEach(track => track.stop());
        videoStream = null;
    }

    isScanning = false;

    if (scanInterval) {
        clearInterval(scanInterval);
        scanInterval = null;
    }

    const video = document.getElementById('qrVideo');
    const startBtn = document.getElementById('startScanBtn');

    video.srcObject = null;
    startBtn.style.display = 'flex';
}

// Сканирование QR кода
function startQRScanning() {
    const video = document.getElementById('qrVideo');
    const canvas = document.getElementById('qrCanvas');
    const ctx = canvas.getContext('2d');

    console.log('🔍 QR сканирование запущено');

    scanInterval = setInterval(() => {
        if (!isScanning || video.readyState !== video.HAVE_ENOUGH_DATA) {
            return;
        }

        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;

        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

        // Простое декодирование (в продакшене использовать библиотеку jsQR)
        const qrCode = decodeQRCode(imageData);

        if (qrCode) {
            console.log('✅ QR код распознан:', qrCode);
            handleQRCodeScanned(qrCode);
        }
    }, 300); // Сканировать каждые 300ms
}

// Декодирование QR через jsQR библиотеку
function decodeQRCode(imageData) {
    try {
        const code = jsQR(imageData.data, imageData.width, imageData.height, {
            inversionAttempts: "dontInvert",
        });
        return code ? code.data : null;
    } catch (error) {
        console.error('QR decode error:', error);
        return null;
    }
}

// Обработка отсканированного QR кода
async function handleQRCodeScanned(qrToken) {
    if (!isScanning) return;

    // Остановить дальнейшее сканирование
    isScanning = false;
    stopCamera();

    showToast('QR код распознан', 'info');

    // Найти студента по QR токену
    await checkStudentByQR(qrToken);
}

// Проверка студента по QR токену
async function checkStudentByQR(qrToken) {
    try {
        // В реальной системе был бы отдельный эндпоинт для поиска по QR
        // Для демо используем ID студента напрямую
        const studentId = extractStudentIdFromQR(qrToken);

        if (!studentId) {
            showToast('Неверный QR код', 'error');
            resetServeForm();
            return;
        }

        await checkStudentById(studentId, qrToken);
    } catch (error) {
        showToast('Ошибка проверки студента', 'error');
        resetServeForm();
    }
}

// Извлечение ID студента из QR токена
function extractStudentIdFromQR(qrToken) {
    console.log('🔎 Извлечение ID из QR:', qrToken);
    // Формат QR токена: QR_LASTNAME_ID или просто число
    const match = qrToken.match(/(\d+)$/);
    const id = match ? match[1] : null;
    console.log('📝 Извлеченный ID:', id);
    return id;
}

// Проверка студента по ID
async function checkStudentById(studentId, qrToken) {
    console.log('🔍 Проверка студента ID:', studentId, 'QR:', qrToken);

    try {
        const url = `cafeteria/serve/check/${studentId}`;
        console.log('📡 Запрос к API:', url);

        const response = await fetchWithAuth(url);

        console.log('📨 Ответ API status:', response.status);

        if (!response.ok) {
            const errorText = await response.text();
            console.error('❌ Ошибка API:', errorText);
            showToast('Студент не найден', 'error');
            resetServeForm();
            return;
        }

        const data = await response.json();
        console.log('✅ Данные студента получены:', data);

        if (!data.allowed) {
            showToast(data.error, 'error');

            // Показать информацию о студенте даже если не разрешено
            if (data.student && data.assignment) {
                displayStudentInfo(data.student, data.assignment, null, false);
            }

            return;
        }

        // Сохранить данные студента
        currentStudent = {
            ...data.student,
            qr_token: qrToken,
            assignment: data.assignment,
            limits: data.limits
        };

        // Отобразить информацию
        displayStudentInfo(data.student, data.assignment, data.limits, true);

    } catch (error) {
        console.error('💥 КРИТИЧЕСКАЯ ОШИБКА проверки студента:', error);
        showToast('Ошибка проверки студента', 'error');
        resetServeForm();
    }
}

// Отображение информации о студенте
function displayStudentInfo(student, assignment, limits, allowed) {
    const resultDiv = document.getElementById('studentCheckResult');

    document.getElementById('resultStudentName').textContent = student.full_name;
    document.getElementById('resultStudentCode').textContent = `Код: ${student.student_code}`;
    document.getElementById('resultStudentGroup').textContent = `Группа: ${student.group_name}`;

    if (assignment) {
        document.getElementById('resultCategoryName').textContent = assignment.category_name;

        if (limits) {
            document.getElementById('resultDailyLimit').textContent = limits.daily || 0;
            document.getElementById('resultWeeklyLimit').textContent = limits.weekly || 0;
            document.getElementById('resultMonthlyLimit').textContent = limits.monthly || 0;
        }
    }

    // Кнопка подтверждения
    const confirmBtn = document.getElementById('confirmServeBtn');
    confirmBtn.disabled = !allowed;
    confirmBtn.style.opacity = allowed ? '1' : '0.5';

    resultDiv.hidden = false;
}

// Подтверждение выдачи питания
async function confirmServe() {
    if (!currentStudent) {
        showToast('Ошибка: студент не выбран', 'error');
        return;
    }

    try {
        const response = await fetchWithAuth('cafeteria/serve', {
            method: 'POST',
            body: JSON.stringify({
                student_id: currentStudent.id,
                qr_identifier: currentStudent.qr_token
            })
        });

        const result = await response.json();

        if (result.success) {
            showToast('Питание выдано успешно! ✓', 'success');
            resetServeForm();
        } else {
            showToast(result.error || 'Ошибка выдачи питания', 'error');
        }
    } catch (error) {
        showToast('Ошибка выдачи питания', 'error');
    }
}

// Отмена выдачи и сброс формы
function resetServeForm() {
    currentStudent = null;

    const resultDiv = document.getElementById('studentCheckResult');
    resultDiv.hidden = true;

    const startBtn = document.getElementById('startScanBtn');
    startBtn.style.display = 'flex';
}

// Ручной ввод ID студента (для тестирования без камеры)
function manualStudentInput() {
    const studentId = prompt('Введите ID студента:');

    if (studentId) {
        const qrToken = `QR_MANUAL_${studentId}`;
        checkStudentById(studentId, qrToken);
    }
}

// Инициализация QR сканера
document.addEventListener('DOMContentLoaded', () => {
    const startScanBtn = document.getElementById('startScanBtn');
    if (startScanBtn) {
        startScanBtn.addEventListener('click', startCamera);
    }

    const confirmServeBtn = document.getElementById('confirmServeBtn');
    if (confirmServeBtn) {
        confirmServeBtn.addEventListener('click', confirmServe);
    }

    const cancelServeBtn = document.getElementById('cancelServeBtn');
    if (cancelServeBtn) {
        cancelServeBtn.addEventListener('click', resetServeForm);
    }

    // Кнопка ручного ввода
    const manualInputBtn = document.getElementById('manualInputBtn');
    if (manualInputBtn) {
        manualInputBtn.addEventListener('click', manualStudentInput);
    }

    // Для тестирования без камеры - добавить кнопку ручного ввода
    const qrWrapper = document.querySelector('.qr-scanner-wrapper');
    if (qrWrapper && !navigator.mediaDevices) {
        const manualBtn = document.createElement('button');
        manualBtn.className = 'btn btn-secondary';
        manualBtn.innerHTML = '<i class="bx bx-keyboard"></i> Ввести вручную';
        manualBtn.onclick = manualStudentInput;
        qrWrapper.appendChild(manualBtn);
    }
});
