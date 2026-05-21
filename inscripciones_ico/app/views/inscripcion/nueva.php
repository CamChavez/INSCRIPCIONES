<div class="card">
    <h1 class="page-title">Inscribir materias</h1>
    <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(220px,1fr)); gap:.5rem 2rem; font-size:.92rem; margin-top:.5rem;">
        <div><strong>Matricula:</strong> <?= e($alumno['matricula']) ?></div>
        <div><strong>Alumno:</strong> <?= e($alumno['ap_paterno'].' '.$alumno['ap_materno'].' '.$alumno['nombre']) ?></div>
        <div><strong>Carrera:</strong> <?= e($alumno['nombre_carrera']) ?></div>
        <div><strong>Semestre actual:</strong> <?= e($alumno['semestre']) ?>°</div>
    </div>
</div>

<form id="form-inscripcion" method="post" action="/?r=inscripcion&accion=guardar">
    <input type="hidden" name="id_alumno" value="<?= e($alumno['id_alumno']) ?>">

    <div class="card" style="position:sticky; top:0; z-index:5;">
        <div style="display:flex; gap:1.5rem; align-items:center; justify-content:space-between; flex-wrap:wrap;">
            <div>
                <strong>Materias seleccionadas:</strong> <span id="total-materias">0</span> &nbsp;|&nbsp;
                <strong>Total de creditos:</strong> <span id="total-creditos">0</span>
            </div>
            <div>
                <button type="submit" class="btn btn-success">Confirmar inscripcion</button>
                <a class="btn btn-secondary" href="/?r=inscripcion">Cancelar</a>
            </div>
        </div>
    </div>

    <?php
    $por_sem = [1=>[], 2=>[], 3=>[]];
    foreach ($grupos as $g) { $por_sem[$g['semestre']][] = $g; }
    ?>

    <?php foreach ([1,2,3] as $sem): ?>
    <div class="card">
        <h2 class="page-title" style="font-size:1.15rem;"><?= $sem ?>° Semestre</h2>
        <div class="grupos-grid">
            <?php foreach ($por_sem[$sem] as $g): ?>
            <label class="grupo-card" data-creditos="<?= $g['creditos'] ?>">
                <input type="checkbox" name="grupos[]" value="<?= $g['id_grupo'] ?>" style="display:none">
                <div class="cve">Grupo <?= e($g['clave_grupo']) ?> · <?= e($g['turno']) ?></div>
                <div class="mat"><?= e($g['materia']) ?></div>
                <div class="info">
                    Clave <?= e($g['clave_materia']) ?> · <?= e($g['creditos']) ?> creditos · <?= e($g['tipo']) ?>
                </div>
                <div class="info">Prof. <?= e($g['profesor']) ?></div>
                <div class="info">Aula: <strong><?= e($g['clave_aula']) ?></strong> · Cupo: <?= $g['inscritos'] ?>/<?= $g['cupo'] ?></div>
                <div class="horario">
                    <?php foreach ($g['horarios'] as $h): ?>
                    <?= substr($h['dia_semana'],0,3) ?> <?= substr($h['hora_inicio'],0,5) ?>-<?= substr($h['hora_fin'],0,5) ?><br>
                    <?php endforeach; ?>
                </div>
            </label>
            <?php endforeach; ?>
            <?php if (empty($por_sem[$sem])): ?>
            <p style="color:#5a6878;">Sin grupos cargados para este semestre.</p>
            <?php endif; ?>
        </div>
    </div>
    <?php endforeach; ?>
</form>
