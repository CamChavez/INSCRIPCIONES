<div class="card">
    <h1 class="page-title"><?= $a ? 'Editar' : 'Nueva' ?> area de estudio</h1>
    <form class="crud" method="post" action="/?r=area&accion=guardar">
        <input type="hidden" name="id_area" value="<?= e($a['id_area'] ?? '') ?>">
        <div class="full"><label class="required">Nombre</label>
            <input name="nombre_area" required value="<?= e($a['nombre_area'] ?? '') ?>"></div>
        <div class="full"><label>Descripcion</label>
            <textarea name="descripcion" rows="3"><?= e($a['descripcion'] ?? '') ?></textarea></div>
        <div class="actions">
            <button type="submit" class="btn btn-primary">Guardar</button>
            <a class="btn btn-secondary" href="/?r=area">Cancelar</a>
        </div>
    </form>
</div>
