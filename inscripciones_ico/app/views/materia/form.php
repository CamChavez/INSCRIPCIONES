<div class="card">
    <h1 class="page-title"><?= $m ? 'Editar' : 'Nueva' ?> materia</h1>
    <form class="crud" method="post" action="/?r=materia&accion=guardar">
        <input type="hidden" name="id_materia" value="<?= e($m['id_materia'] ?? '') ?>">
        <div><label class="required">Clave</label>
            <input name="clave_materia" type="number" required value="<?= e($m['clave_materia'] ?? '') ?>"></div>
        <div><label class="required">Nombre</label>
            <input name="nombre" required value="<?= e($m['nombre'] ?? '') ?>"></div>
        <div><label class="required">Semestre</label>
            <select name="semestre">
                <?php for($i=1;$i<=9;$i++): ?><option value="<?= $i ?>" <?= ($m['semestre']??1)==$i?'selected':'' ?>><?= $i ?>°</option><?php endfor; ?>
            </select></div>
        <div><label class="required">Creditos</label>
            <input name="creditos" type="number" required value="<?= e($m['creditos'] ?? 8) ?>"></div>
        <div><label>Tipo</label>
            <select name="tipo">
                <option value="obligatoria" <?= ($m['tipo']??'')=='obligatoria'?'selected':'' ?>>Obligatoria</option>
                <option value="optativa"    <?= ($m['tipo']??'')=='optativa'?'selected':'' ?>>Optativa</option>
            </select></div>
        <div><label>Laboratorio</label>
            <select name="laboratorio">
                <option value="0" <?= ($m['laboratorio']??0)==0?'selected':'' ?>>No</option>
                <option value="1" <?= ($m['laboratorio']??0)==1?'selected':'' ?>>Si</option>
            </select></div>
        <div><label class="required">Area de estudio</label>
            <select name="id_area">
                <?php foreach($areas as $a): ?><option value="<?= $a['id_area'] ?>" <?= ($m['id_area']??1)==$a['id_area']?'selected':'' ?>><?= e($a['nombre_area']) ?></option><?php endforeach; ?>
            </select></div>
        <div><label class="required">Carrera</label>
            <select name="id_carrera">
                <?php foreach($carreras as $c): ?><option value="<?= $c['id_carrera'] ?>" <?= ($m['id_carrera']??1)==$c['id_carrera']?'selected':'' ?>><?= e($c['nombre_carrera']) ?></option><?php endforeach; ?>
            </select></div>
        <div class="actions">
            <button type="submit" class="btn btn-primary">Guardar</button>
            <a class="btn btn-secondary" href="/?r=materia">Cancelar</a>
        </div>
    </form>
</div>
