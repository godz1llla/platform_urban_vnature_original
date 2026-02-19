// student-card.js - ПОЛНОСТЬЮ ИСПРАВЛЕННЫЙ

// ============================================================================
// ЗАГРУЗКА ДАННЫХ КАРТЫ СТУДЕНТА
// ============================================================================

async function loadStudentCard() {
    try {
        // Проверка авторизации
        const meRes = await fetchWithAuth('auth/me');
        if (!meRes.ok) return;
        const me = await meRes.json();

        if (me.role !== 'student') return; // Только для студентов

        // Грузим полные данные о студенте (лимиты, код, группа)
        // Если эндпоинта 'students/my-info' нет, используем фоллбэк
        try {
            const res = await fetchWithAuth('students/my-info'); // Убедитесь, что этот путь есть
            if (res.ok) {
                const data = await res.json();
                displayStudentCard(data);
                return;
            }
        } catch (e) { }

        // Фоллбэк (если нет расширенного API)
        document.getElementById('myFullName').textContent = me.full_name;
        // Генерируем QR
        const canvas = document.getElementById('studentQRCode');
        if (canvas) {
            new QRious({ element: canvas, value: "STUDENT_" + me.user_id, size: 250 });
        }

    } catch (e) { console.error(e); }
}

function displayStudentCard(data) {
    const student = data.student || data;
    const assign = data.assignment;
    const limits = data.limits;

    // Заполнение полей
    if (student.full_name) document.getElementById('myFullName').textContent = student.full_name;
    if (student.student_code) document.getElementById('myStudentCode').textContent = student.student_code;
    if (student.group_name) document.getElementById('myGroup').textContent = student.group_name;

    // QR код
    if (student.qr_token) {
        new QRious({
            element: document.getElementById('studentQRCode'),
            value: student.qr_token,
            size: 250,
            level: 'H'
        });
    }

    // Категория и лимиты
    const limitsBlock = document.getElementById('myLimitsBlock');
    if (assign) {
        document.getElementById('myCategory').textContent = assign.category_name;
        limitsBlock.style.display = 'block';

        if (limits) {
            document.getElementById('myDailyRemaining').textContent = limits.daily;
            document.getElementById('myWeeklyRemaining').textContent = limits.weekly;
            document.getElementById('myMonthlyRemaining').textContent = limits.monthly;
        }
    } else {
        document.getElementById('myCategory').textContent = 'Питание не назначено';
        limitsBlock.style.display = 'none';
    }
}

// Инициализация при загрузке
document.addEventListener('DOMContentLoaded', () => {
    // Ждем инициализации пользователя в app.js или грузим сами
    setTimeout(loadStudentCard, 500);

    // Кнопка сканирования (привязка события)
    const scanBtn = document.getElementById('scanCafeteriaQrBtn');
    if (scanBtn) scanBtn.onclick = scanOperatorQR;
});


// ============================================================================
// ГЛАВНАЯ ФУНКЦИЯ: СКАНИРОВАНИЕ ОПЕРАТОРА
// ============================================================================

async function scanOperatorQR() {
    console.log('🎥 Запуск сканера QR...');

    // 1. Создаем модальное окно на весь экран
    const overlay = document.createElement('div');
    overlay.style.cssText = `
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0,0,0,0.9); z-index: 999999;
        display: flex; flex-direction: column; justify-content: center; align-items: center;
    `;

    overlay.innerHTML = `
        <div style="color:white; text-align:center; margin-bottom:20px;">
            <h2 style="margin:0;">Сканирование QR</h2>
            <p>Наведите камеру на QR-код столовой</p>
        </div>
        <div id="qr-reader" style="width: 300px; height: 300px; border-radius:12px; overflow:hidden; border:2px solid #fff;"></div>
        <button id="closeScan" style="margin-top:30px; padding:12px 30px; border-radius:30px; border:none; font-size:16px; font-weight:bold; background:#fff; color:#000;">
            Закрыть
        </button>
    `;
    document.body.appendChild(overlay);

    const html5QrCode = new Html5Qrcode("qr-reader");

    // Обработчик закрытия
    const closeScanner = async () => {
        try {
            if (html5QrCode.isScanning) await html5QrCode.stop();
        } catch (e) { }
        overlay.remove();
    };
    document.getElementById('closeScan').onclick = closeScanner;

    // Успешный скан
    const onScanSuccess = async (decodedText) => {
        console.log('✅ QR найден:', decodedText);

        // Звук пика
        // new Audio('/assets/beep.mp3').play().catch(()=>{});

        await html5QrCode.stop();
        overlay.innerHTML = `<h2 style="color:white;">Обработка...</h2>`;

        // Отправка на сервер (С ИСПРАВЛЕННЫМ ИМЕНЕМ ПОЛЯ)
        try {
            const res = await fetchWithAuth('cafeteria/scan-operator', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    operator_qr: decodedText // <-- ИСПРАВЛЕНО: было operator_qr_token 
                })
            });

            if (!res.ok) {
                const err = await res.json();
                throw new Error(err.error || 'Ошибка');
            }

            const data = await res.json();

            // Показываем красивое сообщение
            overlay.innerHTML = `
                <div style="text-align:center; color:white;">
                    <i class='bx bx-check-circle' style="font-size:80px; color:#48bb78;"></i>
                    <h2 style="margin-top:20px;">${data.message || 'Успешно!'}</h2>
                    <p>Остаток на сегодня: ${data.remaining_today || 0}</p>
                    <button id="finishScan" style="margin-top:20px; padding:10px 30px; border-radius:20px; border:none;">ОК</button>
                </div>
            `;
            document.getElementById('finishScan').onclick = () => { overlay.remove(); loadStudentCard(); };

        } catch (e) {
            alert('Ошибка: ' + e.message);
            overlay.remove();
        }
    };

    // Запуск
    html5QrCode.start(
        { facingMode: "environment" },
        { fps: 10, qrbox: 250 },
        onScanSuccess,
        () => { } // Ignored errors
    ).catch(err => {
        console.error(err);
        alert('Ошибка доступа к камере. Проверьте HTTPS и разрешения.');
        overlay.remove();
    });
}
