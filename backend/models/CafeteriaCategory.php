<?php
require_once __DIR__ . '/../config/Database.php';

/**
 * Модель: Категории льготного питания
 */
class CafeteriaCategory
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Получить все категории
     */
    public function getAll()
    {
        $stmt = $this->db->query("
            SELECT c.*, u.full_name as created_by_name
            FROM cafeteria_categories c
            LEFT JOIN users u ON c.created_by = u.id
            ORDER BY c.created_at DESC
        ");
        return $stmt->fetchAll();
    }

    /**
     * Получить категорию по ID
     */
    public function getById($id)
    {
        $stmt = $this->db->prepare("
            SELECT c.*, u.full_name as created_by_name
            FROM cafeteria_categories c
            LEFT JOIN users u ON c.created_by = u.id
            WHERE c.id = ?
        ");
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    /**
     * Создать новую категорию
     */
    public function create($data)
    {
        $stmt = $this->db->prepare("
            INSERT INTO cafeteria_categories 
            (name, daily_limit, weekly_limit, monthly_limit, price_per_portion, created_by)
            VALUES (?, ?, ?, ?, ?, ?)
        ");

        $stmt->execute([
            $data['name'],
            $data['daily_limit'],
            $data['weekly_limit'],
            $data['monthly_limit'],
            $data['price_per_portion'] ?? 0.00,
            $data['created_by']
        ]);

        return [
            'id' => $this->db->lastInsertId(),
            'success' => true
        ];
    }

    /**
     * Обновить категорию
     */
    public function update($id, $data)
    {
        $stmt = $this->db->prepare("
            UPDATE cafeteria_categories 
            SET name = ?, 
                daily_limit = ?, 
                weekly_limit = ?, 
                monthly_limit = ?,
                price_per_portion = ?
            WHERE id = ?
        ");

        $result = $stmt->execute([
            $data['name'],
            $data['daily_limit'],
            $data['weekly_limit'],
            $data['monthly_limit'],
            $data['price_per_portion'] ?? 0.00,
            $id
        ]);

        return ['success' => $result];
    }

    /**
     * Удалить категорию
     */
    public function delete($id)
    {
        // 1. Проверяем активные назначения
        $checkStmt = $this->db->prepare("
            SELECT COUNT(*) as count 
            FROM cafeteria_assignments 
            WHERE category_id = ?
        ");
        $checkStmt->execute([$id]);

        if ($checkStmt->fetch()['count'] > 0) {
            return [
                'success' => false,
                'error' => 'Нельзя удалить: есть назначенные студенты.'
            ];
        }

        try {
            // 2. Пытаемся удалить
            $stmt = $this->db->prepare("DELETE FROM cafeteria_categories WHERE id = ?");
            $stmt->execute([$id]);
            return ['success' => true];
        } catch (PDOException $e) {
            // 3. Если база не дает удалить (код 23000 - есть связанные записи в транзакциях)
            return [
                'success' => false,
                'error' => 'Нельзя удалить: по этой категории уже выдавалось питание (есть в истории).'
            ];
        }
    }
}
