<div class="card">
    <h1 class="page-title"><?= $g ? 'Editar' : 'Nuevo' ?> grupo</h1>
    <form class="crud" method="post" action="/?r=grupo&accion=guardar">
        <input type="hidden" name="id_grupo" value="<?= e($g['id_grupo'] ?? '') ?>">
        <div><label class="required">Clave de grupo</label>
            <input name="clave_grupo" type="number" required value="<?= e($g['clave_grupo'] ?? '') ?>"></div>
        <div><label class="required">Materia</label>
            <select name="id_materia" required>
                <?php foreach($materias as $m): ?>
                <option value="<?= $m['id_materia'] ?>" <?= ($g['id_materia']??0)==$m['id_materia']?'selected':'' ?>>
                    <?= e($m['semestre']) ?>° - <?= e($m['nombre']) ?> (<?= e($m['clave_materia']) ?>)
                </option>
                <?php endforeach; ?>
            </select></div>
        <div><label class="required">Profesor</label>
            <select name="id_profesor" required>
                <?php foreach($profesores as $p): ?>
                <option value="<?= $p['id_profesor'] ?>" <?= ($g['id_profesor']??0)==$p['id_profesor']?'selected':'' ?>>
                    <?= e($p['ap_paterno'].' '.$p['ap_materno'].' '.$p['nombre']) ?>
                </option>
                <?php endforeach; ?>
            </select></div>
        <div><label class="required">Aula</label>
            <select name="id_aula" required>
                <?php foreach($aulas as $a): ?>
                <option value="<?= $a['id_aula'] ?>" <?= ($g['id_aula']??0)==$a['id_aula']?'selected':'' ?>><?= e($a['clave_aula']) ?></option>
                <?php endforeach; ?>
            </select></div>
        <div><label>Turno</label>
            <select name="turno">
                <option value="Matutino"   <?= ($g['turno']??'')=='Matutino'?'selected':'' ?>>Matutino</option>
                <option value="Vespertino" <?= ($g['turno']??'')=='Vespertino'?'selected':'' ?>>Vespertino</option>
            </select></div>
        <div><label>Modalidad</label>
            <select name="modalidad">
                <option value="Presencial" <?= ($g['modalidad']??'')=='Presencial'?'selected':'' ?>>Presencial</option>
                <option value="En linea"   <?= ($g['modalidad']??'')=='En linea'?'selected':'' ?>>En linea</option>
            </select></div>
        <div><label>Cupo</label>
            <input name="cupo" type="number" value="<?= e($g['cupo'] ?? 30) ?>"></div>
        <div></div>
        <div class="full"><label>Bloques de horario (selecciona los que aplican)</label>
            <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(180px,1fr)); gap:.4rem; max-height:240px; overflow-y:auto; border:1px solid #cdd5df; padding:.6rem; border-radius:6px;">
                <?php foreach($bloques as $b): ?>
                <label style="font-weight:400; font-size:.85rem;">
                    <input type="checkbox" name="bloques[]" value="<?= $b['id_horario'] ?>" <?= in_array($b['id_horario'],$bloques_seleccionados)?'checked':'' ?>>
                    <?= e($b['dia_semana']) ?> <?= substr($b['hora_inicio'],0,5) ?>-<?= substr($b['hora_fin'],0,5) ?>
                </label>
                <?php endforeach; ?>
            </div>
        </div>
        <div class="actions">
            <button type="submit" class="btn btn-primary">Guardar</button>
            <a class="btn btn-secondary" href="/?r=grupo">Cancelar</a>
        </div>
    </form>
</div>
