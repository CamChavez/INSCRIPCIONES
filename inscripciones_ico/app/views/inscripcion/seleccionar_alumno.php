<div class="card">
    <h1 class="page-title">Selecciona el alumno a inscribir</h1>
    <p class="page-subtitle">Solo se inscriben materias de 1° a 3° semestre.</p>
    <div class="toolbar">
        <input class="search-live" data-target="#tbl-sel" placeholder="Buscar por matricula o nombre...">
    </div>
    <table class="data" id="tbl-sel">
        <thead><tr><th>Matricula</th><th>Nombre</th><th>Semestre actual</th><th>Accion</th></tr></thead>
        <tbody>
        <?php foreach($alumnos as $a): ?>
        <tr>
            <td><?= e($a['matricula']) ?></td>
            <td><?= e($a['ap_paterno'].' '.$a['ap_materno'].' '.$a['nombre']) ?></td>
            <td><?= e($a['semestre']) ?>°</td>
            <td><a class="btn btn-success btn-sm" href="/?r=inscripcion&accion=nueva&id_alumno=<?= $a['id_alumno'] ?>">Inscribir</a></td>
        </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</div>
