<?php
// test_curator_detailed.php

require_once 'backend/config/Database.php';
require_once 'backend/middleware/AuthMiddleware.php';
require_once 'test_api_call.php'; // Helper for API calls

echo "Testing Detailed Group Attendance Report...\n";

// 1. Login as Curator
$curatorUser = 'test_curator@example.com';
$curatorPass = 'password123';
$token = testLogin($curatorUser, $curatorPass);

if (!$token) {
    echo "❌ Failed to login as curator.\n";
    exit(1);
}
echo "✅ Logged in as curator. Token received.\n";

// 2. Identify a group to test (SVT-21-1 or SVK-22-1)
// We will simply fetch groups first
$groupsResponse = testApiCall('groups', 'GET', [], $token);
$groups = json_decode($groupsResponse, true);

if (empty($groups)) {
    echo "❌ No groups found.\n";
    exit(1);
}

$testGroupId = $groups[0]['id'];
$testGroupName = $groups[0]['name'];
echo "✅ Found group: $testGroupName (ID: $testGroupId)\n";

// 3. Fetch Detailed Report for today
$today = date('Y-m-d');
echo "Fetching report for $today...\n";

$reportResponse = testApiCall("attendance/group-daily-report?group_id=$testGroupId&date=$today", 'GET', [], $token);
$report = json_decode($reportResponse, true);

if (!$report) {
    echo "❌ Failed to decode report JSON.\n";
    echo "Response: $reportResponse\n";
    exit(1);
}

if (!isset($report['lessons']) || !isset($report['students'])) {
    echo "❌ Invalid report structure. Missing 'lessons' or 'students'.\n";
    print_r(array_keys($report));
    exit(1);
}

// 4. Output Summary
echo "✅ Report fetched successfully.\n";
echo "--- Report Summary ---\n";
echo "Lessons today: " . count($report['lessons']) . "\n";
echo "Students in group: " . count($report['students']) . "\n";

if (count($report['lessons']) > 0) {
    echo "First lesson: " . $report['lessons'][0]['subject_name'] . " (" . $report['lessons'][0]['time_start'] . ")\n";
}

if (count($report['students']) > 0) {
    $student = $report['students'][0];
    echo "First student: " . $student['full_name'] . "\n";
    echo "Attendance: " . json_encode($student['attendance']) . "\n";
}

echo "\nTEST PASSED\n";
