<?php
class ComprobanteController {
    public function ver() {
        $pdo = Database::pdo();
        $id = get_int('id');
        $st = $pdo->prepare("
            SELECT i.*, a.matricula, a.nombre, a.ap_paterno, a.ap_materno, a.correo, a.semestre, a.turno,
                   c.nombre_carrera, c.clave_carrera, c.plan_estudios
            FROM inscripcion i
            JOIN alumno a   ON a.id_alumno  = i.id_alumno
            JOIN carrera c  ON c.id_carrera = a.id_carrera
            WHERE i.id_inscripcion = ?
        ");
        $st->execute([$id]); $insc = $st->fetch();
        if (!$insc) { flash('Inscripcion no encontrada','error'); redirect('/?r=inscripcion'); }

        $det = $pdo->prepare("
            SELECT g.clave_grupo, m.clave_materia, m.nombre AS materia, m.creditos, m.tipo,
                   ae.nombre_area AS area,
                   CONCAT(p.nombre,' ',p.ap_paterno,' ',p.ap_materno) AS profesor,
                   a.clave_aula, g.id_grupo
            FROM inscripcion_detalle d
            JOIN grupo g         ON g.id_grupo     = d.id_grupo
            JOIN materia m       ON m.id_materia   = g.id_materia
            JOIN area_estudio ae ON ae.id_area     = m.id_area
            JOIN profesor p      ON p.id_profesor  = g.id_profesor
            JOIN aula a          ON a.id_aula      = g.id_aula
            WHERE d.id_inscripcion = ?
            ORDER BY m.semestre, m.nombre
        ");
        $det->execute([$id]); $materias = $det->fetchAll();

        $hs = $pdo->prepare("SELECT hb.* FROM grupo_horario gh JOIN horario_bloque hb ON hb.id_horario=gh.id_horario WHERE gh.id_grupo=? ORDER BY FIELD(hb.dia_semana,'Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'), hb.hora_inicio");
        foreach ($materias as &$m) {
            $hs->execute([$m['id_grupo']]);
            $m['horarios'] = $hs->fetchAll();
        }
        render('inscripcion/comprobante', ['title'=>'Comprobante '.$insc['folio'],'insc'=>$insc,'materias'=>$materias]);
    }
}
