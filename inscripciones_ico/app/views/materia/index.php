<div class="card">
    <h1 class="page-title">Materias</h1>
    <div class="toolbar">
        <form class="search-box" method="get">
            <input type="hidden" name="r" value="materia">
            <input type="text" name="q" value="<?= e($q) ?>" placeholder="Nombre o clave...">
            <select name="sem">
                <option value="">Todos los semestres</option>
                <?php for($i=1;$i<=9;$i++): ?><option value="<?= $i ?>" <?= $sem==$i?'selected':'' ?>><?= $i ?>°</option><?php endfor; ?>
            </select>
            <select name="area">
                <option value="">Todas las areas</option>
                <?php foreach($areas as $a): ?><option value="<?= $a['id_area'] ?>" <?= $area==$a['id_area']?'selected':'' ?>><?= e($a['nombre_area']) ?></option><?php endforeach; ?>
            </select>
            <button class="btn btn-primary btn-sm" type="submit">Filtrar</button>
            <a class="btn btn-secondary btn-sm" href="/?r=materia">Limpiar</a>
        </form>
        <a class="btn btn-success" href="/?r=materia&accion=crear">+ Nueva materia</a>
    </div>
    <table class="data">
        <thead><tr><th>Clave</th><th>Nombre</th><th>Sem</th><th>Creditos</th><th>Tipo</th><th>Area</th><th>Lab</th><th>Acciones</th></tr></thead>
        <tbody>
        <?php foreach ($materias as $m): ?>
        <tr>
            <td><?= e($m['clave_materia']) ?></td>
            <td><?= e($m['nombre']) ?></td>
            <td><?= e($m['semestre']) ?>°</td>
            <td><?= e($m['creditos']) ?></td>
            <td><span class="badge <?= $m['tipo']=='obligatoria'?'badge-ob':'badge-op' ?>"><?= e($m['tipo']) ?></span></td>
            <td><?= e($m['nombre_area']) ?></td>
            <td><?= $m['laboratorio']?'Si':'No' ?></td>
            <td class="actions">
                <a class="btn btn-warning btn-sm" href="/?r=materia&accion=editar&id=<?= $m['id_materia'] ?>">Editar</a>
                <form method="post" action="/?r=materia&accion=borrar&id=<?= $m['id_materia'] ?>" data-confirm="Eliminar materia?" style="display:inline">
                    <button class="btn btn-danger btn-sm" type="submit">Borrar</button>
                </form>
            </td>
        </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</div>
