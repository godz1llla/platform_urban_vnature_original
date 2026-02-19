<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

class GroupsController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/groups
     * Получить все группы с количеством студентов
     */
    public function getAllGroups()
    {
        AuthMiddleware::requireRole(['admin', 'instructor', 'curator', 'student']); // Allow all authenticated for list? Or restrict? Let's restrict.
        // Actually, previous code was just authenticate().
        // Let's keep it open or restrict?
        // "Curator needs access to groups".
        // Let's use requireRole(['admin', 'instructor', 'curator', 'student']) if we want to mimic authenticate() but being explicit.
        // Or just leave it as authenticate() if curators are authenticated users.
        // Wait, I should probably check if students should see ALL groups.
        // The previous code `AuthMiddleware::authenticate()` allows ANYONE.
        // So I don't strictly *need* to change getAllGroups if it's open to all.
        // BUT `getGroupStudents` WAS restricted to admin. I MUST change that.
        // I will only change getGroupStudents for now to be safe, regarding getAllGroups.
        AuthMiddleware::authenticate();

        $query = "
            SELECT 
                g.id,
                g.name,
                g.course,
                g.created_at,
                COUNT(s.id) as student_count
            FROM `groups` g
            LEFT JOIN students s ON g.id = s.group_id
            GROUP BY g.id
            ORDER BY g.course ASC, g.name ASC
        ";

        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $groups = $stmt->fetchAll();

        $this->sendJson($groups);
    }

    /**
     * POST /api/groups
     * Создать новую группу
     */
    public function createGroup()
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        $name = $data['name'] ?? null;
        $course = $data['course'] ?? 1;

        if (!$name) {
            $this->sendError('Название группы обязательно', 400);
        }

        // Проверка уникальности
        $stmt = $this->db->prepare("SELECT id FROM `groups` WHERE name = ?");
        $stmt->execute([$name]);
        if ($stmt->fetch()) {
            $this->sendError('Группа с таким названием уже существует', 400);
        }

        // Создать группу
        $stmt = $this->db->prepare("INSERT INTO `groups` (name, course) VALUES (?, ?)");
        $stmt->execute([$name, $course]);
        $groupId = $this->db->lastInsertId();

        $this->sendJson([
            'success' => true,
            'group_id' => $groupId,
            'message' => 'Группа создана'
        ], 201);
    }

    /**
     * PUT /api/groups/{id}
     * Обновить группу
     */
    public function updateGroup($groupId)
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        if (!$groupId) {
            $this->sendError('ID группы не указан', 400);
        }

        // Проверить существование
        $stmt = $this->db->prepare("SELECT id FROM `groups` WHERE id = ?");
        $stmt->execute([$groupId]);
        if (!$stmt->fetch()) {
            $this->sendError('Группа не найдена', 404);
        }

        $updates = [];
        $params = [];

        if (isset($data['name'])) {
            $updates[] = "name = ?";
            $params[] = $data['name'];
        }
        if (isset($data['course'])) {
            $updates[] = "course = ?";
            $params[] = $data['course'];
        }

        if (empty($updates)) {
            $this->sendError('Нет данных для обновления', 400);
        }

        $params[] = $groupId;
        $query = "UPDATE `groups` SET " . implode(', ', $updates) . " WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);

        $this->sendJson(['success' => true, 'message' => 'Группа обновлена']);
    }

    /**
     * DELETE /api/groups/{id}
     * Удалить группу
     */
    public function deleteGroup($groupId)
    {
        AuthMiddleware::requireRole(['admin']);

        if (!$groupId) {
            $this->sendError('ID группы не указан', 400);
        }

        // Проверить существование
        $stmt = $this->db->prepare("SELECT id FROM `groups` WHERE id = ?");
        $stmt->execute([$groupId]);
        if (!$stmt->fetch()) {
            $this->sendError('Группа не найдена', 404);
        }

        // Проверить наличие студентов
        $stmt = $this->db->prepare("SELECT COUNT(*) as count FROM students WHERE group_id = ?");
        $stmt->execute([$groupId]);
        $studentCount = $stmt->fetch()['count'];

        if ($studentCount > 0) {
            $this->sendError("В группе есть студенты ($studentCount). Сначала переместите их в другую группу.", 400);
        }

        // Удалить
        $stmt = $this->db->prepare("DELETE FROM `groups` WHERE id = ?");
        $stmt->execute([$groupId]);

        $this->sendJson(['success' => true, 'message' => 'Группа удалена']);
    }

    /**
     * GET /api/groups/{id}/students
     * Получить список студентов в группе
     */
    public function getGroupStudents($groupId)
    {
        AuthMiddleware::requireRole(['admin', 'instructor', 'curator']);

        if (!$groupId) {
            $this->sendError('ID группы не указан', 400);
        }

        $query = "
            SELECT 
                u.id,
                u.full_name,
                u.email,
                s.student_code,
                s.created_at
            FROM students s
            JOIN users u ON s.user_id = u.id
            WHERE s.group_id = ?
            ORDER BY u.full_name ASC
        ";

        $stmt = $this->db->prepare($query);
        $stmt->execute([$groupId]);
        $students = $stmt->fetchAll();

        $this->sendJson($students);
    }

    /**
     * POST /api/groups/{id}/add-student
     * Добавить студента в группу
     */
    public function addStudentToGroup($groupId)
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        $studentId = $data['student_id'] ?? null;

        if (!$groupId || !$studentId) {
            $this->sendError('ID группы и студента обязательны', 400);
        }

        // Проверить существование группы
        $stmt = $this->db->prepare("SELECT id FROM `groups` WHERE id = ?");
        $stmt->execute([$groupId]);
        if (!$stmt->fetch()) {
            $this->sendError('Группа не найдена', 404);
        }

        // Проверить существование студента
        $stmt = $this->db->prepare("SELECT id FROM students WHERE user_id = ?");
        $stmt->execute([$studentId]);
        if (!$stmt->fetch()) {
            $this->sendError('Студент не найден', 404);
        }

        // Обновить group_id
        $stmt = $this->db->prepare("UPDATE students SET group_id = ? WHERE user_id = ?");
        $stmt->execute([$groupId, $studentId]);

        $this->sendJson(['success' => true, 'message' => 'Студент добавлен в группу']);
    }

    /**
     * POST /api/groups/{id}/remove-student
     * Удалить студента из группы
     */
    public function removeStudentFromGroup($groupId)
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        $studentId = $data['student_id'] ?? null;

        if (!$groupId || !$studentId) {
            $this->sendError('ID группы и студента обязательны', 400);
        }

        // Обновить group_id на NULL
        $stmt = $this->db->prepare("UPDATE students SET group_id = NULL WHERE user_id = ? AND group_id = ?");
        $stmt->execute([$studentId, $groupId]);

        $this->sendJson(['success' => true, 'message' => 'Студент удалён из группы']);
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
