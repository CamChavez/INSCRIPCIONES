<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= e($title ?? 'Inscripciones ICO') ?> | FES Aragon</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
<header class="navbar no-print">
    <div class="navbar-inner">
        <div class="brand">
            Inscripciones ICO
            <small>Ingenieria en Computacion - FES Aragon UNAM | Equipo 13</small>
        </div>
        <nav class="nav-links">
            <a href="/?r=home">Inicio</a>
            <a href="/?r=alumno">Alumnos</a>
            <a href="/?r=profesor">Profesores</a>
            <a href="/?r=materia">Materias</a>
            <a href="/?r=aula">Aulas</a>
            <a href="/?r=grupo">Grupos</a>
            <a href="/?r=horario">Horarios</a>
            <a href="/?r=area">Areas</a>
            <a href="/?r=carrera">Carreras</a>
            <a href="/?r=inscripcion">Inscripciones</a>
            <a href="/?r=busqueda">Buscar</a>
        </nav>
    </div>
</header>
<main class="container">
    <?= flash_render() ?>
    <?= $content ?>
</main>
<script src="/js/app.js"></script>
</body>
</html>
