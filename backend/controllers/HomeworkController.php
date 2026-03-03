<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

class HomeworkController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    public function getAllHomework($user)
    {
        $role = $user['role'];
        $userId = $user['user_id'];

        $query = "
            SELECT 
                h.id,
                h.title,
                h.description,
                h.due_date,
                h.created_at,
                s.name as subject_name,
                u.full_name as instructor_name,
                g.name as group_name
            FROM homeworks h
            JOIN subjects s ON h.subject_id = s.id
            JOIN users u ON h.instructor_id = u.id
            JOIN `groups` g ON h.group_id = g.id
        ";

        $params = [];

        if ($role === 'student') {
            // Получаем ID группы студента
            $stmt = $this->db->prepare("SELECT group_id FROM students WHERE user_id = ?");
            $stmt->execute([$userId]);
            $student = $stmt->fetch();

            if (!$student || !$student['group_id']) {
                $this->sendJson([]);
            }

            $query .= " WHERE h.group_id = ?";
            $params[] = $student['group_id'];
        } elseif ($role === 'instructor') {
            // Преподаватель видит то, что создал сам
            $query .= " WHERE h.instructor_id = ?";
            $params[] = $userId;
        }

        $query .= " ORDER BY h.created_at DESC";

        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        $homeworks = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $this->sendJson($homeworks);
    }

    public function createHomework($user)
    {
        if ($user['role'] !== 'admin' && $user['role'] !== 'instructor') {
            $this->sendError('Нет прав на создание задания', 403);
        }

        $data = json_decode(file_get_contents('php://input'), true);

        if (empty($data['subject_id']) || empty($data['group_id']) || empty($data['title'])) {
            $this->sendError('Заполните обязательные поля (Предмет, Группа, Название)', 400);
        }

        $stmt = $this->db->prepare("
            INSERT INTO homeworks (subject_id, instructor_id, group_id, title, description, due_date)
            VALUES (?, ?, ?, ?, ?, ?)
        ");

        $stmt->execute([
            $data['subject_id'],
            $user['user_id'],
            $data['group_id'],
            $data['title'],
            $data['description'] ?? null,
            $data['due_date'] ?? null
        ]);

        $this->sendJson(['message' => 'Задание создано', 'id' => $this->db->lastInsertId()]);
    }

    public function deleteHomework($id, $user)
    {
        // Проверяем существование и права
        $stmt = $this->db->prepare("SELECT instructor_id FROM homeworks WHERE id = ?");
        $stmt->execute([$id]);
        $hw = $stmt->fetch();

        if (!$hw) {
            $this->sendError('Задание не найдено', 404);
        }

        if ($user['role'] !== 'admin' && $hw['instructor_id'] != $user['user_id']) {
            $this->sendError('Нет прав на удаление', 403);
        }

        $stmt = $this->db->prepare("DELETE FROM homeworks WHERE id = ?");
        $stmt->execute([$id]);

        $this->sendJson(['message' => 'Задание удалено']);
    }

    private function sendJson($data)
    {
        header('Content-Type: application/json');
        echo json_encode($data);
        exit;
    }

    private function sendError($message, $code = 400)
    {
        http_response_code($code);
        $this->sendJson(['error' => $message]);
    }
}
