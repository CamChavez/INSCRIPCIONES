<div class="no-print" style="max-width:920px; margin:.5rem auto; text-align:right;">
    <button class="btn btn-primary" onclick="window.print()">Imprimir / Guardar PDF</button>
    <a class="btn btn-secondary" href="/?r=inscripcion">Volver</a>
</div>

<div class="comprobante">
    <div class="comprobante-header">
        <h1>UNIVERSIDAD NACIONAL AUTONOMA DE MEXICO</h1>
        <h2>Facultad de Estudios Superiores Aragon - Ingenieria en Computacion</h2>
        <h2 style="margin-top:.6rem; font-size:1.15rem; color:#003366;">COMPROBANTE DE INSCRIPCION</h2>
    </div>

    <div class="info-alumno">
        <div><strong>Folio:</strong> <?= e($insc['folio']) ?></div>
        <div><strong>Fecha:</strong> <?= e($insc['fecha_inscripcion']) ?></div>
        <div><strong>Matricula:</strong> <?= e($insc['matricula']) ?></div>
        <div><strong>Correo:</strong> <?= e($insc['correo']) ?></div>
        <div style="grid-column:1/-1"><strong>Alumno(a):</strong> <?= e($insc['ap_paterno'].' '.$insc['ap_materno'].' '.$insc['nombre']) ?></div>
        <div><strong>Carrera:</strong> <?= e($insc['nombre_carrera']) ?> (<?= e($insc['clave_carrera']) ?>)</div>
        <div><strong>Plan:</strong> <?= e($insc['plan_estudios']) ?></div>
        <div><strong>Semestre actual:</strong> <?= e($insc['semestre']) ?>°</div>
        <div><strong>Turno:</strong> <?= e($insc['turno']) ?></div>
    </div>

    <h3 style="color:#003366; margin-bottom:.5rem;">Asignaturas inscritas</h3>
    <table>
        <thead><tr>
            <th>Clave</th><th>Asignatura</th><th>Area</th><th>Grupo</th><th>Profesor</th><th>Horario</th><th>Aula</th><th>Cr.</th>
        </tr></thead>
        <tbody>
        <?php foreach ($materias as $m): ?>
        <tr>
            <td><?= e($m['clave_materia']) ?></td>
            <td><?= e($m['materia']) ?></td>
            <td style="font-size:.8rem;"><?= e($m['area']) ?></td>
            <td><strong><?= e($m['clave_grupo']) ?></strong></td>
            <td style="font-size:.8rem;"><?= e($m['profesor']) ?></td>
            <td style="font-size:.78rem;">
                <?php foreach($m['horarios'] as $h): ?>
                <?= substr($h['dia_semana'],0,3) ?> <?= substr($h['hora_inicio'],0,5) ?>-<?= substr($h['hora_fin'],0,5) ?><br>
                <?php endforeach; ?>
            </td>
            <td><?= e($m['clave_aula']) ?></td>
            <td><?= e($m['creditos']) ?></td>
        </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
    <div class="totales">
        Total de asignaturas: <?= count($materias) ?> &nbsp; · &nbsp;
        Total de creditos: <?= e($insc['total_creditos']) ?>
    </div>

    <div class="firma">
        <div><div class="firma-linea">Firma del alumno</div></div>
        <div><div class="firma-linea">Sello de Servicios Escolares</div></div>
    </div>

    <p style="text-align:center; color:#5a6878; font-size:.78rem; margin-top:1.5rem;">
        Comprobante generado electronicamente el <?= date('d/m/Y H:i') ?> | Equipo 13 - Sistema de Inscripciones ICO
    </p>
</div>
