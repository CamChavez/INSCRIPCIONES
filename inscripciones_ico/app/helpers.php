<?php
/** Helpers de la aplicacion */

function e(?string $s): string {
    return htmlspecialchars($s ?? '', ENT_QUOTES, 'UTF-8');
}

function flash(string $msg, string $type = 'success'): void {
    $_SESSION['flash'] = ['msg' => $msg, 'type' => $type];
}

function flash_render(): string {
    if (empty($_SESSION['flash'])) return '';
    $f = $_SESSION['flash'];
    unset($_SESSION['flash']);
    return "<div class='flash flash-{$f['type']}'>{$f['msg']}</div>";
}

function redirect(string $url): void {
    header("Location: $url");
    exit;
}

function get_int(string $key, int $default = 0): int {
    return isset($_GET[$key]) ? (int)$_GET[$key] : $default;
}

function post_str(string $key, string $default = ''): string {
    return isset($_POST[$key]) ? trim((string)$_POST[$key]) : $default;
}

function url(string $path): string {
    return '/' . ltrim($path, '/');
}

function render(string $view, array $data = []): void {
    extract($data, EXTR_SKIP);
    $contentFile = __DIR__ . '/views/' . $view . '.php';
    ob_start();
    require $contentFile;
    $content = ob_get_clean();
    require __DIR__ . '/views/layouts/main.php';
}

function generar_folio(): string {
    return 'INS-' . date('Ymd') . '-' . strtoupper(substr(uniqid(), -6));
}
