<div class="card">
    <h1 class="page-title">Areas de estudio</h1>
    <p class="page-subtitle">Clasifica las asignaturas (Ciencias Basicas, Sistemas Computacionales, etc.)</p>
    <div class="toolbar">
        <span></span>
        <a class="btn btn-success" href="/?r=area&accion=crear">+ Nueva area</a>
    </div>
    <table class="data">
        <thead><tr><th>ID</th><th>Nombre</th><th>Descripcion</th><th>Acciones</th></tr></thead>
        <tbody>
        <?php foreach($areas as $a): ?>
        <tr>
            <td><?= e($a['id_area']) ?></td>
            <td><strong><?= e($a['nombre_area']) ?></strong></td>
            <td><?= e($a['descripcion']) ?></td>
            <td class="actions">
                <a class="btn btn-warning btn-sm" href="/?r=area&accion=editar&id=<?= $a['id_area'] ?>">Editar</a>
                <form method="post" action="/?r=area&accion=borrar&id=<?= $a['id_area'] ?>" data-confirm="Eliminar area?" style="display:inline">
                    <button class="btn btn-danger btn-sm">Borrar</button>
                </form>
            </td>
        </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</div>
