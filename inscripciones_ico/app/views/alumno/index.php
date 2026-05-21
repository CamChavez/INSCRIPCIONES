<div class="card">
    <h1 class="page-title">Alumnos</h1>
    <p class="page-subtitle">CRUD y busqueda por matricula, nombre, apellido, correo o semestre</p>

    <div class="toolbar">
        <form class="search-box" method="get">
            <input type="hidden" name="r" value="alumno">
            <input type="text" name="q" value="<?= e($q) ?>" placeholder="Buscar por nombre, apellido, matricula o correo...">
            <select name="sem">
                <option value="">Todos los semestres</option>
                <?php for ($i=1;$i<=9;$i++): ?>
                <option value="<?= $i ?>" <?= $sem == $i ? 'selected':'' ?>><?= $i ?>° sem</option>
                <?php endfor; ?>
            </select>
            <button class="btn btn-primary btn-sm" type="submit">Filtrar</button>
            <a class="btn btn-secondary btn-sm" href="/?r=alumno">Limpiar</a>
        </form>
        <a class="btn btn-success" href="/?r=alumno&accion=crear">+ Nuevo alumno</a>
    </div>

    <table class="data">
        <thead><tr>
            <th>Matricula</th><th>Nombre completo</th><th>Correo</th><th>Sem</th><th>Turno</th><th>Promedio</th><th>Estado</th><th>Acciones</th>
        </tr></thead>
        <tbody>
        <?php foreach ($alumnos as $a): ?>
        <tr>
            <td><?= e($a['matricula']) ?></td>
            <td><?= e($a['ap_paterno'].' '.$a['ap_materno'].' '.$a['nombre']) ?></td>
            <td><?= e($a['correo']) ?></td>
            <td><?= e($a['semestre']) ?>°</td>
            <td><?= e($a['turno']) ?></td>
            <td><?= number_format($a['promedio'],2) ?></td>
            <td><span class="badge <?= $a['estado']=='Activo'?'badge-act':'badge-inact' ?>"><?= e($a['estado']) ?></span></td>
            <td class="actions">
                <a class="btn btn-warning btn-sm" href="/?r=alumno&accion=editar&id=<?= $a['id_alumno'] ?>">Editar</a>
                <a class="btn btn-success btn-sm" href="/?r=inscripcion&accion=nueva&id_alumno=<?= $a['id_alumno'] ?>">Inscribir</a>
                <form method="post" action="/?r=alumno&accion=borrar&id=<?= $a['id_alumno'] ?>" data-confirm="Eliminar a este alumno?" style="display:inline">
                    <button class="btn btn-danger btn-sm" type="submit">Borrar</button>
                </form>
            </td>
        </tr>
        <?php endforeach; ?>
        <?php if (empty($alumnos)): ?>
        <tr><td colspan="8" style="text-align:center; padding:2rem; color:#5a6878;">No hay alumnos que coincidan.</td></tr>
        <?php endif; ?>
        </tbody>
    </table>
</div>
