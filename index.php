<?php
/**
 * Главная страница - автоматический редирект на login
 */

// Проверяем авторизацию
session_start();

// Если есть токен в localStorage (проверяется JS), редирект на dashboard
// Иначе редирект на login
header('Location: /frontend/login.html');
exit;
