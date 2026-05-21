<div class="card">
    <h1 class="page-title">Aulas</h1>
    <div class="toolbar">
        <form class="search-box" method="get">
            <input type="hidden" name="r" value="aula">
            <input type="text" name="q" value="<?= e($q) ?>" placeholder="Clave o edificio...">
            <button class="btn btn-primary btn-sm" type="submit">Buscar</button>
            <a class="btn btn-secondary btn-sm" href="/?r=aula">Limpiar</a>
        </form>
        <a class="btn btn-success" href="/?r=aula&accion=crear">+ Nueva aula</a>
    </div>
    <table class="data">
        <thead><tr><th>Clave</th><th>Edificio</th><th>Capacidad</th><th>Acciones</th></tr></thead>
        <tbody>
        <?php foreach($aulas as $a): ?>
        <tr>
            <td><?= e($a['clave_aula']) ?></td>
            <td><?= e($a['edificio']) ?></td>
            <td><?= e($a['capacidad']) ?></td>
            <td class="actions">
                <a class="btn btn-warning btn-sm" href="/?r=aula&accion=editar&id=<?= $a['id_aula'] ?>">Editar</a>
                <form method="post" action="/?r=aula&accion=borrar&id=<?= $a['id_aula'] ?>" data-confirm="Eliminar aula?" style="display:inline">
                    <button class="btn btn-danger btn-sm">Borrar</button>
                </form>
            </td>
        </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</div>
