<?php
class AreaController {
    public function index() {
        $st = Database::pdo()->query("SELECT * FROM area_estudio ORDER BY id_area");
        render('area_estudio/index', ['title'=>'Areas de estudio','areas'=>$st->fetchAll()]);
    }
    public function crear() { render('area_estudio/form', ['title'=>'Nueva area','a'=>null]); }
    public function editar() {
        $st = Database::pdo()->prepare("SELECT * FROM area_estudio WHERE id_area=?"); $st->execute([get_int('id')]); $a=$st->fetch();
        if (!$a) { flash('Area no encontrada','error'); redirect('/?r=area'); }
        render('area_estudio/form', ['title'=>'Editar area','a'=>$a]);
    }
    public function guardar() {
        $pdo = Database::pdo();
        $id = (int)($_POST['id_area'] ?? 0);
        $data = [':n'=>post_str('nombre_area'),':d'=>post_str('descripcion')];
        try {
            if ($id>0) { $data[':id']=$id;
                $pdo->prepare("UPDATE area_estudio SET nombre_area=:n,descripcion=:d WHERE id_area=:id")->execute($data);
                flash('Area actualizada.');
            } else {
                $pdo->prepare("INSERT INTO area_estudio (nombre_area,descripcion) VALUES (:n,:d)")->execute($data);
                flash('Area creada.');
            }
        } catch (PDOException $e) { flash('Error: '.$e->getMessage(),'error'); }
        redirect('/?r=area');
    }
    public function borrar() {
        try { Database::pdo()->prepare("DELETE FROM area_estudio WHERE id_area=?")->execute([get_int('id')]); flash('Area eliminada.'); }
        catch (PDOException $e) { flash('No se puede eliminar: '.$e->getMessage(),'error'); }
        redirect('/?r=area');
    }
}
