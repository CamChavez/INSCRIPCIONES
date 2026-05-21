<div class="card">
    <h1 class="page-title"><?= $c ? 'Editar' : 'Nueva' ?> carrera</h1>
    <form class="crud" method="post" action="/?r=carrera&accion=guardar">
        <input type="hidden" name="id_carrera" value="<?= e($c['id_carrera'] ?? '') ?>">
        <div><label class="required">Clave</label>
            <input name="clave_carrera" type="number" required value="<?= e($c['clave_carrera'] ?? '') ?>"></div>
        <div><label class="required">Nombre</label>
            <input name="nombre_carrera" required value="<?= e($c['nombre_carrera'] ?? '') ?>"></div>
        <div><label>Modalidad</label>
            <input name="modalidad" value="<?= e($c['modalidad'] ?? 'Escolarizado') ?>"></div>
        <div><label>Duracion (semestres)</label>
            <input name="duracion_sem" type="number" value="<?= e($c['duracion_sem'] ?? 9) ?>"></div>
        <div><label>Creditos obligatorios</label>
            <input name="creditos_obligatorios" type="number" value="<?= e($c['creditos_obligatorios'] ?? 0) ?>"></div>
        <div><label>Creditos optativos</label>
            <input name="creditos_optativos" type="number" value="<?= e($c['creditos_optativos'] ?? 0) ?>"></div>
        <div><label>Plan de estudios</label>
            <input name="plan_estudios" type="number" value="<?= e($c['plan_estudios'] ?? 2016) ?>"></div>
        <div class="actions">
            <button type="submit" class="btn btn-primary">Guardar</button>
            <a class="btn btn-secondary" href="/?r=carrera">Cancelar</a>
        </div>
    </form>
</div>
