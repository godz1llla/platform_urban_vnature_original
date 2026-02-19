<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

class GradesController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/grades
     * Получить оценки (с учетом роли)
     */
    public function getAllGrades()
    {
        $user = AuthMiddleware::getCurrentUser();
        $role = $user['role'];
        $userId = $user['id'];

        $query = "
            SELECT 
                g.id,
                g.grade_value,
                g.grade_type,
                g.comment,
                g.date,
                g.created_at,
                u.full_name as student_name,
                s.name as subject_name,
                i.full_name as instructor_name
            FROM grades g
            JOIN users u ON g.student_user_id = u.id
            JOIN subjects s ON g.subject_id = s.id
            JOIN users i ON g.instructor_user_id = i.id
            WHERE 1=1
        ";

        $params = [];

        // Фильтрация по роли
        if ($role === 'student') {
            // Студент видит только свои оценки
            $query .= " AND g.student_user_id = ?";
            $params[] = $userId;
        } elseif ($role === 'instructor') {
            // Преподаватель видит оценки только по своим предметам
            $query .= " AND g.subject_id IN (
                SELECT subject_id FROM subject_instructors 
                WHERE instructor_user_id = ?
            )";
            $params[] = $userId;
        }
        // Админ видит все оценки

        // Фильтры из query params
        if (isset($_GET['student_id'])) {
            $query .= " AND g.student_user_id = ?";
            $params[] = $_GET['student_id'];
        }

        if (isset($_GET['subject_id'])) {
            $query .= " AND g.subject_id = ?";
            $params[] = $_GET['subject_id'];
        }

        if (isset($_GET['group_id'])) {
            $query .= " AND g.student_user_id IN (
                SELECT user_id FROM students WHERE group_id = ?
            )";
            $params[] = $_GET['group_id'];
        }

        $query .= " ORDER BY g.date DESC, g.created_at DESC";

        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        $grades = $stmt->fetchAll();

        $this->sendJson($grades);
    }

    /**
     * GET /api/grades/my
     * Мои оценки (для студента)
     */
    public function getMyGrades()
    {
        $user = AuthMiddleware::requireRole(['student']);
        $userId = $user['id'];

        $query = "
            SELECT 
                g.id,
                g.grade_value,
                g.grade_type,
                g.comment,
                g.date,
                s.name as subject_name,
                i.full_name as instructor_name
            FROM grades g
            JOIN subjects s ON g.subject_id = s.id
            JOIN users i ON g.instructor_user_id = i.id
            WHERE g.student_user_id = ?
            ORDER BY s.name, g.date DESC
        ";

        $stmt = $this->db->prepare($query);
        $stmt->execute([$userId]);
        $grades = $stmt->fetchAll();

        // Группировка по предметам с расчетом среднего
        $bySubject = [];
        foreach ($grades as $grade) {
            $subjectName = $grade['subject_name'];
            if (!isset($bySubject[$subjectName])) {
                $bySubject[$subjectName] = [
                    'subject_name' => $subjectName,
                    'grades' => [],
                    'average' => 0
                ];
            }
            $bySubject[$subjectName]['grades'][] = $grade;
        }

        // Рассчитать средний балл
        foreach ($bySubject as &$subject) {
            $sum = array_sum(array_column($subject['grades'], 'grade_value'));
            $count = count($subject['grades']);
            $subject['average'] = $count > 0 ? round($sum / $count, 2) : 0;
        }

        $this->sendJson(array_values($bySubject));
    }

    /**
     * POST /api/grades
     * Выставить оценку
     */
    public function createGrade()
    {
        $user = AuthMiddleware::requireRole(['instructor', 'admin']);
        $data = $this->getRequestData();

        $studentUserId = $data['student_user_id'] ?? null;
        $subjectId = $data['subject_id'] ?? null;
        $gradeValue = $data['grade_value'] ?? null;
        $gradeType = $data['grade_type'] ?? 'exam';
        $comment = $data['comment'] ?? null;
        $date = $data['date'] ?? date('Y-m-d');

        if (!$studentUserId || !$subjectId || $gradeValue === null) {
            $this->sendError('Заполните обязательные поля', 400);
        }

        // Проверить оценку (0-100)
        if ($gradeValue < 0 || $gradeValue > 100) {
            $this->sendError('Оценка должна быть от 0 до 100', 400);
        }

        // Проверить что студент существует
        $stmt = $this->db->prepare("SELECT id FROM users WHERE id = ? AND role = 'student'");
        $stmt->execute([$studentUserId]);
        if (!$stmt->fetch()) {
            $this->sendError('Студент не найден', 404);
        }

        // Если преподаватель - проверить что он назначен на предмет
        if ($user['role'] === 'instructor') {
            $stmt = $this->db->prepare("
                SELECT id FROM subject_instructors 
                WHERE subject_id = ? AND instructor_user_id = ?
            ");
            $stmt->execute([$subjectId, $user['id']]);
            if (!$stmt->fetch()) {
                $this->sendError('Вы не назначены на этот предмет', 403);
            }
        }

        // Создать оценку
        $stmt = $this->db->prepare("
            INSERT INTO grades (student_user_id, subject_id, instructor_user_id, grade_value, grade_type, comment, date)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([
            $studentUserId,
            $subjectId,
            $user['id'],
            $gradeValue,
            $gradeType,
            $comment,
            $date
        ]);

        $gradeId = $this->db->lastInsertId();

        $this->sendJson([
            'success' => true,
            'grade_id' => $gradeId,
            'message' => 'Оценка выставлена'
        ], 201);
    }

    /**
     * PUT /api/grades/{id}
     * Обновить оценку
     */
    public function updateGrade($gradeId)
    {
        $user = AuthMiddleware::requireRole(['instructor', 'admin']);
        $data = $this->getRequestData();

        if (!$gradeId) {
            $this->sendError('ID оценки не указан', 400);
        }

        // Проверить существование оценки
        $stmt = $this->db->prepare("SELECT instructor_user_id FROM grades WHERE id = ?");
        $stmt->execute([$gradeId]);
        $grade = $stmt->fetch();

        if (!$grade) {
            $this->sendError('Оценка не найдена', 404);
        }

        // Проверить права (только создатель или админ)
        if ($user['role'] !== 'admin' && $grade['instructor_user_id'] != $user['id']) {
            $this->sendError('Нет прав на изменение этой оценки', 403);
        }

        // Обновить поля
        $updates = [];
        $params = [];

        if (isset($data['grade_value'])) {
            if ($data['grade_value'] < 0 || $data['grade_value'] > 100) {
                $this->sendError('Оценка должна быть от 0 до 100', 400);
            }
            $updates[] = "grade_value = ?";
            $params[] = $data['grade_value'];
        }

        if (isset($data['grade_type'])) {
            $updates[] = "grade_type = ?";
            $params[] = $data['grade_type'];
        }

        if (isset($data['comment'])) {
            $updates[] = "comment = ?";
            $params[] = $data['comment'];
        }

        if (isset($data['date'])) {
            $updates[] = "date = ?";
            $params[] = $data['date'];
        }

        if (empty($updates)) {
            $this->sendError('Нет данных для обновления', 400);
        }

        $params[] = $gradeId;
        $query = "UPDATE grades SET " . implode(', ', $updates) . " WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);

        $this->sendJson(['success' => true, 'message' => 'Оценка обновлена']);
    }

    /**
     * DELETE /api/grades/{id}
     * Удалить оценку
     */
    public function deleteGrade($gradeId)
    {
        $user = AuthMiddleware::requireRole(['instructor', 'admin']);

        if (!$gradeId) {
            $this->sendError('ID оценки не указан', 400);
        }

        // Проверить существование
        $stmt = $this->db->prepare("SELECT instructor_user_id FROM grades WHERE id = ?");
        $stmt->execute([$gradeId]);
        $grade = $stmt->fetch();

        if (!$grade) {
            $this->sendError('Оценка не найдена', 404);
        }

        // Проверить права
        if ($user['role'] !== 'admin' && $grade['instructor_user_id'] != $user['id']) {
            $this->sendError('Нет прав на удаление этой оценки', 403);
        }

        // Удалить
        $stmt = $this->db->prepare("DELETE FROM grades WHERE id = ?");
        $stmt->execute([$gradeId]);

        $this->sendJson(['success' => true, 'message' => 'Оценка удалена']);
    }

    /**
     * GET /api/grades/student/{id}
     * Оценки конкретного студента
     */
    public function getStudentGrades($studentId)
    {
        $user = AuthMiddleware::getCurrentUser();

        if (!$studentId) {
            $this->sendError('ID студента не указан', 400);
        }

        // Проверить права
        if ($user['role'] === 'student' && $user['id'] != $studentId) {
            $this->sendError('Нет доступа к оценкам другого студента', 403);
        }

        if ($user['role'] === 'instructor') {
            // Преподаватель видит только по своим предметам
            $query = "
                SELECT 
                    g.id, g.grade_value, g.grade_type, g.comment, g.date,
                    s.name as subject_name,
                    i.full_name as instructor_name
                FROM grades g
                JOIN subjects s ON g.subject_id = s.id
                JOIN users i ON g.instructor_user_id = i.id
                WHERE g.student_user_id = ?
                  AND g.subject_id IN (
                      SELECT subject_id FROM subject_instructors 
                      WHERE instructor_user_id = ?
                  )
                ORDER BY s.name, g.date DESC
            ";
            $stmt = $this->db->prepare($query);
            $stmt->execute([$studentId, $user['id']]);
        } else {
            // Админ или сам студент видят все
            $query = "
                SELECT 
                    g.id, g.grade_value, g.grade_type, g.comment, g.date,
                    s.name as subject_name,
                    i.full_name as instructor_name
                FROM grades g
                JOIN subjects s ON g.subject_id = s.id
                JOIN users i ON g.instructor_user_id = i.id
                WHERE g.student_user_id = ?
                ORDER BY s.name, g.date DESC
            ";
            $stmt = $this->db->prepare($query);
            $stmt->execute([$studentId]);
        }

        $grades = $stmt->fetchAll();
        $this->sendJson($grades);
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
