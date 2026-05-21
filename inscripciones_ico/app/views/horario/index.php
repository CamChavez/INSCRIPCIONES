<div class="card">
    <h1 class="page-title">Bloques de horario</h1>
    <p class="page-subtitle">Cada bloque representa un dia + hora inicio + hora fin. Los grupos se arman combinando varios bloques.</p>
    <div class="toolbar">
        <input type="text" class="search-live" data-target="#tbl-horario" placeholder="Buscar al vuelo...">
        <a class="btn btn-success" href="/?r=horario&accion=crear">+ Nuevo bloque</a>
    </div>
    <table class="data" id="tbl-horario">
        <thead><tr><th>ID</th><th>Dia</th><th>Hora inicio</th><th>Hora fin</th><th>Acciones</th></tr></thead>
        <tbody>
        <?php foreach($bloques as $b): ?>
        <tr>
            <td><?= e($b['id_horario']) ?></td>
            <td><?= e($b['dia_semana']) ?></td>
            <td><?= substr($b['hora_inicio'],0,5) ?></td>
            <td><?= substr($b['hora_fin'],0,5) ?></td>
            <td class="actions">
                <a class="btn btn-warning btn-sm" href="/?r=horario&accion=editar&id=<?= $b['id_horario'] ?>">Editar</a>
                <form method="post" action="/?r=horario&accion=borrar&id=<?= $b['id_horario'] ?>" data-confirm="Eliminar bloque?" style="display:inline">
                    <button class="btn btn-danger btn-sm">Borrar</button>
                </form>
            </td>
        </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</div>
