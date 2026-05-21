<?php
/**
 * Front controller - Inscripciones ICO
 * Equipo 13 - FES Aragon UNAM
 */
session_start();
require __DIR__ . '/../app/Database.php';
require __DIR__ . '/../app/helpers.php';

$ruta   = $_GET['r']      ?? 'home';
$accion = $_GET['accion'] ?? 'index';

// Ruteo simple
$controllers = [
    'home'         => 'HomeController',
    'alumno'       => 'AlumnoController',
    'profesor'     => 'ProfesorController',
    'materia'      => 'MateriaController',
    'aula'         => 'AulaController',
    'grupo'        => 'GrupoController',
    'horario'      => 'HorarioController',
    'area'         => 'AreaController',
    'carrera'      => 'CarreraController',
    'inscripcion'  => 'InscripcionController',
    'comprobante'  => 'ComprobanteController',
    'busqueda'     => 'BusquedaController',
];

if (!isset($controllers[$ruta])) {
    http_response_code(404);
    echo "<h1>404 - Ruta no encontrada</h1>";
    exit;
}

$controllerName = $controllers[$ruta];
$file = __DIR__ . "/../app/controllers/$controllerName.php";
if (!file_exists($file)) {
    die("Controlador no encontrado: $controllerName");
}
require $file;

$ctrl = new $controllerName();
if (!method_exists($ctrl, $accion)) {
    $accion = 'index';
}
$ctrl->$accion();
