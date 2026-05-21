<div class="card">
    <h1 class="page-title"><?= $a ? 'Editar' : 'Nueva' ?> aula</h1>
    <form class="crud" method="post" action="/?r=aula&accion=guardar">
        <input type="hidden" name="id_aula" value="<?= e($a['id_aula'] ?? '') ?>">
        <div><label class="required">Clave (ej. A8120)</label>
            <input name="clave_aula" required value="<?= e($a['clave_aula'] ?? '') ?>"></div>
        <div><label class="required">Edificio (ej. A8)</label>
            <input name="edificio" required value="<?= e($a['edificio'] ?? '') ?>"></div>
        <div><label>Capacidad</label>
            <input name="capacidad" type="number" value="<?= e($a['capacidad'] ?? 40) ?>"></div>
        <div class="actions">
            <button type="submit" class="btn btn-primary">Guardar</button>
            <a class="btn btn-secondary" href="/?r=aula">Cancelar</a>
        </div>
    </form>
</div>
