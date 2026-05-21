<div class="card">
    <h1 class="page-title"><?= $prof ? 'Editar' : 'Nuevo' ?> profesor</h1>
    <form class="crud" method="post" action="/?r=profesor&accion=guardar">
        <input type="hidden" name="id_profesor" value="<?= e($prof['id_profesor'] ?? '') ?>">
        <div><label class="required">Nombre(s)</label>
            <input name="nombre" required value="<?= e($prof['nombre'] ?? '') ?>"></div>
        <div><label class="required">Apellido paterno</label>
            <input name="ap_paterno" required value="<?= e($prof['ap_paterno'] ?? '') ?>"></div>
        <div><label>Apellido materno</label>
            <input name="ap_materno" value="<?= e($prof['ap_materno'] ?? '') ?>"></div>
        <div><label class="required">Correo institucional</label>
            <input name="correo" type="email" required value="<?= e($prof['correo'] ?? '') ?>"></div>
        <div class="actions">
            <button type="submit" class="btn btn-primary">Guardar</button>
            <a class="btn btn-secondary" href="/?r=profesor">Cancelar</a>
        </div>
    </form>
</div>
