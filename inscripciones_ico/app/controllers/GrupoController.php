<?php
class GrupoController {
    public function index() {
        $q = trim($_GET['q'] ?? '');
        $sem = $_GET['sem'] ?? '';
        $turno = $_GET['turno'] ?? '';
        $sql = "SELECT g.*, m.clave_materia, m.nombre AS materia, m.semestre, m.creditos, m.tipo,
                       CONCAT(p.nombre,' ',p.ap_paterno,' ',p.ap_materno) AS profesor,
                       a.clave_aula
                FROM grupo g
                JOIN materia m  ON m.id_materia=g.id_materia
                JOIN profesor p ON p.id_profesor=g.id_profesor
                JOIN aula a     ON a.id_aula=g.id_aula
                WHERE 1=1";
        $p = [];
        if ($q !== '') {
            $sql .= " AND (g.clave_grupo LIKE :q OR m.nombre LIKE :q OR p.nombre LIKE :q OR p.ap_paterno LIKE :q OR a.clave_aula LIKE :q)";
            $p[':q'] = "%$q%";
        }
        if ($sem !== '') { $sql .= " AND m.semestre=:sem"; $p[':sem']=(int)$sem; }
        if ($turno !== '') { $sql .= " AND g.turno=:turno"; $p[':turno']=$turno; }
        $sql .= " ORDER BY m.semestre, g.clave_grupo, m.nombre";
        $st = Database::pdo()->prepare($sql); $st->execute($p);
        $grupos = $st->fetchAll();
        // Obtener bloques de horario por grupo
        $hStmt = Database::pdo()->prepare("SELECT hb.* FROM grupo_horario gh JOIN horario_bloque hb ON hb.id_horario=gh.id_horario WHERE gh.id_grupo=? ORDER BY FIELD(hb.dia_semana,'Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'), hb.hora_inicio");
        foreach ($grupos as &$g) {
            $hStmt->execute([$g['id_grupo']]);
            $g['horarios'] = $hStmt->fetchAll();
        }
        render('grupo/index', ['title'=>'Grupos','grupos'=>$grupos,'q'=>$q,'sem'=>$sem,'turno'=>$turno]);
    }
    public function crear() {
        $pdo = Database::pdo();
        render('grupo/form', [
            'title'=>'Nuevo grupo','g'=>null,
            'materias'=>$pdo->query("SELECT * FROM materia WHERE semestre BETWEEN 1 AND 3 ORDER BY semestre,nombre")->fetchAll(),
            'profesores'=>$pdo->query("SELECT * FROM profesor ORDER BY ap_paterno")->fetchAll(),
            'aulas'=>$pdo->query("SELECT * FROM aula ORDER BY clave_aula")->fetchAll(),
            'bloques'=>$pdo->query("SELECT * FROM horario_bloque ORDER BY FIELD(dia_semana,'Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'), hora_inicio")->fetchAll(),
            'bloques_seleccionados'=>[],
        ]);
    }
    public function editar() {
        $pdo = Database::pdo();
        $st = $pdo->prepare("SELECT * FROM grupo WHERE id_grupo=?"); $st->execute([get_int('id')]); $g=$st->fetch();
        if (!$g) { flash('Grupo no encontrado','error'); redirect('/?r=grupo'); }
        $bs = $pdo->prepare("SELECT id_horario FROM grupo_horario WHERE id_grupo=?"); $bs->execute([$g['id_grupo']]);
        $sel = array_column($bs->fetchAll(), 'id_horario');
        render('grupo/form', [
            'title'=>'Editar grupo','g'=>$g,
            'materias'=>$pdo->query("SELECT * FROM materia ORDER BY semestre,nombre")->fetchAll(),
            'profesores'=>$pdo->query("SELECT * FROM profesor ORDER BY ap_paterno")->fetchAll(),
            'aulas'=>$pdo->query("SELECT * FROM aula ORDER BY clave_aula")->fetchAll(),
            'bloques'=>$pdo->query("SELECT * FROM horario_bloque ORDER BY FIELD(dia_semana,'Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'), hora_inicio")->fetchAll(),
            'bloques_seleccionados'=>$sel,
        ]);
    }
    public function guardar() {
        $pdo = Database::pdo();
        $id = (int)($_POST['id_grupo'] ?? 0);
        $data = [
            ':clave_grupo'=>(int)post_str('clave_grupo'),
            ':turno'=>post_str('turno','Matutino'),
            ':modalidad'=>post_str('modalidad','Presencial'),
            ':cupo'=>(int)post_str('cupo','30'),
            ':id_materia'=>(int)post_str('id_materia'),
            ':id_profesor'=>(int)post_str('id_profesor'),
            ':id_aula'=>(int)post_str('id_aula'),
        ];
        $bloques = $_POST['bloques'] ?? [];
        try {
            $pdo->beginTransaction();
            if ($id > 0) {
                $data[':id']=$id;
                $pdo->prepare("UPDATE grupo SET clave_grupo=:clave_grupo,turno=:turno,modalidad=:modalidad,cupo=:cupo,id_materia=:id_materia,id_profesor=:id_profesor,id_aula=:id_aula WHERE id_grupo=:id")->execute($data);
                $pdo->prepare("DELETE FROM grupo_horario WHERE id_grupo=?")->execute([$id]);
                $gid = $id;
            } else {
                $pdo->prepare("INSERT INTO grupo (clave_grupo,turno,modalidad,cupo,id_materia,id_profesor,id_aula) VALUES (:clave_grupo,:turno,:modalidad,:cupo,:id_materia,:id_profesor,:id_aula)")->execute($data);
                $gid = (int)$pdo->lastInsertId();
            }
            foreach ($bloques as $b) {
                $pdo->prepare("INSERT INTO grupo_horario (id_grupo,id_horario) VALUES (?,?)")->execute([$gid,(int)$b]);
            }
            $pdo->commit();
            flash($id>0 ? 'Grupo actualizado.' : 'Grupo creado.');
        } catch (PDOException $e) {
            $pdo->rollBack();
            flash('Error: '.$e->getMessage(),'error');
        }
        redirect('/?r=grupo');
    }
    public function borrar() {
        try { Database::pdo()->prepare("DELETE FROM grupo WHERE id_grupo=?")->execute([get_int('id')]); flash('Grupo eliminado.'); }
        catch (PDOException $e) { flash('No se puede eliminar: '.$e->getMessage(),'error'); }
        redirect('/?r=grupo');
    }
}
