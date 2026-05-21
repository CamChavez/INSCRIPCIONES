<div class="card">
    <h1 class="page-title">Grupos / Oferta academica</h1>
    <div class="toolbar">
        <form class="search-box" method="get">
            <input type="hidden" name="r" value="grupo">
            <input type="text" name="q" value="<?= e($q) ?>" placeholder="Clave grupo, materia, profesor o aula...">
            <select name="sem">
                <option value="">Todos los semestres</option>
                <?php for($i=1;$i<=9;$i++): ?><option value="<?= $i ?>" <?= $sem==$i?'selected':'' ?>><?= $i ?>°</option><?php endfor; ?>
            </select>
            <select name="turno">
                <option value="">Ambos turnos</option>
                <option value="Matutino"   <?= $turno=='Matutino'?'selected':'' ?>>Matutino</option>
                <option value="Vespertino" <?= $turno=='Vespertino'?'selected':'' ?>>Vespertino</option>
            </select>
            <button class="btn btn-primary btn-sm" type="submit">Filtrar</button>
            <a class="btn btn-secondary btn-sm" href="/?r=grupo">Limpiar</a>
        </form>
        <a class="btn btn-success" href="/?r=grupo&accion=crear">+ Nuevo grupo</a>
    </div>
    <table class="data">
        <thead><tr><th>Sem</th><th>Grupo</th><th>Materia (clave)</th><th>Profesor</th><th>Aula</th><th>Horario</th><th>Cupo</th><th>Turno</th><th>Acciones</th></tr></thead>
        <tbody>
        <?php foreach($grupos as $g): ?>
        <tr>
            <td><?= e($g['semestre']) ?>°</td>
            <td><strong><?= e($g['clave_grupo']) ?></strong></td>
            <td><?= e($g['materia']) ?> <small style="color:#5a6878">(<?= e($g['clave_materia']) ?>)</small></td>
            <td><?= e($g['profesor']) ?></td>
            <td><?= e($g['clave_aula']) ?></td>
            <td><small><?php foreach($g['horarios'] as $h): ?>
                <?= substr($h['dia_semana'],0,3) ?> <?= substr($h['hora_inicio'],0,5) ?>-<?= substr($h['hora_fin'],0,5) ?><br>
            <?php endforeach; ?></small></td>
            <td><?= $g['inscritos'] ?>/<?= $g['cupo'] ?></td>
            <td><?= e($g['turno']) ?></td>
            <td class="actions">
                <a class="btn btn-warning btn-sm" href="/?r=grupo&accion=editar&id=<?= $g['id_grupo'] ?>">Editar</a>
                <form method="post" action="/?r=grupo&accion=borrar&id=<?= $g['id_grupo'] ?>" data-confirm="Eliminar grupo?" style="display:inline">
                    <button class="btn btn-danger btn-sm">Borrar</button>
                </form>
            </td>
        </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</div>
