<div class="card">
    <h1 class="page-title">Inscripciones</h1>
    <div class="toolbar">
        <input class="search-live" data-target="#tbl-insc" placeholder="Buscar por folio, matricula o nombre...">
        <a class="btn btn-success" href="/?r=inscripcion&accion=nueva">+ Nueva inscripcion</a>
    </div>
    <table class="data" id="tbl-insc">
        <thead><tr><th>Folio</th><th>Matricula</th><th>Alumno</th><th>Materias</th><th>Creditos</th><th>Fecha</th><th>Estatus</th><th>Acciones</th></tr></thead>
        <tbody>
        <?php foreach($inscripciones as $i): ?>
        <tr>
            <td><strong><?= e($i['folio']) ?></strong></td>
            <td><?= e($i['matricula']) ?></td>
            <td><?= e($i['ap_paterno'].' '.$i['ap_materno'].' '.$i['nombre']) ?></td>
            <td><?= e($i['num_materias']) ?></td>
            <td><?= e($i['total_creditos']) ?></td>
            <td><?= e($i['fecha_inscripcion']) ?></td>
            <td><span class="badge <?= $i['estatus']=='activa'?'badge-act':'badge-inact' ?>"><?= e($i['estatus']) ?></span></td>
            <td class="actions">
                <a class="btn btn-primary btn-sm" href="/?r=comprobante&accion=ver&id=<?= $i['id_inscripcion'] ?>">Comprobante</a>
                <?php if ($i['estatus']=='activa'): ?>
                <form method="post" action="/?r=inscripcion&accion=cancelar&id=<?= $i['id_inscripcion'] ?>" data-confirm="Cancelar inscripcion?" style="display:inline">
                    <button class="btn btn-danger btn-sm">Cancelar</button>
                </form>
                <?php endif; ?>
            </td>
        </tr>
        <?php endforeach; ?>
        <?php if (empty($inscripciones)): ?>
        <tr><td colspan="8" style="text-align:center; padding:2rem; color:#5a6878;">No hay inscripciones registradas. <a href="/?r=inscripcion&accion=nueva">Crear la primera</a>.</td></tr>
        <?php endif; ?>
        </tbody>
    </table>
</div>
