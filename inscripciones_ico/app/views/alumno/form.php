<div class="card">
    <h1 class="page-title"><?= $alumno ? 'Editar' : 'Nuevo' ?> alumno</h1>

    <form class="crud" method="post" action="/?r=alumno&accion=guardar">
        <input type="hidden" name="id_alumno" value="<?= e($alumno['id_alumno'] ?? '') ?>">

        <div><label class="required">Matricula</label>
            <input name="matricula" type="number" required value="<?= e($alumno['matricula'] ?? '') ?>"></div>
        <div><label class="required">Correo institucional</label>
            <input name="correo" type="email" required value="<?= e($alumno['correo'] ?? '') ?>"></div>

        <div><label class="required">Nombre(s)</label>
            <input name="nombre" required value="<?= e($alumno['nombre'] ?? '') ?>"></div>
        <div><label class="required">Apellido paterno</label>
            <input name="ap_paterno" required value="<?= e($alumno['ap_paterno'] ?? '') ?>"></div>
        <div><label>Apellido materno</label>
            <input name="ap_materno" value="<?= e($alumno['ap_materno'] ?? '') ?>"></div>
        <div><label class="required">Fecha de nacimiento</label>
            <input name="fecha_nacimiento" type="date" required value="<?= e($alumno['fecha_nacimiento'] ?? '2004-01-01') ?>"></div>

        <div><label class="required">Generacion</label>
            <input name="generacion" type="number" required value="<?= e($alumno['generacion'] ?? date('Y')) ?>"></div>
        <div><label class="required">Semestre</label>
            <select name="semestre" required>
                <?php for ($i=1;$i<=9;$i++): ?>
                <option value="<?= $i ?>" <?= ($alumno['semestre'] ?? 1) == $i ? 'selected':'' ?>><?= $i ?>° semestre</option>
                <?php endfor; ?>
            </select></div>

        <div><label>Turno</label>
            <select name="turno">
                <option value="Matutino"   <?= ($alumno['turno'] ?? '')=='Matutino'?'selected':'' ?>>Matutino</option>
                <option value="Vespertino" <?= ($alumno['turno'] ?? '')=='Vespertino'?'selected':'' ?>>Vespertino</option>
            </select></div>
        <div><label>Sistema</label>
            <select name="sistema">
                <option value="Escolarizado" <?= ($alumno['sistema'] ?? '')=='Escolarizado'?'selected':'' ?>>Escolarizado</option>
                <option value="Abierto"      <?= ($alumno['sistema'] ?? '')=='Abierto'?'selected':'' ?>>Abierto</option>
            </select></div>

        <div><label>Estado</label>
            <select name="estado">
                <option value="Activo"   <?= ($alumno['estado'] ?? '')=='Activo'?'selected':'' ?>>Activo</option>
                <option value="Inactivo" <?= ($alumno['estado'] ?? '')=='Inactivo'?'selected':'' ?>>Inactivo</option>
            </select></div>
        <div><label>Estatus de pago</label>
            <select name="estatus_pago">
                <option value="1" <?= ($alumno['estatus_pago'] ?? 1)==1?'selected':'' ?>>Pagado</option>
                <option value="0" <?= ($alumno['estatus_pago'] ?? 1)==0?'selected':'' ?>>Pendiente</option>
            </select></div>

        <div><label>Promedio</label>
            <input name="promedio" type="number" step="0.01" min="0" max="10" value="<?= e($alumno['promedio'] ?? '0.00') ?>"></div>
        <div><label class="required">Carrera</label>
            <select name="id_carrera" required>
                <?php foreach ($carreras as $c): ?>
                <option value="<?= $c['id_carrera'] ?>" <?= ($alumno['id_carrera'] ?? 1)==$c['id_carrera']?'selected':'' ?>><?= e($c['nombre_carrera']) ?></option>
                <?php endforeach; ?>
            </select></div>

        <div class="actions">
            <button type="submit" class="btn btn-primary">Guardar</button>
            <a class="btn btn-secondary" href="/?r=alumno">Cancelar</a>
        </div>
    </form>
</div>
