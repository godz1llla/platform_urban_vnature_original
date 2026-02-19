<?php
require_once __DIR__ . '/../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../config/Database.php';

/**
 * Контроллер: Студенты
 */
class StudentController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/students
     * GET /api/students?code=XXX
     * Получить список всех студентов или одного по коду/QR
     */
    public function getAllStudents()
    {
        AuthMiddleware::requireRole(['admin', 'cafeteria_operator', 'instructor']);

        // Если передан параметр code, ищем конкретного студента
        $code = $_GET['code'] ?? null;

        if ($code) {
            // Поиск по student_code ИЛИ qr_token
            $stmt = $this->db->prepare("
                SELECT 
                    s.id,
                    s.student_code,
                    s.qr_token,
                    u.full_name,
                    g.id as group_id,
                    g.name as group_name
                FROM students s
                JOIN users u ON s.user_id = u.id
                JOIN `groups` g ON s.group_id = g.id
                WHERE s.student_code = ? OR s.qr_token = ?
            ");
            $stmt->execute([$code, $code]);
            $student = $stmt->fetch();

            if (!$student) {
                $this->sendError('Студент не найден', 404);
            }

            $this->sendJson($student);
        } else {
            // Получить всех студентов
            $stmt = $this->db->prepare("
                SELECT 
                    s.id,
                    s.student_code,
                    u.full_name,
                    g.id as group_id,
                    g.name as group_name
                FROM students s
                JOIN users u ON s.user_id = u.id
                JOIN `groups` g ON s.group_id = g.id
                ORDER BY s.student_code ASC
            ");
            $stmt->execute();
            $students = $stmt->fetchAll();

            $this->sendJson($students);
        }
    }

    /**
     * GET /api/students/my-info
     * Получить полную информацию о текущем студенте
     */
    public function getMyInfo()
    {
        $user = AuthMiddleware::requireRole(['student']);

        // Получаем данные студента
        $stmt = $this->db->prepare("
            SELECT 
                s.id,
                s.student_code,
                s.qr_token,
                u.id as user_id,
                u.full_name,
                u.email,
                g.id as group_id,
                g.name as group_name,
                g.course
            FROM students s
            JOIN users u ON s.user_id = u.id
            JOIN groups g ON s.group_id = g.id
            WHERE s.user_id = ?
        ");
        $stmt->execute([$user['user_id']]);
        $student = $stmt->fetch();

        if (!$student) {
            $this->sendError('Студент не найден', 404);
        }

        // Получаем назначение категории
        $stmt = $this->db->prepare("
            SELECT 
                ca.id as assignment_id,
                ca.assigned_at,
                cc.id as category_id,
                cc.name as category_name,
                cc.daily_limit,
                cc.weekly_limit,
                cc.monthly_limit
            FROM cafeteria_assignments ca
            JOIN cafeteria_categories cc ON ca.category_id = cc.id
            WHERE ca.student_id = ?
        ");
        $stmt->execute([$student['id']]);
        $assignment = $stmt->fetch();

        // Если есть назначение, получаем лимиты
        $limits = null;
        if ($assignment) {
            // Подсчет транзакций
            $today = date('Y-m-d');
            $weekStart = date('Y-m-d', strtotime('monday this week'));
            $monthStart = date('Y-m-01');

            // Суточные
            $stmt = $this->db->prepare("
                SELECT COUNT(*) as count 
                FROM cafeteria_transactions 
                WHERE student_id = ? AND DATE(served_at) = ?
            ");
            $stmt->execute([$student['id'], $today]);
            $dailyUsed = $stmt->fetch()['count'];

            // Недельные
            $stmt = $this->db->prepare("
                SELECT COUNT(*) as count 
                FROM cafeteria_transactions 
                WHERE student_id = ? AND DATE(served_at) >= ?
            ");
            $stmt->execute([$student['id'], $weekStart]);
            $weeklyUsed = $stmt->fetch()['count'];

            // Месячные
            $stmt = $this->db->prepare("
                SELECT COUNT(*) as count 
                FROM cafeteria_transactions 
                WHERE student_id = ? AND DATE(served_at) >= ?
            ");
            $stmt->execute([$student['id'], $monthStart]);
            $monthlyUsed = $stmt->fetch()['count'];

            $limits = [
                'daily' => max(0, $assignment['daily_limit'] - $dailyUsed),
                'weekly' => max(0, $assignment['weekly_limit'] - $weeklyUsed),
                'monthly' => max(0, $assignment['monthly_limit'] - $monthlyUsed)
            ];
        }

        // Получаем последние транзакции
        $stmt = $this->db->prepare("
            SELECT 
                ct.id,
                ct.served_at,
                cc.name as category_name,
                u.full_name as operator_name
            FROM cafeteria_transactions ct
            JOIN cafeteria_categories cc ON ct.category_id = cc.id
            JOIN users u ON ct.operator_id = u.id
            WHERE ct.student_id = ?
            ORDER BY ct.served_at DESC
            LIMIT 5
        ");
        $stmt->execute([$student['id']]);
        $recentTransactions = $stmt->fetchAll();

        $this->sendJson([
            'student' => $student,
            'assignment' => $assignment,
            'limits' => $limits,
            'recent_transactions' => $recentTransactions
        ]);
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
