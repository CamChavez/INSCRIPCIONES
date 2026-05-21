<?php
class AlumnoController {
    public function index() {
        $pdo = Database::pdo();
        $q = trim($_GET['q'] ?? '');
        $sem = $_GET['sem'] ?? '';
        $sql = "SELECT a.*, c.nombre_carrera FROM alumno a JOIN carrera c ON c.id_carrera=a.id_carrera WHERE 1=1";
        $params = [];
        if ($q !== '') {
            $sql .= " AND (a.nombre LIKE :q OR a.ap_paterno LIKE :q OR a.ap_materno LIKE :q OR a.matricula LIKE :q OR a.correo LIKE :q)";
            $params[':q'] = "%$q%";
        }
        if ($sem !== '') {
            $sql .= " AND a.semestre = :sem";
            $params[':sem'] = (int)$sem;
        }
        $sql .= " ORDER BY a.ap_paterno, a.ap_materno, a.nombre";
        $st = $pdo->prepare($sql);
        $st->execute($params);
        $alumnos = $st->fetchAll();
        render('alumno/index', ['title'=>'Alumnos','alumnos'=>$alumnos,'q'=>$q,'sem'=>$sem]);
    }

    public function crear() {
        $carreras = Database::pdo()->query("SELECT * FROM carrera ORDER BY nombre_carrera")->fetchAll();
        render('alumno/form', ['title'=>'Nuevo alumno','alumno'=>null,'carreras'=>$carreras]);
    }

    public function guardar() {
        $pdo = Database::pdo();
        $id = (int)($_POST['id_alumno'] ?? 0);
        $data = [
            'matricula'=>post_str('matricula'),
            'nombre'=>post_str('nombre'),
            'ap_paterno'=>post_str('ap_paterno'),
            'ap_materno'=>post_str('ap_materno'),
            'correo'=>post_str('correo'),
            'fecha_nacimiento'=>post_str('fecha_nacimiento','2000-01-01'),
            'generacion'=>(int)post_str('generacion','2024'),
            'turno'=>post_str('turno','Matutino'),
            'semestre'=>(int)post_str('semestre','1'),
            'sistema'=>post_str('sistema','Escolarizado'),
            'estado'=>post_str('estado','Activo'),
            'estatus_pago'=>(int)post_str('estatus_pago','1'),
            'promedio'=>(float)post_str('promedio','0'),
            'id_carrera'=>(int)post_str('id_carrera','1'),
        ];
        try {
            if ($id > 0) {
                $sql = "UPDATE alumno SET matricula=:matricula,nombre=:nombre,ap_paterno=:ap_paterno,ap_materno=:ap_materno,correo=:correo,fecha_nacimiento=:fecha_nacimiento,generacion=:generacion,turno=:turno,semestre=:semestre,sistema=:sistema,estado=:estado,estatus_pago=:estatus_pago,promedio=:promedio,id_carrera=:id_carrera WHERE id_alumno=:id";
                $data[':id'] = $id;
                $pdo->prepare($sql)->execute(array_combine(array_map(fn($k)=>":$k",array_keys($data)),$data));
                flash('Alumno actualizado correctamente.');
            } else {
                $sql = "INSERT INTO alumno (matricula,nombre,ap_paterno,ap_materno,correo,fecha_nacimiento,generacion,turno,semestre,sistema,estado,estatus_pago,promedio,id_carrera) VALUES (:matricula,:nombre,:ap_paterno,:ap_materno,:correo,:fecha_nacimiento,:generacion,:turno,:semestre,:sistema,:estado,:estatus_pago,:promedio,:id_carrera)";
                $pdo->prepare($sql)->execute(array_combine(array_map(fn($k)=>":$k",array_keys($data)),$data));
                flash('Alumno creado correctamente.');
            }
        } catch (PDOException $e) {
            flash('Error: '.$e->getMessage(),'error');
        }
        redirect('/?r=alumno');
    }

    public function editar() {
        $id = get_int('id');
        $pdo = Database::pdo();
        $alumno = $pdo->prepare("SELECT * FROM alumno WHERE id_alumno=?");
        $alumno->execute([$id]);
        $alumno = $alumno->fetch();
        if (!$alumno) { flash('Alumno no encontrado','error'); redirect('/?r=alumno'); }
        $carreras = $pdo->query("SELECT * FROM carrera ORDER BY nombre_carrera")->fetchAll();
        render('alumno/form', ['title'=>'Editar alumno','alumno'=>$alumno,'carreras'=>$carreras]);
    }

    public function borrar() {
        $id = get_int('id');
        try {
            Database::pdo()->prepare("DELETE FROM alumno WHERE id_alumno=?")->execute([$id]);
            flash('Alumno eliminado.');
        } catch (PDOException $e) {
            flash('No se puede eliminar: '.$e->getMessage(),'error');
        }
        redirect('/?r=alumno');
    }
}
