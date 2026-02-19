<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

class ScheduleController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/schedule
     * Получить все уроки (с фильтрами)
     * Параметры: ?group_id=1 или ?instructor_id=5
     */
    public function getAllLessons()
    {
        AuthMiddleware::authenticate();

        $groupId = $_GET['group_id'] ?? null;
        $instructorId = $_GET['instructor_id'] ?? null;

        $query = "
            SELECT 
                l.id,
                l.day_of_week,
                l.start_time,
                l.end_time,
                l.room,
                g.name as group_name,
                s.name as subject_name,
                u.full_name as instructor_name,
                l.group_id,
                l.subject_id,
                l.instructor_user_id
            FROM lessons l
            JOIN `groups` g ON l.group_id = g.id
            JOIN subjects s ON l.subject_id = s.id
            JOIN users u ON l.instructor_user_id = u.id
        ";

        $conditions = [];
        $params = [];

        if ($groupId) {
            $conditions[] = "l.group_id = ?";
            $params[] = $groupId;
        }

        if ($instructorId) {
            $conditions[] = "l.instructor_user_id = ?";
            $params[] = $instructorId;
        }

        if (!empty($conditions)) {
            $query .= " WHERE " . implode(' AND ', $conditions);
        }

        $query .= " ORDER BY 
            FIELD(l.day_of_week, 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'),
            l.start_time ASC
        ";

        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        $lessons = $stmt->fetchAll();

        $this->sendJson($lessons);
    }

    /**
     * POST /api/schedule
     * Создать урок
     */
    public function createLesson()
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        $groupId = $data['group_id'] ?? null;
        $subjectId = $data['subject_id'] ?? null;
        $instructorId = $data['instructor_user_id'] ?? null;
        $dayOfWeek = $data['day_of_week'] ?? null;
        $startTime = $data['start_time'] ?? null;
        $endTime = $data['end_time'] ?? null;
        $room = $data['room'] ?? null;

        // Валидация
        if (!$groupId || !$subjectId || !$instructorId || !$dayOfWeek || !$startTime || !$endTime) {
            $this->sendError('Все обязательные поля должны быть заполнены', 400);
        }

        // Проверка: преподаватель назначен на предмет?
        $stmt = $this->db->prepare("
            SELECT COUNT(*) as count 
            FROM subject_instructors 
            WHERE subject_id = ? AND instructor_user_id = ?
        ");
        $stmt->execute([$subjectId, $instructorId]);
        if ($stmt->fetch()['count'] == 0) {
            $this->sendError('Преподаватель не назначен на этот предмет', 400);
        }

        // Проверка конфликтов времени
        $conflict = $this->checkTimeConflict($instructorId, $groupId, $dayOfWeek, $startTime, $endTime);
        if ($conflict) {
            $this->sendError($conflict, 400);
        }

        // Создать урок
        $stmt = $this->db->prepare("
            INSERT INTO lessons (group_id, subject_id, instructor_user_id, day_of_week, start_time, end_time, room) 
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([$groupId, $subjectId, $instructorId, $dayOfWeek, $startTime, $endTime, $room]);
        $lessonId = $this->db->lastInsertId();

        $this->sendJson([
            'success' => true,
            'lesson_id' => $lessonId,
            'message' => 'Урок создан'
        ], 201);
    }

    /**
     * PUT /api/schedule/{id}
     * Обновить урок
     */
    public function updateLesson($lessonId)
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        if (!$lessonId) {
            $this->sendError('ID урока не указан', 400);
        }

        // Проверить существование
        $stmt = $this->db->prepare("SELECT * FROM lessons WHERE id = ?");
        $stmt->execute([$lessonId]);
        $existingLesson = $stmt->fetch();
        if (!$existingLesson) {
            $this->sendError('Урок не найден', 404);
        }

        // Собрать обновления
        $updates = [];
        $params = [];

        if (isset($data['group_id'])) {
            $updates[] = "group_id = ?";
            $params[] = $data['group_id'];
        }
        if (isset($data['subject_id'])) {
            $updates[] = "subject_id = ?";
            $params[] = $data['subject_id'];
        }
        if (isset($data['instructor_user_id'])) {
            $updates[] = "instructor_user_id = ?";
            $params[] = $data['instructor_user_id'];
        }
        if (isset($data['day_of_week'])) {
            $updates[] = "day_of_week = ?";
            $params[] = $data['day_of_week'];
        }
        if (isset($data['start_time'])) {
            $updates[] = "start_time = ?";
            $params[] = $data['start_time'];
        }
        if (isset($data['end_time'])) {
            $updates[] = "end_time = ?";
            $params[] = $data['end_time'];
        }
        if (isset($data['room'])) {
            $updates[] = "room = ?";
            $params[] = $data['room'];
        }

        if (empty($updates)) {
            $this->sendError('Нет данных для обновления', 400);
        }

        // Проверка конфликтов (если меняется время/преподаватель/группа)
        $newInstructor = $data['instructor_user_id'] ?? $existingLesson['instructor_user_id'];
        $newGroup = $data['group_id'] ?? $existingLesson['group_id'];
        $newDay = $data['day_of_week'] ?? $existingLesson['day_of_week'];
        $newStart = $data['start_time'] ?? $existingLesson['start_time'];
        $newEnd = $data['end_time'] ?? $existingLesson['end_time'];

        $conflict = $this->checkTimeConflict($newInstructor, $newGroup, $newDay, $newStart, $newEnd, $lessonId);
        if ($conflict) {
            $this->sendError($conflict, 400);
        }

        $params[] = $lessonId;
        $query = "UPDATE lessons SET " . implode(', ', $updates) . " WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);

        $this->sendJson(['success' => true, 'message' => 'Урок обновлён']);
    }

    /**
     * DELETE /api/schedule/{id}
     * Удалить урок
     */
    public function deleteLesson($lessonId)
    {
        AuthMiddleware::requireRole(['admin']);

        if (!$lessonId) {
            $this->sendError('ID урока не указан', 400);
        }

        $stmt = $this->db->prepare("DELETE FROM lessons WHERE id = ?");
        $stmt->execute([$lessonId]);

        $this->sendJson(['success' => true, 'message' => 'Урок удалён']);
    }

    /**
     * GET /api/schedule/my
     * Получить моё расписание (студент/преподаватель)
     */
    public function getMySchedule()
    {
        $user = AuthMiddleware::authenticate();
        $role = $user['role'];

        if ($role === 'student') {
            // Получить группу студента
            $stmt = $this->db->prepare("SELECT group_id FROM students WHERE user_id = ?");
            $stmt->execute([$user['user_id']]);
            $student = $stmt->fetch();

            if (!$student || !$student['group_id']) {
                $this->sendJson([]); // Нет группы = нет расписания
                return;
            }

            $this->getScheduleByGroup($student['group_id']);

        } elseif ($role === 'instructor') {
            $this->getScheduleByInstructor($user['user_id']);

        } else {
            $this->sendError('Доступ запрещён', 403);
        }
    }

    /**
     * GET /api/schedule/group/{id}
     * Расписание группы
     */
    public function getScheduleByGroup($groupId)
    {
        if (!$groupId) {
            $this->sendError('ID группы не указан', 400);
        }

        $query = "
            SELECT 
                l.id,
                l.day_of_week,
                l.pair_number,
                l.start_time,
                l.end_time,
                l.room,
                s.name as subject_name_ru, -- Using `name` as `name_ru` was not found in previous checks, assuming `name` contains the subject name
                s.name as subject_name_kz,
                u.full_name as instructor_name
            FROM lessons l
            JOIN subjects s ON l.subject_id = s.id
            LEFT JOIN users u ON l.instructor_user_id = u.id
            WHERE l.group_id = ?
            ORDER BY 
                FIELD(l.day_of_week, 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'),
                l.pair_number ASC

        ";

        $stmt = $this->db->prepare($query);
        $stmt->execute([$groupId]);
        $lessons = $stmt->fetchAll();

        $this->sendJson($lessons);
    }

    /**
     * GET /api/schedule/instructor/{id}
     * Расписание преподавателя
     */
    public function getScheduleByInstructor($instructorId)
    {
        if (!$instructorId) {
            $this->sendError('ID преподавателя не указан', 400);
        }

        $query = "
            SELECT 
                l.id,
                l.day_of_week,
                l.pair_number,
                l.start_time,
                l.end_time,
                l.room,
                g.name as group_name,
                s.name as subject_name_ru,
                s.name as subject_name_kz
            FROM lessons l
            JOIN `groups` g ON l.group_id = g.id
            JOIN subjects s ON l.subject_id = s.id
            WHERE l.instructor_user_id = ?
            ORDER BY 
                FIELD(l.day_of_week, 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'),
                l.pair_number ASC

        ";

        $stmt = $this->db->prepare($query);
        $stmt->execute([$instructorId]);
        $lessons = $stmt->fetchAll();

        $this->sendJson($lessons);
    }

    /**
     * Проверка конфликтов времени
     */
    private function checkTimeConflict($instructorId, $groupId, $dayOfWeek, $startTime, $endTime, $excludeLessonId = null)
    {
        // Проверка 1: Преподаватель занят?
        $query = "
            SELECT COUNT(*) as count 
            FROM lessons 
            WHERE instructor_user_id = ? 
            AND day_of_week = ? 
            AND (
                (start_time < ? AND end_time > ?) OR
                (start_time < ? AND end_time > ?) OR
                (start_time >= ? AND end_time <= ?)
            )
        ";
        $params = [$instructorId, $dayOfWeek, $endTime, $startTime, $endTime, $startTime, $startTime, $endTime];

        if ($excludeLessonId) {
            $query .= " AND id != ?";
            $params[] = $excludeLessonId;
        }

        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        if ($stmt->fetch()['count'] > 0) {
            return 'Преподаватель уже занят в это время';
        }

        // Проверка 2: Группа занята? (только предупреждение в логе, не блокируем)
        $query = "
            SELECT COUNT(*) as count 
            FROM lessons 
            WHERE group_id = ? 
            AND day_of_week = ? 
            AND (
                (start_time < ? AND end_time > ?) OR
                (start_time < ? AND end_time > ?) OR
                (start_time >= ? AND end_time <= ?)
            )
        ";
        $params = [$groupId, $dayOfWeek, $endTime, $startTime, $endTime, $startTime, $startTime, $endTime];

        if ($excludeLessonId) {
            $query .= " AND id != ?";
            $params[] = $excludeLessonId;
        }

        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        if ($stmt->fetch()['count'] > 0) {
            // Для группы только предупреждение (можно было бы логировать)
            // return 'Группа уже занята в это время';
        }

        return null; // Нет конфликтов
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
