<?php
/**
 * Clase Database (Singleton PDO)
 */
class Database {
    private static ?PDO $pdo = null;

    public static function pdo(): PDO {
        if (self::$pdo === null) {
            $cfg = require __DIR__ . '/../config/db.php';
            $dsn = "mysql:host={$cfg['host']};port={$cfg['port']};dbname={$cfg['dbname']};charset={$cfg['charset']}";
            try {
                self::$pdo = new PDO($dsn, $cfg['user'], $cfg['pass'], [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => false,
                ]);
            } catch (PDOException $e) {
                die("<h2>Error de conexion</h2><p>" . htmlspecialchars($e->getMessage()) . "</p>"
                   ."<p>Verifica config/db.php y que MySQL este corriendo.</p>");
            }
        }
        return self::$pdo;
    }
}
