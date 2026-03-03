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
     */
    public function getAllLessons()
    {
        AuthMiddleware::authenticate();

        $groupId = $_GET['group_id'] ?? null;
        $instructorId = $_GET['instructor_id'] ?? null;
        $weekNumber = $_GET['week_number'] ?? null;

        $query = "
            SELECT 
                s.id,
                s.day_of_week,
                s.week_number,
                s.time_start,
                s.time_end,
                s.audience,
                s.pair_number,
                g.name as group_name,
                sub.name as subject_name,
                u.full_name as instructor_name,
                s.group_id,
                s.subject_id,
                s.instructor_id
            FROM schedule s
            JOIN `groups` g ON s.group_id = g.id
            JOIN subjects sub ON s.subject_id = sub.id
            JOIN users u ON s.instructor_id = u.id
        ";

        $conditions = [];
        $params = [];

        if ($groupId) {
            $conditions[] = "s.group_id = ?";
            $params[] = $groupId;
        }

        if ($instructorId) {
            $conditions[] = "s.instructor_id = ?";
            $params[] = $instructorId;
        }

        if ($weekNumber) {
            $conditions[] = "s.week_number = ?";
            $params[] = $weekNumber;
        }

        if (!empty($conditions)) {
            $query .= " WHERE " . implode(' AND ', $conditions);
        }

        $query .= " ORDER BY 
            s.week_number ASC,
            FIELD(s.day_of_week, 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'),
            s.time_start ASC
        ";

        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        $lessons = $stmt->fetchAll(PDO::FETCH_ASSOC);

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
        $instructorId = $data['instructor_id'] ?? null;
        $dayOfWeek = $data['day_of_week'] ?? null;
        $weekNumber = $data['week_number'] ?? 1;
        $startTime = $data['time_start'] ?? null;
        $endTime = $data['time_end'] ?? null;
        $audience = $data['audience'] ?? null;
        $pairNumber = $data['pair_number'] ?? 1;

        if (!$groupId || !$subjectId || !$instructorId || !$dayOfWeek || !$startTime || !$endTime) {
            $this->sendError('Все обязательные поля должны быть заполнены', 400);
        }

        // Проверка конфликтов
        $conflict = $this->checkTimeConflict($instructorId, $groupId, $dayOfWeek, $weekNumber, $startTime, $endTime);
        if ($conflict) {
            $this->sendError($conflict, 400);
        }

        $stmt = $this->db->prepare("
            INSERT INTO schedule (group_id, week_number, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([$groupId, $weekNumber, $subjectId, $instructorId, $audience, $dayOfWeek, $pairNumber, $startTime, $endTime]);

        $this->sendJson([
            'success' => true,
            'id' => $this->db->lastInsertId(),
            'message' => 'Запись добавлена'
        ], 201);
    }

    /**
     * POST /api/schedule/clone
     * Клонировать неделю
     */
    public function cloneWeek()
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        $groupId = $data['group_id'] ?? null;
        $fromWeek = $data['from_week'] ?? null;
        $toWeeks = $data['to_weeks'] ?? []; // Массив номеров недель

        if (!$groupId || !$fromWeek || empty($toWeeks)) {
            $this->sendError('Недостаточно данных для клонирования', 400);
        }

        // 1. Получить исходное расписание
        $stmt = $this->db->prepare("SELECT * FROM schedule WHERE group_id = ? AND week_number = ?");
        $stmt->execute([$groupId, $fromWeek]);
        $sourceLessons = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (empty($sourceLessons)) {
            $this->sendError('Исходная неделя пустая', 400);
        }

        $this->db->beginTransaction();

        try {
            foreach ($toWeeks as $week) {
                if ($week == $fromWeek)
                    continue;

                // Удаляем старое расписание на целевой неделе
                $del = $this->db->prepare("DELETE FROM schedule WHERE group_id = ? AND week_number = ?");
                $del->execute([$groupId, $week]);

                // Вставляем копии
                foreach ($sourceLessons as $lesson) {
                    $ins = $this->db->prepare("
                        INSERT INTO schedule (group_id, week_number, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end) 
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                    ");
                    $ins->execute([
                        $groupId,
                        $week,
                        $lesson['subject_id'],
                        $lesson['instructor_id'],
                        $lesson['audience'],
                        $lesson['day_of_week'],
                        $lesson['pair_number'],
                        $lesson['time_start'],
                        $lesson['time_end']
                    ]);
                }
            }
            $this->db->commit();
            $this->sendJson(['success' => true, 'message' => 'Расписание успешно скопировано на ' . count($toWeeks) . ' недель']);
        } catch (Exception $e) {
            $this->db->rollBack();
            $this->sendError('Ошибка при клонировании: ' . $e->getMessage(), 500);
        }
    }

    /**
     * PUT /api/schedule/{id}
     */
    public function updateLesson($id)
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        $stmt = $this->db->prepare("SELECT * FROM schedule WHERE id = ?");
        $stmt->execute([$id]);
        $existing = $stmt->fetch();
        if (!$existing)
            $this->sendError('Запись не найдена', 404);

        $fields = ['subject_id', 'instructor_id', 'audience', 'day_of_week', 'week_number', 'pair_number', 'time_start', 'time_end'];
        $updates = [];
        $params = [];

        foreach ($fields as $field) {
            if (isset($data[$field])) {
                $updates[] = "$field = ?";
                $params[] = $data[$field];
            }
        }

        if (empty($updates))
            $this->sendError('Нет данных для обновления', 400);

        // Проверка конфликтов (упрощенно)
        $newInstr = $data['instructor_id'] ?? $existing['instructor_id'];
        $newGroup = $existing['group_id'];
        $newDay = $data['day_of_week'] ?? $existing['day_of_week'];
        $newWeek = $data['week_number'] ?? $existing['week_number'];
        $newStart = $data['time_start'] ?? $existing['time_start'];
        $newEnd = $data['time_end'] ?? $existing['time_end'];

        $conflict = $this->checkTimeConflict($newInstr, $newGroup, $newDay, $newWeek, $newStart, $newEnd, $id);
        if ($conflict)
            $this->sendError($conflict, 400);

        $params[] = $id;
        $stmt = $this->db->prepare("UPDATE schedule SET " . implode(', ', $updates) . " WHERE id = ?");
        $stmt->execute($params);

        $this->sendJson(['success' => true, 'message' => 'Обновлено']);
    }

    /**
     * DELETE /api/schedule/{id}
     */
    public function deleteLesson($id)
    {
        AuthMiddleware::requireRole(['admin']);
        $stmt = $this->db->prepare("DELETE FROM schedule WHERE id = ?");
        $stmt->execute([$id]);
        $this->sendJson(['success' => true, 'message' => 'Удалено']);
    }

    /**
     * GET /api/schedule/my
     */
    public function getMySchedule()
    {
        $user = AuthMiddleware::authenticate();
        $role = $user['role'];

        if ($role === 'student') {
            $stmt = $this->db->prepare("SELECT group_id FROM students WHERE user_id = ?");
            $stmt->execute([$user['user_id']]);
            $student = $stmt->fetch();
            if (!$student || !$student['group_id'])
                return $this->sendJson([]);
            $this->getScheduleByGroup($student['group_id']);
        } elseif ($role === 'instructor') {
            $this->getScheduleByInstructor($user['user_id']);
        } else {
            $this->sendError('Доступ запрещен', 403);
        }
    }

    public function getScheduleByGroup($groupId)
    {
        $weekNumber = $_GET['week_number'] ?? 1;
        $query = "
            SELECT s.*, sub.name as subject_name_ru, sub.name as subject_name_kz, u.full_name as instructor_name
            FROM schedule s
            JOIN subjects sub ON s.subject_id = sub.id
            LEFT JOIN users u ON s.instructor_id = u.id
            WHERE s.group_id = ? AND s.week_number = ?
            ORDER BY FIELD(s.day_of_week, 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'), s.time_start ASC
        ";
        $stmt = $this->db->prepare($query);
        $stmt->execute([$groupId, $weekNumber]);
        $this->sendJson($stmt->fetchAll(PDO::FETCH_ASSOC));
    }

    public function getScheduleByInstructor($instructorId)
    {
        $weekNumber = $_GET['week_number'] ?? 1;
        $query = "
            SELECT s.*, g.name as group_name, sub.name as subject_name_ru, sub.name as subject_name_kz
            FROM schedule s
            JOIN `groups` g ON s.group_id = g.id
            JOIN subjects sub ON s.subject_id = sub.id
            WHERE s.instructor_id = ? AND s.week_number = ?
            ORDER BY s.week_number, FIELD(s.day_of_week, 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'), s.time_start ASC
        ";
        $stmt = $this->db->prepare($query);
        $stmt->execute([$instructorId, $weekNumber]);
        $this->sendJson($stmt->fetchAll(PDO::FETCH_ASSOC));
    }

    private function checkTimeConflict($instructorId, $groupId, $dayOfWeek, $weekNumber, $startTime, $endTime, $excludeId = null)
    {
        // Только базовая проверка по преподавателю
        $query = "
            SELECT COUNT(*) FROM schedule 
            WHERE instructor_id = ? AND day_of_week = ? AND week_number = ?
            AND ((time_start < ? AND time_end > ?) OR (time_start < ? AND time_end > ?) OR (time_start >= ? AND time_end <= ?))
        ";
        $params = [$instructorId, $dayOfWeek, $weekNumber, $endTime, $startTime, $endTime, $startTime, $startTime, $endTime];
        if ($excludeId) {
            $query .= " AND id != ?";
            $params[] = $excludeId;
        }
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        return $stmt->fetchColumn() > 0 ? 'Преподаватель занят в это время' : null;
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
