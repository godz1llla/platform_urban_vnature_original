<?php
require_once __DIR__ . '/../config/Database.php';

/**
 * Модель: Назначение студентов на категории льготного питания
 */
class CafeteriaAssignment
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Получить все назначения
     */
    public function getAll()
    {
        $stmt = $this->db->query("
            SELECT 
                ca.*,
                s.student_code,
                u.full_name as student_name,
                g.name as group_name,
                cat.name as category_name,
                assigner.full_name as assigned_by_name
            FROM cafeteria_assignments ca
            JOIN students s ON ca.student_id = s.id
            JOIN users u ON s.user_id = u.id
            JOIN groups g ON s.group_id = g.id
            JOIN cafeteria_categories cat ON ca.category_id = cat.id
            JOIN users assigner ON ca.assigned_by = assigner.id
            ORDER BY ca.assigned_at DESC
        ");
        return $stmt->fetchAll();
    }

    /**
     * Получить назначение студента
     */
    public function getByStudentId($studentId)
    {
        $stmt = $this->db->prepare("
            SELECT 
                ca.*,
                cat.name as category_name,
                cat.daily_limit,
                cat.weekly_limit,
                cat.monthly_limit
            FROM cafeteria_assignments ca
            JOIN cafeteria_categories cat ON ca.category_id = cat.id
            WHERE ca.student_id = ?
        ");
        $stmt->execute([$studentId]);
        return $stmt->fetch();
    }

    /**
     * Назначить студента на категорию
     */
    public function assignStudent($studentId, $categoryId, $assignedBy)
    {
        // Проверяем, не назначен ли студент уже
        $existing = $this->getByStudentId($studentId);
        if ($existing) {
            return [
                'success' => false,
                'error' => 'Студент уже назначен на категорию: ' . $existing['category_name']
            ];
        }

        $stmt = $this->db->prepare("
            INSERT INTO cafeteria_assignments 
            (student_id, category_id, assigned_by)
            VALUES (?, ?, ?)
        ");

        try {
            $stmt->execute([$studentId, $categoryId, $assignedBy]);
            return [
                'id' => $this->db->lastInsertId(),
                'success' => true
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'error' => 'Ошибка назначения: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Отменить назначение студента
     */
    public function unassign($studentId)
    {
        $stmt = $this->db->prepare("DELETE FROM cafeteria_assignments WHERE student_id = ?");
        $result = $stmt->execute([$studentId]);

        return ['success' => $result];
    }

    /**
     * Получить студентов без назначения
     */
    public function getUnassignedStudents()
    {
        $stmt = $this->db->query("
            SELECT 
                s.id,
                s.student_code,
                u.full_name,
                g.name as group_name
            FROM students s
            JOIN users u ON s.user_id = u.id
            JOIN groups g ON s.group_id = g.id
            LEFT JOIN cafeteria_assignments ca ON s.id = ca.student_id
            WHERE ca.id IS NULL
            ORDER BY u.full_name
        ");
        return $stmt->fetchAll();
    }
}
