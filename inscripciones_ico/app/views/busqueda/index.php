<div class="card">
    <h1 class="page-title">Busqueda global</h1>
    <p class="page-subtitle">Busca a traves de todas las tablas: alumno, profesor, materia, aula, grupo o inscripcion.</p>

    <form class="search-box" method="get" style="margin-bottom:1rem;">
        <input type="hidden" name="r" value="busqueda">
        <input type="text" name="q" value="<?= e($q) ?>" placeholder="Escribe lo que buscas..." style="min-width:280px;">
        <select name="tipo">
            <option value="todos"        <?= $tipo=='todos'?'selected':'' ?>>Todas las entidades</option>
            <option value="alumno"       <?= $tipo=='alumno'?'selected':'' ?>>Alumno</option>
            <option value="profesor"     <?= $tipo=='profesor'?'selected':'' ?>>Profesor</option>
            <option value="materia"      <?= $tipo=='materia'?'selected':'' ?>>Materia</option>
            <option value="aula"         <?= $tipo=='aula'?'selected':'' ?>>Aula</option>
            <option value="grupo"        <?= $tipo=='grupo'?'selected':'' ?>>Grupo</option>
            <option value="inscripcion"  <?= $tipo=='inscripcion'?'selected':'' ?>>Inscripcion</option>
        </select>
        <button class="btn btn-primary" type="submit">Buscar</button>
    </form>

    <?php if ($q !== ''): ?>
    <p style="color:#5a6878; margin-bottom:.6rem;"><?= count($resultados) ?> resultado(s) para "<strong><?= e($q) ?></strong>"</p>
    <table class="data">
        <thead><tr><th>Entidad</th><th>Detalle</th><th>Accion</th></tr></thead>
        <tbody>
        <?php foreach($resultados as $r): ?>
        <tr>
            <td><strong><?= e($r['entidad']) ?></strong></td>
            <td><?= e($r['detalle']) ?></td>
            <td><a class="btn btn-primary btn-sm" href="<?= e($r['url']) ?>&id=<?= e($r['id']) ?>">Abrir</a></td>
        </tr>
        <?php endforeach; ?>
        <?php if (empty($resultados)): ?>
        <tr><td colspan="3" style="text-align:center; padding:1.5rem; color:#5a6878;">Sin resultados</td></tr>
        <?php endif; ?>
        </tbody>
    </table>
    <?php endif; ?>
</div>
