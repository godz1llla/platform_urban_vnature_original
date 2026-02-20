<?php
// test_api_call.php

function testApiCall($endpoint, $method = 'GET', $data = [], $token = null)
{
    $url = 'http://localhost:8000/backend/api.php/' . $endpoint;

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);

    $headers = ['Content-Type: application/json'];
    if ($token) {
        $headers[] = 'Authorization: Bearer ' . $token;
    }
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    if (!empty($data)) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    }

    $response = curl_exec($ch);

    if (curl_errno($ch)) {
        echo 'Error:' . curl_error($ch);
    }

    curl_close($ch);
    return $response;
}

function testLogin($username, $password)
{
    echo "Logging in as $username...\n";
    $response = testApiCall('auth/login', 'POST', ['email' => $username, 'password' => $password]);
    $data = json_decode($response, true);

    if (isset($data['token'])) {
        return $data['token'];
    } else {
        echo "Login failed. Response: " . $response . "\n";
    }

    return null;
}
