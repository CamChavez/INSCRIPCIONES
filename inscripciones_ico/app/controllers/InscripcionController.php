<?php
class InscripcionController {
    public function index() {
        $st = Database::pdo()->query("
            SELECT i.*, a.matricula, a.nombre, a.ap_paterno, a.ap_materno, a.semestre,
                   (SELECT COUNT(*) FROM inscripcion_detalle d WHERE d.id_inscripcion=i.id_inscripcion) AS num_materias
            FROM inscripcion i
            JOIN alumno a ON a.id_alumno = i.id_alumno
            ORDER BY i.fecha_inscripcion DESC
        ");
        render('inscripcion/index', ['title'=>'Inscripciones','inscripciones'=>$st->fetchAll()]);
    }

    public function nueva() {
        $pdo = Database::pdo();
        $id_alumno = get_int('id_alumno');
        if (!$id_alumno) {
            // Pedir seleccion de alumno
            $alumnos = $pdo->query("SELECT id_alumno, matricula, nombre, ap_paterno, ap_materno, semestre FROM alumno WHERE estado='Activo' ORDER BY ap_paterno, ap_materno, nombre")->fetchAll();
            render('inscripcion/seleccionar_alumno', ['title'=>'Seleccionar alumno','alumnos'=>$alumnos]);
            return;
        }
        $st = $pdo->prepare("SELECT a.*, c.nombre_carrera FROM alumno a JOIN carrera c ON c.id_carrera=a.id_carrera WHERE id_alumno=?");
        $st->execute([$id_alumno]); $alumno = $st->fetch();
        if (!$alumno) { flash('Alumno no encontrado','error'); redirect('/?r=alumno'); }

        // Cargar grupos de 1°-3° semestre con sus bloques
        $g = $pdo->query("
            SELECT g.*, m.clave_materia, m.nombre AS materia, m.semestre, m.creditos, m.tipo,
                   CONCAT(p.nombre,' ',p.ap_paterno,' ',p.ap_materno) AS profesor,
                   a.clave_aula
            FROM grupo g
            JOIN materia m  ON m.id_materia=g.id_materia
            JOIN profesor p ON p.id_profesor=g.id_profesor
            JOIN aula a     ON a.id_aula=g.id_aula
            WHERE m.semestre BETWEEN 1 AND 3
            ORDER BY m.semestre, g.clave_grupo, m.nombre
        ")->fetchAll();
        $hs = $pdo->prepare("SELECT hb.* FROM grupo_horario gh JOIN horario_bloque hb ON hb.id_horario=gh.id_horario WHERE gh.id_grupo=? ORDER BY FIELD(hb.dia_semana,'Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'), hb.hora_inicio");
        foreach ($g as &$row) {
            $hs->execute([$row['id_grupo']]);
            $row['horarios'] = $hs->fetchAll();
        }
        render('inscripcion/nueva', ['title'=>'Nueva inscripcion','alumno'=>$alumno,'grupos'=>$g]);
    }

    public function guardar() {
        $pdo = Database::pdo();
        $id_alumno = (int)post_str('id_alumno');
        $grupos    = $_POST['grupos'] ?? [];

        if (!$id_alumno || empty($grupos)) {
            flash('Debes seleccionar al menos una materia.','error');
            redirect('/?r=inscripcion&accion=nueva&id_alumno='.$id_alumno);
        }
        if (count($grupos) > 8) {
            flash('Maximo 8 materias por inscripcion.','error');
            redirect('/?r=inscripcion&accion=nueva&id_alumno='.$id_alumno);
        }

        // === VALIDACIONES ===
        $errores = [];
        // 1) Cargar info de los grupos
        $in = implode(',', array_fill(0, count($grupos), '?'));
        $st = $pdo->prepare("SELECT g.*, m.nombre AS materia, m.creditos, m.id_materia AS mid FROM grupo g JOIN materia m ON m.id_materia=g.id_materia WHERE g.id_grupo IN ($in)");
        $st->execute($grupos); $info = $st->fetchAll();

        // 2) Materia duplicada
        $mat_ids = array_column($info, 'mid');
        if (count($mat_ids) !== count(array_unique($mat_ids))) {
            $errores[] = "No puedes inscribir la misma materia en dos grupos distintos.";
        }
        // 3) Cupo disponible
        foreach ($info as $g) {
            if ($g['inscritos'] >= $g['cupo']) {
                $errores[] = "Grupo {$g['clave_grupo']} ({$g['materia']}) sin cupo disponible.";
            }
        }
        // 4) Empalmes de horario
        $hStmt = $pdo->prepare("SELECT hb.dia_semana, hb.hora_inicio, hb.hora_fin FROM grupo_horario gh JOIN horario_bloque hb ON hb.id_horario=gh.id_horario WHERE gh.id_grupo=?");
        $bloques_por_grupo = [];
        foreach ($grupos as $gid) {
            $hStmt->execute([(int)$gid]);
            $bloques_por_grupo[$gid] = $hStmt->fetchAll();
        }
        $g_arr = array_values($grupos);
        for ($i=0;$i<count($g_arr);$i++) {
            for ($j=$i+1;$j<count($g_arr);$j++) {
                foreach ($bloques_por_grupo[$g_arr[$i]] as $b1) {
                    foreach ($bloques_por_grupo[$g_arr[$j]] as $b2) {
                        if ($b1['dia_semana'] === $b2['dia_semana']) {
                            if ($b1['hora_inicio'] < $b2['hora_fin'] && $b2['hora_inicio'] < $b1['hora_fin']) {
                                $errores[] = "Empalme: {$b1['dia_semana']} {$b1['hora_inicio']}-{$b1['hora_fin']} se cruza con {$b2['hora_inicio']}-{$b2['hora_fin']}.";
                            }
                        }
                    }
                }
            }
        }

        if (!empty($errores)) {
            flash(implode('<br>', $errores), 'error');
            redirect('/?r=inscripcion&accion=nueva&id_alumno='.$id_alumno);
        }

        // === GUARDAR ===
        try {
            $pdo->beginTransaction();
            $folio = generar_folio();
            $total_creditos = array_sum(array_column($info, 'creditos'));
            $pdo->prepare("INSERT INTO inscripcion (folio,id_alumno,fecha_inscripcion,estatus,total_creditos) VALUES (?,?,NOW(),'activa',?)")
                ->execute([$folio, $id_alumno, $total_creditos]);
            $iid = (int)$pdo->lastInsertId();
            foreach ($grupos as $gid) {
                $pdo->prepare("INSERT INTO inscripcion_detalle (id_inscripcion, id_grupo) VALUES (?,?)")->execute([$iid, (int)$gid]);
                $pdo->prepare("UPDATE grupo SET inscritos = inscritos + 1 WHERE id_grupo=?")->execute([(int)$gid]);
            }
            $pdo->commit();
            flash("Inscripcion creada. Folio: $folio");
            redirect('/?r=comprobante&accion=ver&id='.$iid);
        } catch (PDOException $e) {
            $pdo->rollBack();
            flash('Error: '.$e->getMessage(),'error');
            redirect('/?r=inscripcion&accion=nueva&id_alumno='.$id_alumno);
        }
    }

    public function cancelar() {
        $pdo = Database::pdo();
        $id = get_int('id');
        try {
            $pdo->beginTransaction();
            $st = $pdo->prepare("SELECT id_grupo FROM inscripcion_detalle WHERE id_inscripcion=?");
            $st->execute([$id]);
            foreach ($st->fetchAll() as $d) {
                $pdo->prepare("UPDATE grupo SET inscritos = GREATEST(0, inscritos-1) WHERE id_grupo=?")->execute([$d['id_grupo']]);
            }
            $pdo->prepare("UPDATE inscripcion SET estatus='cancelada' WHERE id_inscripcion=?")->execute([$id]);
            $pdo->commit();
            flash('Inscripcion cancelada.');
        } catch (PDOException $e) {
            $pdo->rollBack();
            flash('Error: '.$e->getMessage(),'error');
        }
        redirect('/?r=inscripcion');
    }
}
