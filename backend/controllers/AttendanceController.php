<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

class AttendanceController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/attendance/generate-token
     * Генерация динамического токена для преподавателя
     */
    public function generateToken()
    {
        $user = AuthMiddleware::requireRole(['admin', 'instructor']);

        $teacherId = $user['user_id'];
        $timestamp = time();
        $secretKey = 'URBAN_COLLEGE_SECRET_2026'; // В prod использовать из .env

        // Создать hash
        $hash = hash('sha256', $teacherId . ':' . $timestamp . ':' . $secretKey);

        // Формат токена: teacher_id:timestamp:hash
        $token = $teacherId . ':' . $timestamp . ':' . $hash;

        $this->sendJson([
            'token' => $token,
            'expires_at' => date('Y-m-d H:i:s', $timestamp + 8),
            'teacher_id' => $teacherId
        ]);
    }

    /**
     * POST /api/attendance/mark-self
     * Студент отмечается сам по токену преподавателя
     */
    public function markSelf()
    {
        $user = AuthMiddleware::requireRole(['student']);
        $data = $this->getRequestData();

        $token = $data['token'] ?? null;

        if (!$token) {
            $this->sendError('Токен не указан', 400);
        }

        // Парсинг токена
        $parts = explode(':', $token);
        if (count($parts) !== 3) {
            $this->sendError('Неверный формат токена', 400);
        }

        list($teacherId, $timestamp, $hash) = $parts;

        // Проверка hash
        $secretKey = 'URBAN_COLLEGE_SECRET_2026';
        $expectedHash = hash('sha256', $teacherId . ':' . $timestamp . ':' . $secretKey);

        if ($hash !== $expectedHash) {
            $this->sendError('Неверный токен', 403);
        }

        // Проверка срока действия (8 секунд)
        $currentTime = time();
        if ($currentTime - $timestamp > 8) {
            $this->sendError('Токен истёк', 403);
        }

        // Получить student_id
        $stmt = $this->db->prepare("SELECT id FROM students WHERE user_id = ?");
        $stmt->execute([$user['user_id']]);
        $student = $stmt->fetch();

        if (!$student) {
            $this->sendError('Профиль студента не найден', 404);
        }

        $studentId = $student['id'];

        // Проверка - не отмечен ли уже сегодня
        $today = date('Y-m-d');
        $stmt = $this->db->prepare("SELECT id FROM attendance_records WHERE student_id = ? AND DATE(marked_at) = ?");
        $stmt->execute([$studentId, $today]);

        if ($stmt->fetch()) {
            $this->sendError('Вы уже отмечены сегодня', 400);
        }

        // Создать запись
        $stmt = $this->db->prepare("INSERT INTO attendance_records (student_id, marked_by, status) VALUES (?, ?, 'present')");
        $stmt->execute([$studentId, $teacherId]);

        $this->sendJson([
            'success' => true,
            'marked_at' => date('Y-m-d H:i:s'),
            'message' => 'Вы успешно отмечены!'
        ]);
    }

    /**
     * GET /api/attendance/records
     * История отметок
     */
    public function getRecords()
    {
        AuthMiddleware::requireRole(['admin', 'instructor', 'curator']);

        $from = $_GET['from'] ?? date('Y-m-d');
        $to = $_GET['to'] ?? date('Y-m-d');
        $studentId = $_GET['student_id'] ?? null;

        $query = "
            SELECT ar.id, ar.marked_at, ar.status, ar.notes, s.student_code,
                   u.full_name as student_name, g.name as group_name,
                   marker.full_name as marked_by_name
            FROM attendance_records ar
            JOIN students s ON ar.student_id = s.id
            JOIN users u ON s.user_id = u.id
            JOIN `groups` g ON s.group_id = g.id
            JOIN users marker ON ar.marked_by = marker.id
            WHERE DATE(ar.marked_at) BETWEEN ? AND ?
        ";

        $params = [$from, $to];
        if ($studentId) {
            $query .= " AND ar.student_id = ?";
            $params[] = $studentId;
        }

        $query .= " ORDER BY ar.marked_at DESC LIMIT 100";
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        $this->sendJson($stmt->fetchAll());
    }

    /**
     * GET /api/attendance/stats
     * Статистика
     */
    public function getStats()
    {
        AuthMiddleware::requireRole(['admin', 'instructor', 'curator']);

        $studentId = $_GET['student_id'] ?? null;
        if (!$studentId) {
            $this->sendError('Укажите student_id', 400);
        }

        $monthStart = date('Y-m-01');
        $today = date('Y-m-d');

        $totalDays = $this->countWeekdays($monthStart, $today);

        $stmt = $this->db->prepare("SELECT COUNT(DISTINCT DATE(marked_at)) as present_days FROM attendance_records WHERE student_id = ? AND status = 'present' AND DATE(marked_at) BETWEEN ? AND ?");
        $stmt->execute([$studentId, $monthStart, $today]);
        $presentDays = $stmt->fetch()['present_days'];

        $stmt = $this->db->prepare("SELECT COUNT(*) as late_count FROM attendance_records WHERE student_id = ? AND status = 'late' AND DATE(marked_at) BETWEEN ? AND ?");
        $stmt->execute([$studentId, $monthStart, $today]);
        $lateCount = $stmt->fetch()['late_count'];

        $percentage = $totalDays > 0 ? round(($presentDays / $totalDays) * 100, 1) : 0;

        $this->sendJson([
            'student_id' => $studentId,
            'period' => ['from' => $monthStart, 'to' => $today],
            'total_days' => $totalDays,
            'present_days' => $presentDays,
            'late_count' => $lateCount,
            'percentage' => $percentage
        ]);
    }

    /**
     * GET /api/attendance/my-stats
     * Моя статистика
     */
    public function getMyStats()
    {
        $user = AuthMiddleware::requireRole(['student']);

        $stmt = $this->db->prepare("SELECT id FROM students WHERE user_id = ?");
        $stmt->execute([$user['user_id']]);
        $student = $stmt->fetch();

        if (!$student) {
            $this->sendError('Профиль студента не найден', 404);
        }

        $studentId = $student['id'];
        $monthStart = date('Y-m-01');
        $today = date('Y-m-d');
        $totalDays = $this->countWeekdays($monthStart, $today);

        $stmt = $this->db->prepare("SELECT COUNT(DISTINCT DATE(marked_at)) as present_days FROM attendance_records WHERE student_id = ? AND status = 'present' AND DATE(marked_at) BETWEEN ? AND ?");
        $stmt->execute([$studentId, $monthStart, $today]);
        $presentDays = $stmt->fetch()['present_days'];

        $stmt = $this->db->prepare("SELECT COUNT(*) as late_count FROM attendance_records WHERE student_id = ? AND status = 'late' AND DATE(marked_at) BETWEEN ? AND ?");
        $stmt->execute([$studentId, $monthStart, $today]);
        $lateCount = $stmt->fetch()['late_count'];

        $percentage = $totalDays > 0 ? round(($presentDays / $totalDays) * 100, 1) : 0;

        $this->sendJson([
            'period' => ['from' => $monthStart, 'to' => $today],
            'total_days' => $totalDays,
            'present_days' => $presentDays,
            'late_count' => $lateCount,
            'percentage' => $percentage
        ]);
    }

    /**
     * GET /api/attendance/absent-report
     * Отчет об отсутствующих (для куратора)
     */
    public function getAbsentReport()
    {
        AuthMiddleware::requireRole(['admin', 'curator', 'instructor']);

        $today = date('Y-m-d');

        // 1. Получить всех студентов с их группами
        $query = "
            SELECT s.id, s.student_code, u.full_name, g.name as group_name, g.id as group_id
            FROM students s
            JOIN users u ON s.user_id = u.id
            JOIN `groups` g ON s.group_id = g.id
            ORDER BY g.name, u.full_name
        ";
        $stmt = $this->db->prepare($query);
        $stmt->execute();
        $allStudents = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // 2. Получить ID студентов, которые отметились сегодня
        $stmt = $this->db->prepare("SELECT student_id FROM attendance_records WHERE DATE(marked_at) = ?");
        $stmt->execute([$today]);
        $presentStudentIds = $stmt->fetchAll(PDO::FETCH_COLUMN);

        // 3. Вычесть присутствующих
        $absentStudents = [];
        foreach ($allStudents as $student) {
            if (!in_array($student['id'], $presentStudentIds)) {
                $groupName = $student['group_name'];
                if (!isset($absentStudents[$groupName])) {
                    $absentStudents[$groupName] = [];
                }
                $absentStudents[$groupName][] = $student;
            }
        }

        $this->sendJson($absentStudents);
    }

    /**
     * GET /api/attendance/group-daily-report
     * Детальный отчет по группе на конкретную дату
     */
    public function getGroupDailyReport()
    {
        AuthMiddleware::requireRole(['admin', 'curator', 'instructor']);

        $groupId = $_GET['group_id'] ?? null;
        $date = $_GET['date'] ?? date('Y-m-d');

        if (!$groupId) {
            $this->sendError('Не указан group_id', 400);
        }

        // 1. Получить расписание на этот день
        $dayOfWeek = strtolower(date('l', strtotime($date)));
        $query = "
            SELECT sch.*, s.name as subject_name, u.full_name as instructor_name
            FROM schedule sch
            JOIN subjects s ON sch.subject_id = s.id
            JOIN users u ON sch.instructor_id = u.id
            WHERE sch.group_id = ? AND sch.day_of_week = ?
            ORDER BY sch.time_start
        ";
        $stmt = $this->db->prepare($query);
        $stmt->execute([$groupId, $dayOfWeek]);
        $lessons = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // 2. Получить список студентов группы
        $stmt = $this->db->prepare("
            SELECT s.id, u.full_name, s.student_code
            FROM students s
            JOIN users u ON s.user_id = u.id
            WHERE s.group_id = ?
            ORDER BY u.full_name
        ");
        $stmt->execute([$groupId]);
        $students = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // 3. Получить все отметки посещаемости этой группы за эту дату
        $stmt = $this->db->prepare("
            SELECT ar.student_id, ar.marked_at, ar.status
            FROM attendance_records ar
            JOIN students s ON ar.student_id = s.id
            WHERE s.group_id = ? AND DATE(ar.marked_at) = ?
        ");
        $stmt->execute([$groupId, $date]);
        $records = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // 4. Сопоставление (Matching)
        // Структура ответа:
        // students: [
        //    { ...student, attendance: { [lesson_id]: 'present' | 'absent' } }
        // ]

        foreach ($students as &$student) {
            $student['attendance'] = [];

            // Фильтруем записи конкретного студента
            $studentRecords = array_filter($records, function ($r) use ($student) {
                return $r['student_id'] == $student['id'];
            });

            foreach ($lessons as $lesson) {
                $status = 'absent'; // По умолчанию отсутствует

                $lessonStart = strtotime($date . ' ' . $lesson['time_start']);
                $lessonEnd = strtotime($date . ' ' . $lesson['time_end']);

                // Допуск +/- 15 минут (или можно брать весь интервал урока)
                // Считаем присутствующим, если отметился ВНУТРИ интервала урока (с буфером)
                // Буфер: start - 15 min, end + 15 min
                $bufferStart = $lessonStart - (15 * 60);
                $bufferEnd = $lessonEnd + (15 * 60);

                foreach ($studentRecords as $record) {
                    $markedTime = strtotime($record['marked_at']);
                    if ($markedTime >= $bufferStart && $markedTime <= $bufferEnd) {
                        $status = 'present';
                        break;
                    }
                }

                $student['attendance'][$lesson['id']] = $status;
            }
        }

        $this->sendJson([
            'date' => $date,
            'lessons' => $lessons,
            'students' => $students
        ]);
    }

    private function countWeekdays($from, $to)
    {
        $start = new DateTime($from);
        $end = new DateTime($to);
        $count = 0;

        while ($start <= $end) {
            $dayOfWeek = (int) $start->format('N');
            if ($dayOfWeek <= 5) {
                $count++;
            }
            $start->modify('+1 day');
        }

        return $count;
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
