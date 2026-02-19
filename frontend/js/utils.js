// Утилиты для работы с API и UI

const API_URL = '/backend/api.php';

// Получить токен из localStorage
function getToken() {
    return localStorage.getItem('auth_token');
}

// Сохранить токен
function setToken(token) {
    localStorage.setItem('auth_token', token);
}

// Удалить токен
function removeToken() {
    localStorage.removeItem('auth_token');
}

// Fetch с авторизацией
async function fetchWithAuth(path, options = {}) {
    const token = getToken();

    const headers = {
        'Content-Type': 'application/json',
        ...options.headers
    };

    if (token) {
        headers['Authorization'] = `Bearer ${token}`;
    }

    const response = await fetch(`${API_URL}?path=${path}`, {
        ...options,
        headers
    });

    if (response.status === 401) {
        // Токен истёк или недействителен
        removeToken();
        window.location.href = '/frontend/login.html';
        throw new Error('Unauthorized');
    }

    return response;
}

// Показать toast уведомление
function showToast(message, type = 'info') {
    const container = document.getElementById('toastContainer');

    const toast = document.createElement('div');
    toast.className = `toast ${type}`;

    const icon = type === 'success' ? 'bx-check-circle' :
        type === 'error' ? 'bx-error-circle' :
            'bx-info-circle';

    toast.innerHTML = `
        <i class='bx ${icon}'></i>
        <span>${message}</span>
    `;

    container.appendChild(toast);

    // Автоматически убрать через 3 секунды
    setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Форматирование даты
function formatDate(dateString) {
    const date = new Date(dateString);
    const options = {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    };
    return date.toLocaleDateString('ru-RU', options);
}

// Форматирование даты (только дата)
function formatDateOnly(dateString) {
    const date = new Date(dateString);
    const options = {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    };
    return date.toLocaleDateString('ru-RU', options);
}

// Дебаунс для оптимизации событий
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Детекция мобильных устройств
function isMobile() {
    return window.innerWidth <= 768;
}

// Детекция touch устройств
function isTouchDevice() {
    return ('ontouchstart' in window) ||
        (navigator.maxTouchPoints > 0) ||
        (navigator.msMaxTouchPoints > 0);
}

// Обработка ошибок API
async function handleApiError(response) {
    const data = await response.json();
    const errorMessage = data.error || 'Произошла ошибка';
    showToast(errorMessage, 'error');
    return null;
}

// Экспорт в CSV
function downloadCSV(csvContent, filename) {
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);

    link.setAttribute('href', url);
    link.setAttribute('download', filename);
    link.style.visibility = 'hidden';

    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}
