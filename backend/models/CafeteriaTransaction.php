<?php
require_once __DIR__ . '/../config/Database.php';

/**
 * Модель: Транзакции выдачи питания
 */
class CafeteriaTransaction
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Выдать питание студенту
     */
    public function serveMeal($studentId, $operatorId, $qrIdentifier)
    {
        // 1. Проверяем назначение студента
        require_once __DIR__ . '/CafeteriaAssignment.php';
        $assignmentModel = new CafeteriaAssignment();
        $assignment = $assignmentModel->getByStudentId($studentId);

        if (!$assignment) {
            return [
                'success' => false,
                'error' => 'Студент не назначен ни на одну категорию льготного питания'
            ];
        }

        // 2. Проверяем, не получал ли студент питание сегодня
        if ($this->hasServedToday($studentId)) {
            return [
                'success' => false,
                'error' => 'Студент уже получил питание сегодня'
            ];
        }

        // 3. Проверяем лимиты
        $limitsCheck = $this->checkLimits($studentId, $assignment['category_id']);
        if (!$limitsCheck['allowed']) {
            return [
                'success' => false,
                'error' => $limitsCheck['error']
            ];
        }

        // 4. Записываем транзакцию
        $stmt = $this->db->prepare("
            INSERT INTO cafeteria_transactions 
            (student_id, category_id, operator_id, qr_identifier)
            VALUES (?, ?, ?, ?)
        ");

        $stmt->execute([
            $studentId,
            $assignment['category_id'],
            $operatorId,
            $qrIdentifier
        ]);

        return [
            'success' => true,
            'transaction_id' => $this->db->lastInsertId(),
            'message' => 'Питание успешно выдано'
        ];
    }

    /**
     * Проверка: получал ли студент питание сегодня
     */
    public function hasServedToday($studentId)
    {
        $stmt = $this->db->prepare("
            SELECT COUNT(*) as count
            FROM cafeteria_transactions
            WHERE student_id = ? 
            AND DATE(served_at) = CURDATE()
        ");
        $stmt->execute([$studentId]);
        $result = $stmt->fetch();

        return $result['count'] > 0;
    }

    /**
     * Проверка лимитов (суточный/недельный/месячный)
     */
    public function checkLimits($studentId, $categoryId)
    {
        // Получаем лимиты категории
        require_once __DIR__ . '/CafeteriaCategory.php';
        $categoryModel = new CafeteriaCategory();
        $category = $categoryModel->getById($categoryId);

        if (!$category) {
            return ['allowed' => false, 'error' => 'Категория не найдена'];
        }

        // Проверка суточного лимита
        $dailyCount = $this->getCountByPeriod($studentId, 'day');
        if ($dailyCount >= $category['daily_limit']) {
            return [
                'allowed' => false,
                'error' => "Суточный лимит исчерпан ({$category['daily_limit']} порций)"
            ];
        }

        // Проверка недельного лимита
        $weeklyCount = $this->getCountByPeriod($studentId, 'week');
        if ($weeklyCount >= $category['weekly_limit']) {
            return [
                'allowed' => false,
                'error' => "Недельный лимит исчерпан ({$category['weekly_limit']} порций)"
            ];
        }

        // Проверка месячного лимита
        $monthlyCount = $this->getCountByPeriod($studentId, 'month');
        if ($monthlyCount >= $category['monthly_limit']) {
            return [
                'allowed' => false,
                'error' => "Месячный лимит исчерпан ({$category['monthly_limit']} порций)"
            ];
        }

        return [
            'allowed' => true,
            'remaining' => [
                'daily' => $category['daily_limit'] - $dailyCount,
                'weekly' => $category['weekly_limit'] - $weeklyCount,
                'monthly' => $category['monthly_limit'] - $monthlyCount
            ]
        ];
    }

    /**
     * Получить количество выдач за период
     */
    private function getCountByPeriod($studentId, $period)
    {
        $dateCondition = '';

        switch ($period) {
            case 'day':
                $dateCondition = 'DATE(served_at) = CURDATE()';
                break;
            case 'week':
                $dateCondition = 'YEARWEEK(served_at, 1) = YEARWEEK(CURDATE(), 1)';
                break;
            case 'month':
                $dateCondition = 'YEAR(served_at) = YEAR(CURDATE()) AND MONTH(served_at) = MONTH(CURDATE())';
                break;
        }

        $stmt = $this->db->prepare("
            SELECT COUNT(*) as count
            FROM cafeteria_transactions
            WHERE student_id = ? AND $dateCondition
        ");
        $stmt->execute([$studentId]);
        $result = $stmt->fetch();

        return (int) $result['count'];
    }

    /**
     * Получить транзакции с фильтрацией
     */
    public function getTransactions($filters = [])
    {
        $sql = "
            SELECT 
                ct.*,
                s.student_code,
                u.full_name as student_name,
                cat.name as category_name,
                op.full_name as operator_name
            FROM cafeteria_transactions ct
            JOIN students s ON ct.student_id = s.id
            JOIN users u ON s.user_id = u.id
            JOIN cafeteria_categories cat ON ct.category_id = cat.id
            JOIN users op ON ct.operator_id = op.id
            WHERE 1=1
        ";

        $params = [];

        if (!empty($filters['student_id'])) {
            $sql .= " AND ct.student_id = ?";
            $params[] = $filters['student_id'];
        }

        if (!empty($filters['category_id'])) {
            $sql .= " AND ct.category_id = ?";
            $params[] = $filters['category_id'];
        }

        if (!empty($filters['from'])) {
            $sql .= " AND DATE(ct.served_at) >= ?";
            $params[] = $filters['from'];
        }

        if (!empty($filters['to'])) {
            $sql .= " AND DATE(ct.served_at) <= ?";
            $params[] = $filters['to'];
        }

        $sql .= " ORDER BY ct.served_at DESC";

        if (!empty($filters['limit'])) {
            $sql .= " LIMIT " . (int) $filters['limit'];
        }

        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);

        return $stmt->fetchAll();
    }

    /**
     * Экспорт транзакций в CSV
     */
    public function exportCSV($filters = [])
    {
        $transactions = $this->getTransactions($filters);

        $csv = "ID,Код студента,ФИО студента,Категория,Оператор,QR код,Дата выдачи\n";

        foreach ($transactions as $t) {
            $csv .= implode(',', [
                $t['id'],
                $t['student_code'],
                '"' . $t['student_name'] . '"',
                '"' . $t['category_name'] . '"',
                '"' . $t['operator_name'] . '"',
                $t['qr_identifier'],
                $t['served_at']
            ]) . "\n";
        }

        return $csv;
    }
}
