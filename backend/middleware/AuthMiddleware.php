<?php
/**
 * JWT Authentication Middleware
 * Проверка токена и авторизация пользователя
 */

class AuthMiddleware
{
    private static $secretKey = 'urban_college_secret_key_2026'; // В продакшене использовать .env

    /**
     * Проверить токен из заголовка Authorization
     */
    public static function authenticate()
    {
        $headers = getallheaders();

        if (!isset($headers['Authorization'])) {
            self::sendError('Токен авторизации не предоставлен', 401);
        }

        $authHeader = $headers['Authorization'];

        // Ожидаем формат: "Bearer <token>"
        if (!preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
            self::sendError('Неверный формат токена', 401);
        }

        $token = $matches[1];

        try {
            $payload = self::decodeToken($token);
            return $payload;
        } catch (Exception $e) {
            self::sendError('Недействительный токен: ' . $e->getMessage(), 401);
        }
    }

    /**
     * Проверить роль пользователя
     */
    public static function requireRole($allowedRoles)
    {
        $user = self::authenticate();

        if (!in_array($user['role'], $allowedRoles)) {
            self::sendError('Недостаточно прав доступа', 403);
        }

        return $user;
    }

    /**
     * Получить текущего пользователя (просто вызов authenticate)
     */
    public static function getCurrentUser()
    {
        return self::authenticate();
    }


    /**
     * Декодировать JWT токен (упрощённая версия)
     */
    private static function decodeToken($token)
    {
        $parts = explode('.', $token);

        if (count($parts) !== 3) {
            throw new Exception('Неверный формат JWT');
        }

        list($header, $payload, $signature) = $parts;

        // Проверка подписи
        $expectedSignature = hash_hmac('sha256', "$header.$payload", self::$secretKey);
        $actualSignature = base64_decode(strtr($signature, '-_', '+/'));

        if (!hash_equals($expectedSignature, $actualSignature)) {
            throw new Exception('Подпись не совпадает');
        }

        // Декодирование payload
        $data = json_decode(base64_decode(strtr($payload, '-_', '+/')), true);

        // Проверка срока действия
        if (isset($data['exp']) && time() > $data['exp']) {
            throw new Exception('Токен истёк');
        }

        return $data;
    }

    /**
     * Создать JWT токен
     */
    public static function createToken($userId, $role, $expiresIn = 86400)
    {
        $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);

        $payload = json_encode([
            'user_id' => $userId,
            'role' => $role,
            'iat' => time(),
            'exp' => time() + $expiresIn
        ]);

        $base64UrlHeader = strtr(base64_encode($header), '+/', '-_');
        $base64UrlPayload = strtr(base64_encode($payload), '+/', '-_');

        $signature = hash_hmac('sha256', "$base64UrlHeader.$base64UrlPayload", self::$secretKey);
        $base64UrlSignature = strtr(base64_encode($signature), '+/', '-_');

        return "$base64UrlHeader.$base64UrlPayload.$base64UrlSignature";
    }

    /**
     * Отправить ошибку и завершить выполнение
     */
    private static function sendError($message, $statusCode = 400)
    {
        http_response_code($statusCode);
        echo json_encode(['error' => $message]);
        exit;
    }
}
