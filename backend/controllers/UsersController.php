<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

class UsersController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/users
     * Список всех пользователей (ИСПРАВЛЕНО: Добавлены ИИН, телефон, спец)
     */
    public function getAllUsers()
    {
        AuthMiddleware::requireRole(['admin']);

        $role = $_GET['role'] ?? null;
        $search = $_GET['search'] ?? '';

        // Основной запрос по пользователям
        $query = "
            SELECT 
                u.id,
                u.full_name,
                u.email,
                u.role,
                u.position,
                u.created_at
            FROM users u
            WHERE 1=1
        ";

        $params = [];

        if ($role) {
            $query .= " AND u.role = ?";
            $params[] = $role;
        }

        if ($search) {
            $query .= " AND (u.full_name LIKE ? OR u.email LIKE ?)";
            $searchParam = '%' . $search . '%';
            $params[] = $searchParam;
            $params[] = $searchParam;
        }

        $query .= " ORDER BY u.created_at DESC";

        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Обогащаем данные (JOIN данных студента или преподавателя)
        foreach ($users as &$user) {

            // --- СТУДЕНТЫ ---
            if ($user['role'] === 'student') {
                // ИСПРАВЛЕНИЕ ТУТ: Добавили выборку iin, phone, academic_leave, specialty
                $stmt = $this->db->prepare("
                    SELECT 
                        s.student_code, 
                        s.qr_token, 
                        s.iin, 
                        s.phone,
                        s.academic_leave,
                        g.name as group_name, 
                        g.id as group_id,
                        sp.name_kz as specialty_name_kz,
                        sp.name_ru as specialty_name_ru,
                        sp.code as specialty_code
                    FROM students s
                    LEFT JOIN `groups` g ON s.group_id = g.id
                    LEFT JOIN `specialties` sp ON s.specialty_id = sp.id
                    WHERE s.user_id = ?
                ");
                $stmt->execute([$user['id']]);
                $studentData = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($studentData) {
                    $user = array_merge($user, $studentData);
                }
            }

            // --- ПРЕПОДАВАТЕЛИ ---
            elseif ($user['role'] === 'instructor') {
                // Предметы строкой
                $stmtSub = $this->db->prepare("
                    SELECT s.name 
                    FROM subjects s
                    JOIN instructor_subjects ins ON s.id = ins.subject_id
                    WHERE ins.instructor_id = ?
                ");
                $stmtSub->execute([$user['id']]);
                $subjects = $stmtSub->fetchAll(PDO::FETCH_COLUMN);
                $user['subjects_str'] = !empty($subjects) ? implode(', ', $subjects) : 'Нет предметов';

                // Кураторство
                $stmtCur = $this->db->prepare("SELECT name FROM `groups` WHERE curator_id = ?");
                $stmtCur->execute([$user['id']]);
                $curatorGroup = $stmtCur->fetch(PDO::FETCH_COLUMN);
                $user['curator_of'] = $curatorGroup ? $curatorGroup : '-';
            }
        }

        $this->sendJson($users);
    }

    /**
     * GET /api/users/{id}
     * Получить одного (для редактирования)
     */
    public function getUserById($userId)
    {
        AuthMiddleware::requireRole(['admin']);

        $stmt = $this->db->prepare("SELECT * FROM users WHERE id = ?");
        $stmt->execute([$userId]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            $this->sendError('Пользователь не найден', 404);
        }
        unset($user['password_hash']);

        if ($user['role'] === 'student') {
            $stmt = $this->db->prepare("SELECT * FROM students WHERE user_id = ?");
            $stmt->execute([$userId]);
            $studentData = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($studentData) {
                unset($studentData['id']); // Убираем ID студента, чтобы не перетереть ID юзера
                $user = array_merge($user, $studentData);
            }
        }

        if ($user['role'] === 'instructor') {
            $stmt = $this->db->prepare("SELECT s.id, s.name FROM subjects s JOIN instructor_subjects ins ON s.id = ins.subject_id WHERE ins.instructor_id = ?");
            $stmt->execute([$userId]);
            $user['subjects'] = $stmt->fetchAll(PDO::FETCH_ASSOC);

            $stmt = $this->db->prepare("SELECT id, name FROM `groups` WHERE curator_id = ?");
            $stmt->execute([$userId]);
            $curatorGroup = $stmt->fetch(PDO::FETCH_ASSOC);
            $user['curator_group_id'] = $curatorGroup ? $curatorGroup['id'] : null;
        }

        $this->sendJson($user);
    }

    /**
     * POST /api/users
     * Создание
     */
    public function createUser()
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        $fullName = $data['full_name'] ?? null;
        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;
        $role = $data['role'] ?? 'student';
        $position = isset($data['position']) ? $data['position'] : null;

        if (!$fullName || !$email || !$password) {
            $this->sendError('Заполните обязательные поля', 400);
        }

        $stmt = $this->db->prepare("SELECT id FROM users WHERE email = ?");
        $stmt->execute([$email]);
        if ($stmt->fetch()) {
            $this->sendError('Email уже занят', 400);
        }

        $passwordHash = password_hash($password, PASSWORD_BCRYPT);

        try {
            $this->db->beginTransaction();

            $stmt = $this->db->prepare("INSERT INTO users (full_name, email, password_hash, role, position) VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$fullName, $email, $passwordHash, $role, $position]);
            $userId = $this->db->lastInsertId();

            if ($role === 'student') {
                $this->saveStudentData($userId, $data, true);
            }

            if ($role === 'instructor') {
                if (isset($data['subject_ids']))
                    $this->assignInstructorSubjects($userId, $data['subject_ids']);
                if (!empty($data['curator_group_id']))
                    $this->assignCurator($userId, $data['curator_group_id']);
            }

            $this->db->commit();
            $this->sendJson(['success' => true, 'message' => 'Создано успешно'], 201);

        } catch (Exception $e) {
            $this->db->rollBack();
            $this->sendError($e->getMessage(), 500);
        }
    }

    /**
     * PUT /api/users/{id}
     * Обновление
     */
    public function updateUser($userId)
    {
        AuthMiddleware::requireRole(['admin']);
        $data = $this->getRequestData();

        if (!$userId)
            $this->sendError('No ID', 400);

        try {
            $this->db->beginTransaction();

            $fields = ['full_name = ?', 'email = ?', 'role = ?', 'position = ?'];
            $values = [$data['full_name'], $data['email'], $data['role'], $data['position'] ?? null];

            if (!empty($data['password'])) {
                $fields[] = 'password_hash = ?';
                $values[] = password_hash($data['password'], PASSWORD_BCRYPT);
            }

            $values[] = $userId;
            $sql = "UPDATE users SET " . implode(', ', $fields) . " WHERE id = ?";
            $this->db->prepare($sql)->execute($values);

            if ($data['role'] === 'student') {
                $this->saveStudentData($userId, $data, false);
            }

            if ($data['role'] === 'instructor') {
                if (isset($data['subject_ids']))
                    $this->updateInstructorSubjects($userId, $data['subject_ids']);
                if (array_key_exists('curator_group_id', $data))
                    $this->updateCurator($userId, $data['curator_group_id']);
            }

            $this->db->commit();
            $this->sendJson(['success' => true, 'message' => 'Обновлено']);

        } catch (Exception $e) {
            $this->db->rollBack();
            $this->sendError($e->getMessage(), 500);
        }
    }

    // === ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ===

    private function saveStudentData($userId, $data, $isNew)
    {
        // Подготовка данных
        $iin = $data['iin'] ?? null;
        $studentCode = $iin ? 'STU' . substr($iin, 0, 6) : 'STU' . str_pad($userId, 6, '0', STR_PAD_LEFT);

        // QR генерируем только для новых или если нет
        $qrToken = $isNew ? ('QR_' . ($iin ?: uniqid())) : null;

        // SQL для вставки или обновления (Upsert логика сложная, проще проверить наличие)
        $check = $this->db->prepare("SELECT id FROM students WHERE user_id = ?");
        $check->execute([$userId]);
        $exists = $check->fetch();

        $params = [
            !empty($data['group_id']) ? $data['group_id'] : null,
            !empty($data['specialty_id']) ? $data['specialty_id'] : null,
            $iin,
            $data['gender'] ?? null,
            $data['date_of_birth'] ?? null,
            $data['nationality'] ?? null,
            $data['citizenship'] ?? null,
            $data['phone'] ?? null,
            $data['address'] ?? null,
            $data['region'] ?? null,
            $data['district'] ?? null,
            $data['city'] ?? null,
            $data['education_level'] ?? null,
            !empty($data['funding_type']) ? $data['funding_type'] : null,
            !empty($data['education_language']) ? $data['education_language'] : null,
            $data['education_form'] ?? null,
            !empty($data['enrollment_date']) ? $data['enrollment_date'] : null,
            $data['enrollment_order'] ?? null,
            !empty($data['academic_leave']) ? 1 : 0,
            !empty($data['dual_education']) ? 1 : 0
        ];

        if ($exists) {
            // Update
            $sql = "UPDATE students SET 
                group_id=?, specialty_id=?, iin=?, gender=?, date_of_birth=?, nationality=?, citizenship=?,
                phone=?, address=?, region=?, district=?, city=?, education_level=?, funding_type=?,
                education_language=?, education_form=?, enrollment_date=?, enrollment_order=?, academic_leave=?, dual_education=?
                WHERE user_id=?";
            $params[] = $userId;
        } else {
            // Insert
            $sql = "INSERT INTO students (
                group_id, specialty_id, iin, gender, date_of_birth, nationality, citizenship,
                phone, address, region, district, city, education_level, funding_type,
                education_language, education_form, enrollment_date, enrollment_order, academic_leave, dual_education,
                user_id, student_code, qr_token
            ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?, ?, ?)";
            $params[] = $userId;
            $params[] = $studentCode;
            $params[] = $qrToken;
        }

        $this->db->prepare($sql)->execute($params);
    }

    public function deleteUser($userId)
    {
        AuthMiddleware::requireRole(['admin']);
        $this->db->prepare("DELETE FROM users WHERE id = ?")->execute([$userId]);
        $this->sendJson(['success' => true]);
    }

    private function assignInstructorSubjects($instructorId, $subjectIds)
    {
        $stmt = $this->db->prepare("INSERT IGNORE INTO instructor_subjects (instructor_id, subject_id) VALUES (?, ?)");
        foreach ($subjectIds as $subjectId) {
            $stmt->execute([$instructorId, $subjectId]);
        }
    }

    private function updateInstructorSubjects($instructorId, $subjectIds)
    {
        $this->db->prepare("DELETE FROM instructor_subjects WHERE instructor_id = ?")->execute([$instructorId]);
        if (!empty($subjectIds))
            $this->assignInstructorSubjects($instructorId, $subjectIds);
    }

    private function assignCurator($instructorId, $groupId)
    {
        $this->db->prepare("UPDATE `groups` SET curator_id = NULL WHERE id = ?")->execute([$groupId]);
        $this->db->prepare("UPDATE `groups` SET curator_id = ? WHERE id = ?")->execute([$instructorId, $groupId]);
    }

    private function updateCurator($instructorId, $groupId)
    {
        $this->db->prepare("UPDATE `groups` SET curator_id = NULL WHERE curator_id = ?")->execute([$instructorId]);
        if (!empty($groupId))
            $this->assignCurator($instructorId, $groupId);
    }

    public function regenerateQR($userId)
    {
        AuthMiddleware::requireRole(['admin']);
        $qrToken = 'QR_' . uniqid();
        $this->db->prepare("UPDATE students SET qr_token = ? WHERE user_id = ?")->execute([$qrToken, $userId]);
        $this->sendJson(['success' => true, 'qr_token' => $qrToken]);
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
