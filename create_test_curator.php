<?php
// create_test_curator.php

require_once 'backend/config/Database.php';

$db = Database::getInstance()->getConnection();

$email = 'test_curator@example.com';
$password = 'password123';
$hash = password_hash($password, PASSWORD_DEFAULT);
$name = 'Test Curator';
$role = 'curator';

// Check if exists
$stmt = $db->prepare("SELECT id FROM users WHERE email = ?");
$stmt->execute([$email]);
if ($stmt->fetch()) {
    echo "User $email already exists.\n";
    // Update password just in case
    $stmt = $db->prepare("UPDATE users SET password_hash = ?, role = ? WHERE email = ?");
    $stmt->execute([$hash, $role, $email]);
    echo "Updated password and role for $email.\n";
} else {
    $stmt = $db->prepare("INSERT INTO users (full_name, email, password_hash, role) VALUES (?, ?, ?, ?)");
    $stmt->execute([$name, $email, $hash, $role]);
    echo "Created user $email.\n";
}
