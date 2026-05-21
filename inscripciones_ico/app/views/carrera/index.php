<div class="card">
    <h1 class="page-title">Carreras</h1>
    <div class="toolbar">
        <span></span>
        <a class="btn btn-success" href="/?r=carrera&accion=crear">+ Nueva carrera</a>
    </div>
    <table class="data">
        <thead><tr><th>Clave</th><th>Nombre</th><th>Modalidad</th><th>Dur.</th><th>Cr. Oblig.</th><th>Cr. Opt.</th><th>Plan</th><th>Acciones</th></tr></thead>
        <tbody>
        <?php foreach($carreras as $c): ?>
        <tr>
            <td><?= e($c['clave_carrera']) ?></td>
            <td><strong><?= e($c['nombre_carrera']) ?></strong></td>
            <td><?= e($c['modalidad']) ?></td>
            <td><?= e($c['duracion_sem']) ?> sem</td>
            <td><?= e($c['creditos_obligatorios']) ?></td>
            <td><?= e($c['creditos_optativos']) ?></td>
            <td><?= e($c['plan_estudios']) ?></td>
            <td class="actions">
                <a class="btn btn-warning btn-sm" href="/?r=carrera&accion=editar&id=<?= $c['id_carrera'] ?>">Editar</a>
                <form method="post" action="/?r=carrera&accion=borrar&id=<?= $c['id_carrera'] ?>" data-confirm="Eliminar carrera?" style="display:inline">
                    <button class="btn btn-danger btn-sm">Borrar</button>
                </form>
            </td>
        </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</div>
