<?php
require_once __DIR__ . '/../models/CafeteriaCategory.php';
require_once __DIR__ . '/../models/CafeteriaAssignment.php';
require_once __DIR__ . '/../models/CafeteriaTransaction.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../config/Database.php'; // Добавил, чтобы точно был доступ к БД

/**
 * Контроллер: Модуль столовой
 */
class CafeteriaController
{
    private $categoryModel;
    private $assignmentModel;
    private $transactionModel;
    private $db; // Добавил для прямых запросов

    public function __construct()
    {
        $this->categoryModel = new CafeteriaCategory();
        $this->assignmentModel = new CafeteriaAssignment();
        $this->transactionModel = new CafeteriaTransaction();
        $this->db = Database::getInstance()->getConnection(); // Инициализация
    }

    /**
     * GET /api/cafeteria/categories
     */
    public function getCategories()
    {
        AuthMiddleware::authenticate();
        $categories = $this->categoryModel->getAll();
        $this->sendJson($categories);
    }

    /**
     * POST /api/cafeteria/categories
     */
    public function createCategory()
    {
        $user = AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        if (
            empty($data['name']) || !isset($data['daily_limit']) ||
            !isset($data['weekly_limit']) || !isset($data['monthly_limit'])
        ) {
            $this->sendError('Не все обязательные поля заполнены', 400);
        }

        $data['created_by'] = $user['user_id'];
        $result = $this->categoryModel->create($data);
        $this->sendJson($result, 201);
    }

    /**
     * PUT /api/cafeteria/categories/:id
     */
    public function updateCategory($id)
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();
        $result = $this->categoryModel->update($id, $data);
        $this->sendJson($result);
    }

    /**
     * DELETE /api/cafeteria/categories/:id
     */
    public function deleteCategory($id)
    {
        AuthMiddleware::requireRole(['admin']);
        $result = $this->categoryModel->delete($id);
        $this->sendJson($result);
    }

    /**
     * GET /api/cafeteria/assignments
     */
    public function getAssignments()
    {
        AuthMiddleware::requireRole(['admin', 'cafeteria_operator']);
        $assignments = $this->assignmentModel->getAll();
        $this->sendJson($assignments);
    }

    /**
     * GET /api/cafeteria/assignments/unassigned
     */
    public function getUnassignedStudents()
    {
        AuthMiddleware::requireRole(['admin']);
        $students = $this->assignmentModel->getUnassignedStudents();
        $this->sendJson($students);
    }

    /**
     * POST /api/cafeteria/assign
     * Назначить студента на категорию [Admin only]
     */
    public function assignStudent()
    {
        $user = AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        // На фронте это поле называется student_id, но по факту там лежит user_id из таблицы users
        $userId = $data['student_id'] ?? null;
        $categoryId = $data['category_id'] ?? null;

        if (empty($userId) || empty($categoryId)) {
            $this->sendError('Не указан студент или категория', 400);
        }

        // !!! ИСПРАВЛЕНИЕ: Конвертируем user_id в student_id !!!
        $stmt = $this->db->prepare("SELECT id FROM students WHERE user_id = ?");
        $stmt->execute([$userId]);
        $studentRow = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$studentRow) {
            // Попробуем, вдруг прислали уже правильный student_id (на всякий случай)
            $stmt2 = $this->db->prepare("SELECT id FROM students WHERE id = ?");
            $stmt2->execute([$userId]);
            if ($stmt2->fetch()) {
                $realStudentId = $userId;
            } else {
                $this->sendError('Студент не найден (проверьте таблицу students)', 404);
            }
        } else {
            $realStudentId = $studentRow['id'];
        }

        // Теперь сохраняем с правильным ID
        $result = $this->assignmentModel->assignStudent(
            $realStudentId,
            $categoryId,
            $user['user_id']
        );

        $this->sendJson($result, $result['success'] ? 201 : 400);
    }

    /**
     * DELETE /api/cafeteria/assign/:studentId
     */
    public function unassignStudent($studentId)
    {
        AuthMiddleware::requireRole(['admin']);

        // Здесь studentId приходит из списка, где он уже является student_id (см. getAssignments), так что конвертация не нужна
        $result = $this->assignmentModel->unassign($studentId);
        $this->sendJson($result);
    }

    /**
     * POST /api/cafeteria/serve
     */
    public function serveMeal()
    {
        $user = AuthMiddleware::requireRole(['cafeteria_operator', 'admin']);
        $data = $this->getRequestData();

        if (empty($data['student_id']) || empty($data['qr_identifier'])) {
            $this->sendError('Не указан студент или QR код', 400);
        }

        $result = $this->transactionModel->serveMeal(
            $data['student_id'],
            $user['user_id'],
            $data['qr_identifier']
        );

        $this->sendJson($result, $result['success'] ? 201 : 400);
    }

    /**
     * GET /api/cafeteria/serve/check/:studentId
     */
    public function checkStudent($studentId)
    {
        AuthMiddleware::requireRole(['cafeteria_operator', 'admin']);

        $stmt = $this->db->prepare("
            SELECT 
                s.id,
                s.student_code,
                s.qr_token,
                u.full_name,
                g.name as group_name
            FROM students s
            JOIN users u ON s.user_id = u.id
            JOIN groups g ON s.group_id = g.id
            WHERE s.id = ?
        ");
        $stmt->execute([$studentId]);
        $student = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$student) {
            $this->sendError('Студент не найден', 404);
        }

        $assignment = $this->assignmentModel->getByStudentId($studentId);

        if (!$assignment) {
            $this->sendJson([
                'allowed' => false,
                'student' => $student,
                'error' => 'Студент не назначен ни на одну категорию'
            ]);
            return;
        }

        if ($this->transactionModel->hasServedToday($studentId)) {
            $this->sendJson([
                'allowed' => false,
                'student' => $student,
                'assignment' => $assignment,
                'error' => 'Студент уже получил питание сегодня'
            ]);
            return;
        }

        $limitsCheck = $this->transactionModel->checkLimits($studentId, $assignment['category_id']);

        $this->sendJson([
            'allowed' => $limitsCheck['allowed'],
            'student' => $student,
            'assignment' => $assignment,
            'limits' => $limitsCheck['remaining'] ?? null,
            'error' => $limitsCheck['error'] ?? null
        ]);
    }

    /**
     * GET /api/cafeteria/transactions
     */
    public function getTransactions()
    {
        AuthMiddleware::requireRole(['admin', 'cafeteria_operator']);

        $filters = [
            'student_id' => $_GET['student_id'] ?? null,
            'category_id' => $_GET['category_id'] ?? null,
            'from' => $_GET['from'] ?? null,
            'to' => $_GET['to'] ?? null,
            'limit' => $_GET['limit'] ?? 100
        ];

        $transactions = $this->transactionModel->getTransactions($filters);
        $this->sendJson($transactions);
    }

    /**
     * GET /api/cafeteria/transactions/export
     */
    public function exportTransactions()
    {
        AuthMiddleware::requireRole(['admin', 'cafeteria_operator']);

        $filters = [
            'student_id' => $_GET['student_id'] ?? null,
            'category_id' => $_GET['category_id'] ?? null,
            'from' => $_GET['from'] ?? null,
            'to' => $_GET['to'] ?? null
        ];

        $csv = $this->transactionModel->exportCSV($filters);

        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="cafeteria_transactions_' . date('Y-m-d') . '.csv"');
        echo "\xEF\xBB\xBF";
        echo $csv;
        exit;
    }

    /**
     * GET /api/cafeteria/operator-qr
     */
    public function getOperatorQR()
    {
        $user = AuthMiddleware::requireRole(['admin', 'cafeteria_operator']);
        $qrToken = 'CAFETERIA_OPERATOR_' . $user['user_id'];
        $this->sendJson([
            'qr_token' => $qrToken,
            'operator_name' => $user['full_name']
        ]);
    }

    /**
     * POST /api/cafeteria/scan-operator
     */
    public function scanOperator()
    {
        $user = AuthMiddleware::requireRole(['student']);
        $data = $this->getRequestData();
        $operatorQR = $data['operator_qr'] ?? null;

        if (!$operatorQR)
            $this->sendError('QR-код оператора не указан', 400);

        if (!preg_match('/^CAFETERIA_OPERATOR_(\d+)$/', $operatorQR, $matches)) {
            $this->sendError('Неверный формат QR-кода', 400);
        }

        $operatorId = (int) $matches[1];

        $stmt = $this->db->prepare("SELECT id FROM students WHERE user_id = ?");
        $stmt->execute([$user['user_id']]);
        $student = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$student)
            $this->sendError('Профиль студента не найден', 404);

        $studentId = $student['id'];

        $stmt = $this->db->prepare("
            SELECT ca.id, ca.category_id, cc.name, cc.daily_limit, cc.weekly_limit, cc.monthly_limit
            FROM cafeteria_assignments ca
            JOIN cafeteria_categories cc ON ca.category_id = cc.id
            WHERE ca.student_id = ?
        ");
        $stmt->execute([$studentId]);
        $assignment = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$assignment)
            $this->sendError('У вас нет доступа к столовой', 403);

        $today = date('Y-m-d');
        $weekStart = date('Y-m-d', strtotime('monday this week'));
        $monthStart = date('Y-m-01');

        $stmt = $this->db->prepare("SELECT COUNT(*) as count FROM cafeteria_transactions WHERE student_id = ? AND DATE(served_at) = ?");
        $stmt->execute([$studentId, $today]);
        $dailyUsed = $stmt->fetch()['count'];

        if ($dailyUsed >= $assignment['daily_limit'])
            $this->sendError('Дневной лимит исчерпан', 403);

        $stmt = $this->db->prepare("SELECT COUNT(*) as count FROM cafeteria_transactions WHERE student_id = ? AND DATE(served_at) >= ?");
        $stmt->execute([$studentId, $weekStart]);
        $weeklyUsed = $stmt->fetch()['count'];

        if ($weeklyUsed >= $assignment['weekly_limit'])
            $this->sendError('Недельный лимит исчерпан', 403);

        $stmt = $this->db->prepare("SELECT COUNT(*) as count FROM cafeteria_transactions WHERE student_id = ? AND DATE(served_at) >= ?");
        $stmt->execute([$studentId, $monthStart]);
        $monthlyUsed = $stmt->fetch()['count'];

        if ($monthlyUsed >= $assignment['monthly_limit'])
            $this->sendError('Месячный лимит исчерпан', 403);

        $stmt = $this->db->prepare("INSERT INTO cafeteria_transactions (student_id, category_id, operator_id) VALUES (?, ?, ?)");
        $stmt->execute([$studentId, $assignment['category_id'], $operatorId]);

        $this->sendJson([
            'success' => true,
            'message' => 'Порция получена!',
            'category' => $assignment['name'],
            'remaining_today' => $assignment['daily_limit'] - $dailyUsed - 1
        ]);
    }

    private function getRequestData()
    {
        return json_decode(file_get_contents('php://input'), true) ?? [];
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