<?php
class CarreraController {
    public function index() {
        $st = Database::pdo()->query("SELECT * FROM carrera ORDER BY nombre_carrera");
        render('carrera/index', ['title'=>'Carreras','carreras'=>$st->fetchAll()]);
    }
    public function crear() { render('carrera/form', ['title'=>'Nueva carrera','c'=>null]); }
    public function editar() {
        $st = Database::pdo()->prepare("SELECT * FROM carrera WHERE id_carrera=?"); $st->execute([get_int('id')]); $c=$st->fetch();
        if (!$c) { flash('Carrera no encontrada','error'); redirect('/?r=carrera'); }
        render('carrera/form', ['title'=>'Editar carrera','c'=>$c]);
    }
    public function guardar() {
        $pdo = Database::pdo();
        $id = (int)($_POST['id_carrera'] ?? 0);
        $data = [
            ':clave'=>(int)post_str('clave_carrera'),
            ':n'=>post_str('nombre_carrera'),
            ':m'=>post_str('modalidad','Escolarizado'),
            ':d'=>(int)post_str('duracion_sem','9'),
            ':co'=>(int)post_str('creditos_obligatorios','0'),
            ':cop'=>(int)post_str('creditos_optativos','0'),
            ':p'=>(int)post_str('plan_estudios','2016'),
        ];
        try {
            if ($id>0) { $data[':id']=$id;
                $pdo->prepare("UPDATE carrera SET clave_carrera=:clave,nombre_carrera=:n,modalidad=:m,duracion_sem=:d,creditos_obligatorios=:co,creditos_optativos=:cop,plan_estudios=:p WHERE id_carrera=:id")->execute($data);
                flash('Carrera actualizada.');
            } else {
                $pdo->prepare("INSERT INTO carrera (clave_carrera,nombre_carrera,modalidad,duracion_sem,creditos_obligatorios,creditos_optativos,plan_estudios) VALUES (:clave,:n,:m,:d,:co,:cop,:p)")->execute($data);
                flash('Carrera creada.');
            }
        } catch (PDOException $e) { flash('Error: '.$e->getMessage(),'error'); }
        redirect('/?r=carrera');
    }
    public function borrar() {
        try { Database::pdo()->prepare("DELETE FROM carrera WHERE id_carrera=?")->execute([get_int('id')]); flash('Carrera eliminada.'); }
        catch (PDOException $e) { flash('No se puede eliminar (tiene alumnos): '.$e->getMessage(),'error'); }
        redirect('/?r=carrera');
    }
}
