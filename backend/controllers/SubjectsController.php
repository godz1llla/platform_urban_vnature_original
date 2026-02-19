<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

class SubjectsController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/subjects
     */
    public function getAllSubjects()
    {
        AuthMiddleware::authenticate();

        // ИСПРАВЛЕНО: Таблица subject_instructors -> instructor_subjects
        $query = "
            SELECT 
                s.id,
                s.name,
                s.description,
                s.created_at,
                COUNT(si.id) as instructor_count
            FROM subjects s
            LEFT JOIN instructor_subjects si ON s.id = si.subject_id
            GROUP BY s.id
            ORDER BY s.name ASC
        ";

        try {
            $stmt = $this->db->prepare($query);
            $stmt->execute();
            $subjects = $stmt->fetchAll(PDO::FETCH_ASSOC);
            $this->sendJson($subjects);
        } catch (Exception $e) {
            $this->sendError('Ошибка загрузки предметов: ' . $e->getMessage(), 500);
        }
    }

    /**
     * POST /api/subjects
     */
    public function createSubject()
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        $name = $data['name'] ?? null;
        $description = $data['description'] ?? null;

        if (!$name)
            $this->sendError('Название предмета обязательно', 400);

        // Проверка уникальности
        $stmt = $this->db->prepare("SELECT id FROM subjects WHERE name = ?");
        $stmt->execute([$name]);
        if ($stmt->fetch()) {
            $this->sendError('Предмет с таким названием уже существует', 400);
        }

        $stmt = $this->db->prepare("INSERT INTO subjects (name, description) VALUES (?, ?)");
        $stmt->execute([$name, $description]);
        $subjectId = $this->db->lastInsertId();

        $this->sendJson([
            'success' => true,
            'subject_id' => $subjectId,
            'message' => 'Предмет создан'
        ], 201);
    }

    /**
     * PUT /api/subjects/{id}
     */
    public function updateSubject($subjectId)
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        if (!$subjectId)
            $this->sendError('ID предмета не указан', 400);

        $stmt = $this->db->prepare("SELECT id FROM subjects WHERE id = ?");
        $stmt->execute([$subjectId]);
        if (!$stmt->fetch())
            $this->sendError('Предмет не найден', 404);

        $updates = [];
        $params = [];

        if (isset($data['name'])) {
            $stmt = $this->db->prepare("SELECT id FROM subjects WHERE name = ? AND id != ?");
            $stmt->execute([$data['name'], $subjectId]);
            if ($stmt->fetch())
                $this->sendError('Предмет с таким названием уже существует', 400);
            $updates[] = "name = ?";
            $params[] = $data['name'];
        }
        if (isset($data['description'])) {
            $updates[] = "description = ?";
            $params[] = $data['description'];
        }

        if (empty($updates))
            $this->sendError('Нет данных для обновления', 400);

        $params[] = $subjectId;
        $query = "UPDATE subjects SET " . implode(', ', $updates) . " WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);

        $this->sendJson(['success' => true, 'message' => 'Предмет обновлён']);
    }

    /**
     * DELETE /api/subjects/{id}
     */
    public function deleteSubject($subjectId)
    {
        AuthMiddleware::requireRole(['admin']);

        if (!$subjectId)
            $this->sendError('ID предмета не указан', 400);

        $stmt = $this->db->prepare("DELETE FROM subjects WHERE id = ?");
        if ($stmt->execute([$subjectId])) {
            $this->sendJson(['success' => true, 'message' => 'Предмет удалён']);
        } else {
            $this->sendError('Ошибка удаления (возможно есть связи)', 500);
        }
    }

    /**
     * GET /api/subjects/{id}/instructors
     */
    public function getSubjectInstructors($subjectId)
    {
        AuthMiddleware::requireRole(['admin']);

        if (!$subjectId)
            $this->sendError('ID предмета не указан', 400);

        // ИСПРАВЛЕНО: instructor_subjects и instructor_id
        $query = "
            SELECT 
                u.id,
                u.full_name,
                u.email,
                si.assigned_at
            FROM instructor_subjects si
            JOIN users u ON si.instructor_id = u.id
            WHERE si.subject_id = ?
            ORDER BY u.full_name ASC
        ";

        try {
            $stmt = $this->db->prepare($query);
            $stmt->execute([$subjectId]);
            $instructors = $stmt->fetchAll(PDO::FETCH_ASSOC);
            $this->sendJson($instructors);
        } catch (Exception $e) {
            $this->sendError('Ошибка БД: ' . $e->getMessage(), 500);
        }
    }

    /**
     * POST /api/subjects/{id}/assign-instructor
     */
    public function assignInstructor($subjectId)
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        $instructorId = $data['instructor_id'] ?? null; // ID пользователя

        if (!$subjectId || !$instructorId) {
            $this->sendError('ID предмета и преподавателя обязательны', 400);
        }

        // 1. Проверить предмет
        $stmt = $this->db->prepare("SELECT id FROM subjects WHERE id = ?");
        $stmt->execute([$subjectId]);
        if (!$stmt->fetch())
            $this->sendError('Предмет не найден', 404);

        // 2. Проверить преподавателя
        $stmt = $this->db->prepare("SELECT id, role FROM users WHERE id = ?");
        $stmt->execute([$instructorId]);
        $user = $stmt->fetch();

        if (!$user)
            $this->sendError('Пользователь не найден', 404);
        if ($user['role'] !== 'instructor')
            $this->sendError('Этот пользователь не преподаватель', 400);

        // 3. Проверить дубликат
        // ИСПРАВЛЕНО имя таблицы
        $stmt = $this->db->prepare("SELECT id FROM instructor_subjects WHERE subject_id = ? AND instructor_id = ?");
        $stmt->execute([$subjectId, $instructorId]);
        if ($stmt->fetch()) {
            $this->sendError('Преподаватель уже назначен на этот предмет', 400);
        }

        // 4. Назначить
        // ИСПРАВЛЕНО имя таблицы
        $stmt = $this->db->prepare("INSERT INTO instructor_subjects (subject_id, instructor_id) VALUES (?, ?)");
        if ($stmt->execute([$subjectId, $instructorId])) {
            $this->sendJson(['success' => true, 'message' => 'Преподаватель назначен']);
        } else {
            $this->sendError('Ошибка БД', 500);
        }
    }

    /**
     * POST /api/subjects/{id}/unassign-instructor
     */
    public function unassignInstructor($subjectId)
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        $instructorId = $data['instructor_id'] ?? null;

        if (!$subjectId || !$instructorId)
            $this->sendError('Данные неполны', 400);

        // ИСПРАВЛЕНО имя таблицы
        $stmt = $this->db->prepare("DELETE FROM instructor_subjects WHERE subject_id = ? AND instructor_id = ?");
        if ($stmt->execute([$subjectId, $instructorId])) {
            $this->sendJson(['success' => true, 'message' => 'Преподаватель удалён из предмета']);
        } else {
            $this->sendError('Ошибка удаления', 500);
        }
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
