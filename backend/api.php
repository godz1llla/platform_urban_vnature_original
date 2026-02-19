<?php
/**
 * API Router
 * Маршрутизация запросов к контроллерам
 */

// CORS заголовки
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Обработка OPTIONS preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Получение пути из query параметра
$path = $_GET['path'] ?? '';
$method = $_SERVER['REQUEST_METHOD'];

// Разбор пути
$pathParts = array_filter(explode('/', $path));
$pathParts = array_values($pathParts); // Переиндексация

if (empty($pathParts)) {
    echo json_encode(['status' => 'API is running']);
    exit;
}

try {
    // === AUTH ROUTES ===
    if ($pathParts[0] === 'auth') {
        require_once __DIR__ . '/controllers/AuthController.php';
        $controller = new AuthController();

        if ($pathParts[1] === 'login' && $method === 'POST') {
            $controller->login();
        } elseif ($pathParts[1] === 'me' && $method === 'GET') {
            $controller->me();
        }
    }

    // === CAFETERIA ROUTES ===
    elseif ($pathParts[0] === 'cafeteria') {
        require_once __DIR__ . '/controllers/CafeteriaController.php';
        $controller = new CafeteriaController();

        // Categories
        if ($pathParts[1] === 'categories') {
            if ($method === 'GET') {
                $controller->getCategories();
            } elseif ($method === 'POST') {
                $controller->createCategory();
            } elseif ($method === 'PUT' && isset($pathParts[2])) {
                $controller->updateCategory($pathParts[2]);
            } elseif ($method === 'DELETE' && isset($pathParts[2])) {
                $controller->deleteCategory($pathParts[2]);
            }
        }
        // Assignments
        elseif ($pathParts[1] === 'assignments') {
            if ($method === 'GET') {
                if (isset($pathParts[2]) && $pathParts[2] === 'unassigned') {
                    $controller->getUnassignedStudents();
                } else {
                    $controller->getAssignments();
                }
            }
        }
        // Assign/Unassign
        elseif ($pathParts[1] === 'assign') {
            if ($method === 'POST') {
                $controller->assignStudent();
            } elseif ($method === 'DELETE' && isset($pathParts[2])) {
                $controller->unassignStudent($pathParts[2]);
            }
        }
        // Operator QR & Scanning
        elseif ($pathParts[1] === 'operator-qr' && $method === 'GET') {
            $controller->getOperatorQR();
        } elseif ($pathParts[1] === 'scan-operator' && $method === 'POST') {
            $controller->scanOperator();
        }
        // Serve
        elseif ($pathParts[1] === 'serve') {
            if ($method === 'POST') {
                $controller->serveMeal();
            } elseif ($method === 'GET' && isset($pathParts[2]) && $pathParts[2] === 'check' && isset($pathParts[3])) {
                $controller->checkStudent($pathParts[3]);
            }
        }
        // Transactions
        elseif ($pathParts[1] === 'transactions') {
            if ($method === 'GET') {
                if (isset($pathParts[2]) && $pathParts[2] === 'export') {
                    $controller->exportTransactions();
                } else {
                    $controller->getTransactions();
                }
            }
        }
    }

    // === USERS ROUTES (Admin only) ===
    elseif ($pathParts[0] === 'users') {
        require_once __DIR__ . '/controllers/UsersController.php';
        $controller = new UsersController();

        if ($method === 'GET') {
            if (isset($pathParts[1])) {
                $controller->getUserById($pathParts[1]);
            } else {
                $controller->getAllUsers();
            }
        } elseif ($method === 'POST') {
            if (isset($pathParts[1]) && isset($pathParts[2]) && $pathParts[2] === 'generate-qr') {
                $controller->regenerateQR($pathParts[1]);
            } else {
                $controller->createUser();
            }
        } elseif ($method === 'PUT' && isset($pathParts[1])) {
            $controller->updateUser($pathParts[1]);
        } elseif ($method === 'DELETE' && isset($pathParts[1])) {
            $controller->deleteUser($pathParts[1]);
        }
    }

    // === SPECIALTIES ROUTES (НОВОЕ!) ===
    elseif ($pathParts[0] === 'specialties') {
        require_once __DIR__ . '/controllers/SpecialtiesController.php';
        $controller = new SpecialtiesController();

        if ($method === 'GET') {
            if (isset($pathParts[1])) {
                $controller->getById($pathParts[1]);
            } else {
                $controller->getAll();
            }
        } elseif ($method === 'POST' && !isset($pathParts[1])) {
            $controller->create();
        } elseif ($method === 'PUT' && isset($pathParts[1])) {
            $controller->update($pathParts[1]);
        } elseif ($method === 'DELETE' && isset($pathParts[1])) {
            $controller->delete($pathParts[1]);
        }
    }

    // === STUDENTS ROUTES ===
    elseif ($pathParts[0] === 'students') {
        require_once __DIR__ . '/controllers/StudentController.php';
        $controller = new StudentController();

        if ($method === 'GET') {
            if (isset($pathParts[1]) && $pathParts[1] === 'my-info') {
                $controller->getMyInfo();
            } else {
                $controller->getAllStudents();
            }
        }
    }

    // === GROUPS ROUTES ===
    elseif ($pathParts[0] === 'groups') {
        require_once __DIR__ . '/controllers/GroupsController.php';
        $controller = new GroupsController();

        if ($method === 'GET') {
            if (isset($pathParts[1]) && isset($pathParts[2]) && $pathParts[2] === 'students') {
                $controller->getGroupStudents($pathParts[1]);
            } elseif (!isset($pathParts[1])) {
                $controller->getAllGroups();
            }
        } elseif ($method === 'POST') {
            if (isset($pathParts[1]) && isset($pathParts[2]) && $pathParts[2] === 'add-student') {
                $controller->addStudentToGroup($pathParts[1]);
            } elseif (isset($pathParts[1]) && isset($pathParts[2]) && $pathParts[2] === 'remove-student') {
                $controller->removeStudentFromGroup($pathParts[1]);
            } else {
                $controller->createGroup();
            }
        } elseif ($method === 'PUT' && isset($pathParts[1])) {
            $controller->updateGroup($pathParts[1]);
        } elseif ($method === 'DELETE' && isset($pathParts[1])) {
            $controller->deleteGroup($pathParts[1]);
        }
    }

    // === SUBJECTS ROUTES ===
    elseif ($pathParts[0] === 'subjects') {
        require_once __DIR__ . '/controllers/SubjectsController.php';
        $controller = new SubjectsController();

        if ($method === 'GET') {
            if (isset($pathParts[1]) && isset($pathParts[2]) && $pathParts[2] === 'instructors') {
                $controller->getSubjectInstructors($pathParts[1]);
            } elseif (!isset($pathParts[1])) {
                $controller->getAllSubjects();
            }
        } elseif ($method === 'POST') {
            if (isset($pathParts[1]) && isset($pathParts[2]) && $pathParts[2] === 'assign-instructor') {
                $controller->assignInstructor($pathParts[1]);
            } elseif (isset($pathParts[1]) && isset($pathParts[2]) && $pathParts[2] === 'unassign-instructor') {
                $controller->unassignInstructor($pathParts[1]);
            } else {
                $controller->createSubject();
            }
        } elseif ($method === 'PUT' && isset($pathParts[1])) {
            $controller->updateSubject($pathParts[1]);
        } elseif ($method === 'DELETE' && isset($pathParts[1])) {
            $controller->deleteSubject($pathParts[1]);
        }
    }

    // === GRADES ROUTES ===
    elseif ($pathParts[0] === 'grades') {
        require_once __DIR__ . '/controllers/GradesController.php';
        $controller = new GradesController();

        if (!isset($pathParts[1])) {
            if ($method === 'GET')
                $controller->getAllGrades();
            elseif ($method === 'POST')
                $controller->createGrade();
        } elseif ($pathParts[1] === 'my' && $method === 'GET') {
            $controller->getMyGrades();
        } elseif ($pathParts[1] === 'student' && isset($pathParts[2]) && $method === 'GET') {
            $controller->getStudentGrades($pathParts[2]);
        } elseif ($method === 'PUT' && isset($pathParts[1])) {
            $controller->updateGrade($pathParts[1]);
        } elseif ($method === 'DELETE' && isset($pathParts[1])) {
            $controller->deleteGrade($pathParts[1]);
        }
    }

    // === SCHEDULE ROUTES ===
    elseif ($pathParts[0] === 'schedule') {
        require_once __DIR__ . '/controllers/ScheduleController.php';
        $controller = new ScheduleController();

        if ($method === 'GET') {
            if (isset($pathParts[1]) && $pathParts[1] === 'my') {
                $controller->getMySchedule();
            } elseif (isset($pathParts[1]) && $pathParts[1] === 'group' && isset($pathParts[2])) {
                $controller->getScheduleByGroup($pathParts[2]);
            } elseif (isset($pathParts[1]) && $pathParts[1] === 'instructor' && isset($pathParts[2])) {
                $controller->getScheduleByInstructor($pathParts[2]);
            } else {
                $controller->getAllLessons();
            }
        } elseif ($method === 'POST') {
            $controller->createLesson();
        } elseif ($method === 'PUT' && isset($pathParts[1])) {
            $controller->updateLesson($pathParts[1]);
        } elseif ($method === 'DELETE' && isset($pathParts[1])) {
            $controller->deleteLesson($pathParts[1]);
        }
    }

    // === ATTENDANCE ROUTES ===
    elseif ($pathParts[0] === 'attendance') {
        require_once __DIR__ . '/controllers/AttendanceController.php';
        $controller = new AttendanceController();

        if ($pathParts[1] === 'generate-token' && $method === 'GET') {
            $controller->generateToken();
        } elseif ($pathParts[1] === 'mark-self' && $method === 'POST') {
            $controller->markSelf();
        } elseif ($pathParts[1] === 'records' && $method === 'GET') {
            $controller->getRecords();
        } elseif ($pathParts[1] === 'stats' && $method === 'GET') {
            $controller->getStats();
        } elseif ($pathParts[1] === 'my-stats' && $method === 'GET') {
            $controller->getMyStats();
        } elseif ($pathParts[1] === 'absent-report' && $method === 'GET') {
            $controller->getAbsentReport();
        }
    }

    // === DASHBOARD ROUTES ===
    elseif ($pathParts[0] === 'dashboard') {
        require_once __DIR__ . '/controllers/DashboardController.php';
        $controller = new DashboardController();

        if (isset($pathParts[1]) && $pathParts[1] === 'stats' && $method === 'GET') {
            $controller->getStats();
        }
    } else {
        http_response_code(404);
        echo json_encode(['error' => 'Route not found: ' . $path]);
    }

} catch (Exception $e) {
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'error' => 'Server Error',
        'message' => $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
}
