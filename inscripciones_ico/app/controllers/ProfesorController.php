<?php
class ProfesorController {
    public function index() {
        $q = trim($_GET['q'] ?? '');
        $sql = "SELECT * FROM profesor WHERE 1=1";
        $params = [];
        if ($q !== '') {
            $sql .= " AND (nombre LIKE :q OR ap_paterno LIKE :q OR ap_materno LIKE :q OR correo LIKE :q)";
            $params[':q'] = "%$q%";
        }
        $sql .= " ORDER BY ap_paterno, ap_materno, nombre";
        $st = Database::pdo()->prepare($sql);
        $st->execute($params);
        render('profesor/index', ['title'=>'Profesores','profesores'=>$st->fetchAll(),'q'=>$q]);
    }
    public function crear() { render('profesor/form', ['title'=>'Nuevo profesor','prof'=>null]); }
    public function editar() {
        $st = Database::pdo()->prepare("SELECT * FROM profesor WHERE id_profesor=?");
        $st->execute([get_int('id')]);
        $prof = $st->fetch();
        if (!$prof) { flash('Profesor no encontrado','error'); redirect('/?r=profesor'); }
        render('profesor/form', ['title'=>'Editar profesor','prof'=>$prof]);
    }
    public function guardar() {
        $pdo = Database::pdo();
        $id = (int)($_POST['id_profesor'] ?? 0);
        $data = [
            ':nombre'=>post_str('nombre'),
            ':ap_paterno'=>post_str('ap_paterno'),
            ':ap_materno'=>post_str('ap_materno'),
            ':correo'=>post_str('correo'),
        ];
        try {
            if ($id > 0) {
                $data[':id'] = $id;
                $pdo->prepare("UPDATE profesor SET nombre=:nombre, ap_paterno=:ap_paterno, ap_materno=:ap_materno, correo=:correo WHERE id_profesor=:id")->execute($data);
                flash('Profesor actualizado.');
            } else {
                $pdo->prepare("INSERT INTO profesor (nombre,ap_paterno,ap_materno,correo) VALUES (:nombre,:ap_paterno,:ap_materno,:correo)")->execute($data);
                flash('Profesor creado.');
            }
        } catch (PDOException $e) { flash('Error: '.$e->getMessage(),'error'); }
        redirect('/?r=profesor');
    }
    public function borrar() {
        try { Database::pdo()->prepare("DELETE FROM profesor WHERE id_profesor=?")->execute([get_int('id')]); flash('Profesor eliminado.'); }
        catch (PDOException $e) { flash('No se puede eliminar (tiene grupos asignados): '.$e->getMessage(),'error'); }
        redirect('/?r=profesor');
    }
}
