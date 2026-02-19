<?php
require_once __DIR__ . '/../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../config/Database.php';

/**
 * Контроллер: Аутентификация
 */
class AuthController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * POST /api/auth/login
     * Авторизация пользователя
     */
    public function login()
    {
        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['email']) || empty($data['password'])) {
            $this->sendError('Email и пароль обязательны', 400);
        }

        // Поиск пользователя
        $stmt = $this->db->prepare("SELECT * FROM users WHERE email = ?");
        $stmt->execute([$data['email']]);
        $user = $stmt->fetch();

        if (!$user || !password_verify($data['password'], $user['password_hash'])) {
            $this->sendError('Неверный email или пароль', 401);
        }

        // Создание токена
        $token = AuthMiddleware::createToken($user['id'], $user['role']);

        $this->sendJson([
            'token' => $token,
            'user' => [
                'id' => $user['id'],
                'full_name' => $user['full_name'],
                'email' => $user['email'],
                'role' => $user['role']
            ]
        ]);
    }

    /**
     * GET /api/auth/me
     * Получить информацию о текущем пользователе
     */
    public function me()
    {
        $userData = AuthMiddleware::authenticate();

        $stmt = $this->db->prepare("SELECT id, full_name, email, role FROM users WHERE id = ?");
        $stmt->execute([$userData['user_id']]);
        $user = $stmt->fetch();

        $this->sendJson($user);
    }

    private function sendJson($data, $statusCode = 200)
    {
        http_response_code($statusCode);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        exit;
    }

    private function sendError($message, $statusCode = 400)
    {
        $this->sendJson(['error' => $message], $statusCode);
    }
}
