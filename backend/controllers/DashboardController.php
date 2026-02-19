<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

class DashboardController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/dashboard/stats
     * Получить статистику для дашборда (разная для ролей)
     */
    public function getStats()
    {
        $user = AuthMiddleware::authenticate();
        $role = $user['role'];
        $stats = [];

        try {
            if ($role === 'student') {
                $stats = $this->getStudentStats($user['user_id']);
            } elseif ($role === 'admin') {
                $stats = $this->getAdminStats();
            } elseif ($role === 'cafeteria_operator') {
                $stats = $this->getOperatorStats($user['user_id']);
            } else {
                // Преподаватель или другая роль
                $stats = [
                    'message' => 'Добро пожаловать в URBAN COLLEGE'
                ];
            }

            $this->sendJson($stats);

        } catch (Exception $e) {
            $this->sendError('Ошибка получения статистики: ' . $e->getMessage());
        }
    }

    // Статистика для студента
    private function getStudentStats($userId)
    {
        // 1. Получить ID студента
        $stmt = $this->db->prepare("SELECT id, student_code, group_id FROM students WHERE user_id = ?");
        $stmt->execute([$userId]);
        $student = $stmt->fetch();

        if (!$student) {
            return ['error' => 'Профиль студента не найден'];
        }

        // 2. Статус питания (назначена ли категория)
        $stmt = $this->db->prepare("
            SELECT cc.name, cc.daily_limit 
            FROM cafeteria_assignments ca
            JOIN cafeteria_categories cc ON ca.category_id = cc.id
            WHERE ca.student_id = ?
        ");
        $stmt->execute([$student['id']]);
        $assignment = $stmt->fetch();

        // 3. Использовано сегодня
        $today = date('Y-m-d');
        $stmt = $this->db->prepare("
            SELECT COUNT(*) as count 
            FROM cafeteria_transactions 
            WHERE student_id = ? AND DATE(served_at) = ?
        ");
        $stmt->execute([$student['id'], $today]);
        $usedToday = $stmt->fetch()['count'];

        return [
            'role' => 'student',
            'student_id' => $student['id'],
            'student_code' => $student['student_code'],
            'cafeteria' => [
                'has_assignment' => (bool) $assignment,
                'category_name' => $assignment ? $assignment['name'] : null,
                'daily_limit' => $assignment ? $assignment['daily_limit'] : 0,
                'used_today' => $usedToday,
                'remaining' => $assignment ? max(0, $assignment['daily_limit'] - $usedToday) : 0
            ],
            // Заглушки для будущих модулей
            'attendance' => [
                'present_today' => true, // TODO: Реализовать модуль посещаемости
                'percentage' => 95
            ]
        ];
    }

    // Статистика для админа
    private function getAdminStats()
    {
        // 1. Всего студентов
        $stmt = $this->db->query("SELECT COUNT(*) as total FROM students");
        $totalStudents = $stmt->fetch()['total'];

        // 2. Выдано обедов сегодня
        $today = date('Y-m-d');
        $stmt = $this->db->prepare("SELECT COUNT(*) as total FROM cafeteria_transactions WHERE DATE(served_at) = ?");
        $stmt->execute([$today]);
        $mealsServedToday = $stmt->fetch()['total'];

        // 3. Активные назначения питания
        $stmt = $this->db->query("SELECT COUNT(*) as total FROM cafeteria_assignments");
        $totalAssignments = $stmt->fetch()['total'];

        return [
            'role' => 'admin',
            'students_count' => $totalStudents,
            'cafeteria' => [
                'meals_served_today' => $mealsServedToday,
                'active_assignments' => $totalAssignments
            ]
        ];
    }

    // Статистика для оператора
    private function getOperatorStats($userId)
    {
        $today = date('Y-m-d');

        // 1. Выдано ЛИЧНО оператором сегодня
        $stmt = $this->db->prepare("
            SELECT COUNT(*) as total 
            FROM cafeteria_transactions 
            WHERE operator_id = ? AND DATE(served_at) = ?
        ");
        $stmt->execute([$userId, $today]);
        $servedByMe = $stmt->fetch()['total'];

        // 2. Всего выдано в столовой сегодня
        $stmt = $this->db->prepare("SELECT COUNT(*) as total FROM cafeteria_transactions WHERE DATE(served_at) = ?");
        $stmt->execute([$today]);
        $totalServed = $stmt->fetch()['total'];

        return [
            'role' => 'cafeteria_operator',
            'served_by_me' => $servedByMe,
            'total_served_today' => $totalServed
        ];
    }

    private function sendJson($data, $statusCode = 200)
    {
        http_response_code($statusCode);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        exit;
    }

    private function sendError($message, $statusCode = 500)
    {
        $this->sendJson(['error' => $message], $statusCode);
    }
}
