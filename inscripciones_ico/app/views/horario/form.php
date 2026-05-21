<div class="card">
    <h1 class="page-title"><?= $b ? 'Editar' : 'Nuevo' ?> bloque de horario</h1>
    <form class="crud" method="post" action="/?r=horario&accion=guardar">
        <input type="hidden" name="id_horario" value="<?= e($b['id_horario'] ?? '') ?>">
        <div><label class="required">Dia</label>
            <select name="dia_semana" required>
                <?php foreach(['Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'] as $d): ?>
                <option value="<?= $d ?>" <?= ($b['dia_semana']??'')==$d?'selected':'' ?>><?= $d ?></option>
                <?php endforeach; ?>
            </select></div>
        <div></div>
        <div><label class="required">Hora inicio</label>
            <input name="hora_inicio" type="time" required value="<?= e(substr($b['hora_inicio'] ?? '07:00:00',0,5)) ?>"></div>
        <div><label class="required">Hora fin</label>
            <input name="hora_fin" type="time" required value="<?= e(substr($b['hora_fin'] ?? '09:00:00',0,5)) ?>"></div>
        <div class="actions">
            <button type="submit" class="btn btn-primary">Guardar</button>
            <a class="btn btn-secondary" href="/?r=horario">Cancelar</a>
        </div>
    </form>
</div>
