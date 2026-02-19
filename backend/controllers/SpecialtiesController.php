<?php

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

class SpecialtiesController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * GET /api/specialties
     * Получить список всех специальностей
     */
    public function getAll()
    {
        try {
            $stmt = $this->db->query("
                SELECT 
                    id,
                    code,
                    name_kz,
                    name_ru,
                    duration_months,
                    created_at
                FROM specialties
                ORDER BY name_kz
            ");

            $specialties = $stmt->fetchAll(PDO::FETCH_ASSOC);

            http_response_code(200);
            echo json_encode($specialties);

        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка получения специальностей: ' . $e->getMessage()]);
        }
    }

    /**
     * GET /api/specialties/{id}
     * Получить специальность по ID
     */
    public function getById($id)
    {
        try {
            $stmt = $this->db->prepare("
                SELECT 
                    id,
                    code,
                    name_kz,
                    name_ru,
                    duration_months,
                    created_at
                FROM specialties
                WHERE id = ?
            ");

            $stmt->execute([$id]);
            $specialty = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$specialty) {
                http_response_code(404);
                echo json_encode(['error' => 'Специальность не найдена']);
                return;
            }

            // Получить количество студентов на этой специальности
            $stmt = $this->db->prepare("
                SELECT COUNT(*) as student_count
                FROM students
                WHERE specialty_id = ?
            ");
            $stmt->execute([$id]);
            $specialty['student_count'] = $stmt->fetch(PDO::FETCH_ASSOC)['student_count'];

            http_response_code(200);
            echo json_encode($specialty);

        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка получения специальности: ' . $e->getMessage()]);
        }
    }

    /**
     * POST /api/specialties
     * Создать новую специальность (только admin)
     */
    public function create()
    {
        AuthMiddleware::requireRole(['admin']);

        try {
            $input = json_decode(file_get_contents('php://input'), true);

            // Валидация
            if (empty($input['code']) || empty($input['name_kz'])) {
                http_response_code(400);
                echo json_encode(['error' => 'Код и название (каз) обязательны']);
                return;
            }

            // Проверка уникальности кода
            $stmt = $this->db->prepare("SELECT id FROM specialties WHERE code = ?");
            $stmt->execute([$input['code']]);
            if ($stmt->fetch()) {
                http_response_code(400);
                echo json_encode(['error' => 'Специальность с таким кодом уже существует']);
                return;
            }

            $stmt = $this->db->prepare("
                INSERT INTO specialties (code, name_kz, name_ru, duration_months)
                VALUES (?, ?, ?, ?)
            ");

            $stmt->execute([
                $input['code'],
                $input['name_kz'],
                $input['name_ru'] ?? null,
                $input['duration_months'] ?? null
            ]);

            $newId = $this->db->lastInsertId();

            http_response_code(201);
            echo json_encode([
                'message' => 'Специальность создана',
                'id' => $newId
            ]);

        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка создания специальности: ' . $e->getMessage()]);
        }
    }

    /**
     * PUT /api/specialties/{id}
     * Обновить специальность (только admin)
     */
    public function update($id)
    {
        AuthMiddleware::requireRole(['admin']);

        try {
            $input = json_decode(file_get_contents('php://input'), true);

            // Проверка существования
            $stmt = $this->db->prepare("SELECT id FROM specialties WHERE id = ?");
            $stmt->execute([$id]);
            if (!$stmt->fetch()) {
                http_response_code(404);
                echo json_encode(['error' => 'Специальность не найдена']);
                return;
            }

            // Проверка уникальности кода (если изменяется)
            if (!empty($input['code'])) {
                $stmt = $this->db->prepare("SELECT id FROM specialties WHERE code = ? AND id != ?");
                $stmt->execute([$input['code'], $id]);
                if ($stmt->fetch()) {
                    http_response_code(400);
                    echo json_encode(['error' => 'Специальность с таким кодом уже существует']);
                    return;
                }
            }

            $stmt = $this->db->prepare("
                UPDATE specialties
                SET code = ?,
                    name_kz = ?,
                    name_ru = ?,
                    duration_months = ?
                WHERE id = ?
            ");

            $stmt->execute([
                $input['code'],
                $input['name_kz'],
                $input['name_ru'] ?? null,
                $input['duration_months'] ?? null,
                $id
            ]);

            http_response_code(200);
            echo json_encode(['message' => 'Специальность обновлена']);

        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка обновления специальности: ' . $e->getMessage()]);
        }
    }

    /**
     * DELETE /api/specialties/{id}
     * Удалить специальность (только admin)
     */
    public function delete($id)
    {
        AuthMiddleware::requireRole(['admin']);

        try {
            // Проверить есть ли студенты на этой специальности
            $stmt = $this->db->prepare("
                SELECT COUNT(*) as count
                FROM students
                WHERE specialty_id = ?
            ");
            $stmt->execute([$id]);
            $count = $stmt->fetch(PDO::FETCH_ASSOC)['count'];

            if ($count > 0) {
                http_response_code(400);
                echo json_encode([
                    'error' => "Невозможно удалить специальность. На ней обучается $count студентов"
                ]);
                return;
            }

            $stmt = $this->db->prepare("DELETE FROM specialties WHERE id = ?");
            $stmt->execute([$id]);

            if ($stmt->rowCount() === 0) {
                http_response_code(404);
                echo json_encode(['error' => 'Специальность не найдена']);
                return;
            }

            http_response_code(200);
            echo json_encode(['message' => 'Специальность удалена']);

        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Ошибка удаления специальности: ' . $e->getMessage()]);
        }
    }
}
