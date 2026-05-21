<div class="card">
    <h1 class="page-title">Sistema de Inscripciones ICO</h1>
    <p class="page-subtitle">FES Aragon UNAM | Equipo 13 - Chavez Ramirez, Padilla Torres, Villagomez Venegas</p>
</div>

<div class="stats">
    <div class="stat-card"><div class="num"><?= $stats['alumnos'] ?></div><div class="lbl">Alumnos</div></div>
    <div class="stat-card"><div class="num"><?= $stats['profesores'] ?></div><div class="lbl">Profesores</div></div>
    <div class="stat-card"><div class="num"><?= $stats['materias'] ?></div><div class="lbl">Materias</div></div>
    <div class="stat-card"><div class="num"><?= $stats['grupos'] ?></div><div class="lbl">Grupos</div></div>
    <div class="stat-card"><div class="num"><?= $stats['aulas'] ?></div><div class="lbl">Aulas</div></div>
    <div class="stat-card"><div class="num"><?= $stats['inscripciones'] ?></div><div class="lbl">Inscripciones activas</div></div>
</div>

<div class="card">
    <h2 class="page-title">Acciones rapidas</h2>
    <p class="page-subtitle">Usa el menu superior para gestionar cada tabla, o ve directo a:</p>
    <div style="display:flex; gap:.6rem; flex-wrap:wrap; margin-top:1rem;">
        <a class="btn btn-success" href="/?r=inscripcion&accion=nueva">+ Nueva inscripcion</a>
        <a class="btn btn-primary" href="/?r=alumno">Ver alumnos</a>
        <a class="btn btn-primary" href="/?r=grupo">Ver oferta academica</a>
        <a class="btn btn-secondary" href="/?r=busqueda">Buscar</a>
    </div>
</div>

<div class="card">
    <h3 style="color:#003366; margin-bottom:.5rem;">Alcance del sistema</h3>
    <p style="color:#5a6878; font-size:.93rem; line-height:1.6;">
        Sistema CRUD que permite inscribir alumnos de Ingenieria en Computacion en asignaturas
        de <strong>1°, 2° y 3° semestre</strong> (datos capturados por el grupo 2808 matutino).
        Valida empalmes de horario, cupo disponible y duplicados. Genera comprobante imprimible
        con folio, lista de materias inscritas, profesor, aula, horario y total de creditos.
    </p>
</div>
