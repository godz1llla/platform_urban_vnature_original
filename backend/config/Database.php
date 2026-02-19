<?php
/**
 * Database Connection Class
 * Singleton pattern для подключения к MySQL через PDO
 */

class Database
{
    private static $instance = null;
    private $connection;

    // Настройки подключения
    private $host = 'localhost';
    private $database = 'infogok1_1';
    private $username = 'infogok1_1';
    private $password = 'Gabi2005@';
    private $charset = 'utf8mb4';

    /**
     * Приватный конструктор (Singleton)
     */
    private function __construct()
    {
        $dsn = "mysql:host={$this->host};dbname={$this->database};charset={$this->charset}";

        $options = [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ];

        try {
            $this->connection = new PDO($dsn, $this->username, $this->password, $options);
        } catch (PDOException $e) {
            throw new PDOException($e->getMessage(), (int) $e->getCode());
        }
    }

    /**
     * Получить экземпляр Database (Singleton)
     */
    public static function getInstance()
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Получить PDO соединение
     */
    public function getConnection()
    {
        return $this->connection;
    }

    /**
     * Запретить клонирование (Singleton)
     */
    private function __clone()
    {
    }

    /**
     * Запретить десериализацию (Singleton)
     */
    public function __wakeup()
    {
        throw new Exception("Cannot unserialize singleton");
    }
}
