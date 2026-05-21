<?php
class MateriaController {
    public function index() {
        $q = trim($_GET['q'] ?? '');
        $sem = $_GET['sem'] ?? '';
        $area = $_GET['area'] ?? '';
        $sql = "SELECT m.*, ae.nombre_area, c.nombre_carrera FROM materia m JOIN area_estudio ae ON ae.id_area=m.id_area JOIN carrera c ON c.id_carrera=m.id_carrera WHERE 1=1";
        $params = [];
        if ($q !== '') { $sql .= " AND (m.nombre LIKE :q OR m.clave_materia LIKE :q)"; $params[':q']="%$q%"; }
        if ($sem !== '') { $sql .= " AND m.semestre=:sem"; $params[':sem']=(int)$sem; }
        if ($area !== '') { $sql .= " AND m.id_area=:area"; $params[':area']=(int)$area; }
        $sql .= " ORDER BY m.semestre, m.nombre";
        $st = Database::pdo()->prepare($sql); $st->execute($params);
        $areas = Database::pdo()->query("SELECT * FROM area_estudio")->fetchAll();
        render('materia/index', ['title'=>'Materias','materias'=>$st->fetchAll(),'q'=>$q,'sem'=>$sem,'area'=>$area,'areas'=>$areas]);
    }
    public function crear() {
        $areas = Database::pdo()->query("SELECT * FROM area_estudio")->fetchAll();
        $carreras = Database::pdo()->query("SELECT * FROM carrera")->fetchAll();
        render('materia/form', ['title'=>'Nueva materia','m'=>null,'areas'=>$areas,'carreras'=>$carreras]);
    }
    public function editar() {
        $st = Database::pdo()->prepare("SELECT * FROM materia WHERE id_materia=?");
        $st->execute([get_int('id')]); $m = $st->fetch();
        if (!$m) { flash('Materia no encontrada','error'); redirect('/?r=materia'); }
        $areas = Database::pdo()->query("SELECT * FROM area_estudio")->fetchAll();
        $carreras = Database::pdo()->query("SELECT * FROM carrera")->fetchAll();
        render('materia/form', ['title'=>'Editar materia','m'=>$m,'areas'=>$areas,'carreras'=>$carreras]);
    }
    public function guardar() {
        $pdo = Database::pdo();
        $id = (int)($_POST['id_materia'] ?? 0);
        $data = [
            ':clave_materia'=>(int)post_str('clave_materia'),
            ':nombre'=>post_str('nombre'),
            ':semestre'=>(int)post_str('semestre','1'),
            ':creditos'=>(int)post_str('creditos','0'),
            ':tipo'=>post_str('tipo','obligatoria'),
            ':laboratorio'=>(int)post_str('laboratorio','0'),
            ':id_area'=>(int)post_str('id_area','1'),
            ':id_carrera'=>(int)post_str('id_carrera','1'),
        ];
        try {
            if ($id > 0) {
                $data[':id']=$id;
                $pdo->prepare("UPDATE materia SET clave_materia=:clave_materia,nombre=:nombre,semestre=:semestre,creditos=:creditos,tipo=:tipo,laboratorio=:laboratorio,id_area=:id_area,id_carrera=:id_carrera WHERE id_materia=:id")->execute($data);
                flash('Materia actualizada.');
            } else {
                $pdo->prepare("INSERT INTO materia (clave_materia,nombre,semestre,creditos,tipo,laboratorio,id_area,id_carrera) VALUES (:clave_materia,:nombre,:semestre,:creditos,:tipo,:laboratorio,:id_area,:id_carrera)")->execute($data);
                flash('Materia creada.');
            }
        } catch (PDOException $e) { flash('Error: '.$e->getMessage(),'error'); }
        redirect('/?r=materia');
    }
    public function borrar() {
        try { Database::pdo()->prepare("DELETE FROM materia WHERE id_materia=?")->execute([get_int('id')]); flash('Materia eliminada.'); }
        catch (PDOException $e) { flash('No se puede eliminar (tiene grupos): '.$e->getMessage(),'error'); }
        redirect('/?r=materia');
    }
}
