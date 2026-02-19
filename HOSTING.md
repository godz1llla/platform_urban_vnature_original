# Инструкция по деплою на хостинг

## 📦 Подготовка файлов

### 1. Файлы для загрузки
Загрузите все файлы проекта на хостинг:
```
backend/
frontend/
database/
index.php
.htaccess
README.md
```

## 🗄️ Настройка базы данных

### 1. Создайте базу данных на хостинге
В панели управления хостингом (например, cPanel):
- Создайте новую MySQL базу данных
- Создайте пользователя MySQL
- Дайте пользователю все привилегии на эту БД

### 2. Импортируйте схему
Через phpMyAdmin или MySQL консоль:
```sql
mysql -u your_db_user -p your_db_name < database/full_database.sql
```

## ⚙️ Конфигурация

### 1. Обновите `backend/config/Database.php`

```php
private $host = 'localhost';  // Или адрес MySQL сервера хостинга
private $database = 'ваше_имя_базы';
private $username = 'ваш_пользователь_бд';
private $password = 'ваш_пароль_бд';
```

### 2. Проверьте права доступа к файлам
```bash
chmod 755 backend/
chmod 644 backend/**/*.php
chmod 755 frontend/
chmod 644 .htaccess
```

## 🌐 Проверка работы

### 1. Откройте ваш домен
```
https://yourdomain.com/
```

Должен автоматически редиректнуть на:
```
https://yourdomain.com/frontend/login.html
```

### 2. Проверьте API
```
https://yourdomain.com/backend/api.php?path=cafeteria/categories
```

Должен вернуть ошибку 401 (Unauthorized) - это нормально, значит API работает.

## 🔒 Безопасность (Production)

### 1. HTTPS
**Обязательно** используйте HTTPS. Большинство хостингов предоставляют бесплатный Let's Encrypt SSL.

### 2. Обновите .htaccess (добавьте редирект на HTTPS)
```apache
# Форсировать HTTPS
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

### 3. Сгенерируйте новый JWT Secret
В `backend/middleware/AuthMiddleware.php` замените:
```php
private static $secretKey = 'СЛУЧАЙНАЯ_СТРОКА_256_СИМВОЛОВ';
```

Сгенерировать можно так:
```bash
openssl rand -base64 64
```

### 4. Отключите debug режим
В `backend/config/Database.php` убедитесь:
```php
PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, // Оставить
```

## 📱 Для мобильного доступа

Камера будет работать **только через HTTPS**! 

Без HTTPS QR-сканер будет показывать ошибку "Не удалось получить доступ к камере".

## ✅ Чек-лист перед запуском

- [ ] База данных создана и импортирована
- [ ] `Database.php` обновлен с credentials хостинга
- [ ] HTTPS настроен
- [ ] JWT Secret изменен
- [ ] Тестовый логин работает
- [ ] API возвращает данные
- [ ] QR-сканер работает на мобильном (через HTTPS)

## 🆘 Частые проблемы

**Проблема:** 500 Internal Server Error
**Решение:** Проверьте права доступа к файлам и error_log хостинга

**Проблема:** Не подключается к БД
**Решение:** Проверьте credentials в `Database.php` и права пользователя MySQL

**Проблема:** Камера не работает
**Решение:** Убедитесь что используете HTTPS (не HTTP)

**Проблема:** 404 на API запросах
**Решение:** Убедитесь что `.htaccess` загружен и mod_rewrite включен

## 📊 Рекомендуемые хостинги

- **Beget.com** — хороший для РФ/Казахстана
- **Timeweb** — популярный в СНГ
- **DigitalOcean** — для продвинутых (VPS)
- **Heroku** — бесплатный tier (но нужна настройка)

Все они поддерживают PHP 8+ и MySQL 8.
