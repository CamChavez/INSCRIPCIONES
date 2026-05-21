<?php
class HomeController {
    public function index() {
        $pdo = Database::pdo();
        $stats = [
            'alumnos'      => (int)$pdo->query("SELECT COUNT(*) FROM alumno")->fetchColumn(),
            'profesores'   => (int)$pdo->query("SELECT COUNT(*) FROM profesor")->fetchColumn(),
            'materias'     => (int)$pdo->query("SELECT COUNT(*) FROM materia")->fetchColumn(),
            'grupos'       => (int)$pdo->query("SELECT COUNT(*) FROM grupo")->fetchColumn(),
            'aulas'        => (int)$pdo->query("SELECT COUNT(*) FROM aula")->fetchColumn(),
            'inscripciones'=> (int)$pdo->query("SELECT COUNT(*) FROM inscripcion WHERE estatus='activa'")->fetchColumn(),
        ];
        render('home', ['title' => 'Inicio', 'stats' => $stats]);
    }
}
