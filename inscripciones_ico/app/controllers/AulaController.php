<?php
class AulaController {
    public function index() {
        $q = trim($_GET['q'] ?? '');
        $sql = "SELECT * FROM aula WHERE 1=1";
        $p = [];
        if ($q !== '') { $sql .= " AND (clave_aula LIKE :q OR edificio LIKE :q)"; $p[':q']="%$q%"; }
        $sql .= " ORDER BY edificio, clave_aula";
        $st = Database::pdo()->prepare($sql); $st->execute($p);
        render('aula/index', ['title'=>'Aulas','aulas'=>$st->fetchAll(),'q'=>$q]);
    }
    public function crear() { render('aula/form', ['title'=>'Nueva aula','a'=>null]); }
    public function editar() {
        $st = Database::pdo()->prepare("SELECT * FROM aula WHERE id_aula=?"); $st->execute([get_int('id')]); $a=$st->fetch();
        if (!$a) { flash('Aula no encontrada','error'); redirect('/?r=aula'); }
        render('aula/form', ['title'=>'Editar aula','a'=>$a]);
    }
    public function guardar() {
        $pdo = Database::pdo();
        $id = (int)($_POST['id_aula'] ?? 0);
        $data = [':clave_aula'=>post_str('clave_aula'),':edificio'=>post_str('edificio'),':capacidad'=>(int)post_str('capacidad','40')];
        try {
            if ($id>0) { $data[':id']=$id;
                $pdo->prepare("UPDATE aula SET clave_aula=:clave_aula,edificio=:edificio,capacidad=:capacidad WHERE id_aula=:id")->execute($data);
                flash('Aula actualizada.');
            } else {
                $pdo->prepare("INSERT INTO aula (clave_aula,edificio,capacidad) VALUES (:clave_aula,:edificio,:capacidad)")->execute($data);
                flash('Aula creada.');
            }
        } catch (PDOException $e) { flash('Error: '.$e->getMessage(),'error'); }
        redirect('/?r=aula');
    }
    public function borrar() {
        try { Database::pdo()->prepare("DELETE FROM aula WHERE id_aula=?")->execute([get_int('id')]); flash('Aula eliminada.'); }
        catch (PDOException $e) { flash('No se puede eliminar (tiene grupos): '.$e->getMessage(),'error'); }
        redirect('/?r=aula');
    }
}
