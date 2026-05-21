<div class="card">
    <h1 class="page-title">Profesores</h1>
    <div class="toolbar">
        <form class="search-box" method="get">
            <input type="hidden" name="r" value="profesor">
            <input type="text" name="q" value="<?= e($q) ?>" placeholder="Buscar por nombre, apellido o correo...">
            <button class="btn btn-primary btn-sm" type="submit">Buscar</button>
            <a class="btn btn-secondary btn-sm" href="/?r=profesor">Limpiar</a>
        </form>
        <a class="btn btn-success" href="/?r=profesor&accion=crear">+ Nuevo profesor</a>
    </div>
    <table class="data">
        <thead><tr><th>ID</th><th>Nombre completo</th><th>Correo</th><th>Acciones</th></tr></thead>
        <tbody>
        <?php foreach ($profesores as $p): ?>
        <tr>
            <td><?= e($p['id_profesor']) ?></td>
            <td><?= e($p['ap_paterno'].' '.$p['ap_materno'].' '.$p['nombre']) ?></td>
            <td><?= e($p['correo']) ?></td>
            <td class="actions">
                <a class="btn btn-warning btn-sm" href="/?r=profesor&accion=editar&id=<?= $p['id_profesor'] ?>">Editar</a>
                <form method="post" action="/?r=profesor&accion=borrar&id=<?= $p['id_profesor'] ?>" data-confirm="Eliminar profesor?" style="display:inline">
                    <button class="btn btn-danger btn-sm" type="submit">Borrar</button>
                </form>
            </td>
        </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</div>
