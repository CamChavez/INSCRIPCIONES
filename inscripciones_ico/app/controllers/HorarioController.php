<?php
class HorarioController {
    public function index() {
        $st = Database::pdo()->query("SELECT * FROM horario_bloque ORDER BY FIELD(dia_semana,'Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'), hora_inicio");
        render('horario/index', ['title'=>'Horarios','bloques'=>$st->fetchAll()]);
    }
    public function crear() { render('horario/form', ['title'=>'Nuevo bloque','b'=>null]); }
    public function editar() {
        $st = Database::pdo()->prepare("SELECT * FROM horario_bloque WHERE id_horario=?"); $st->execute([get_int('id')]); $b=$st->fetch();
        if (!$b) { flash('Bloque no encontrado','error'); redirect('/?r=horario'); }
        render('horario/form', ['title'=>'Editar bloque','b'=>$b]);
    }
    public function guardar() {
        $pdo = Database::pdo();
        $id = (int)($_POST['id_horario'] ?? 0);
        $data = [':dia'=>post_str('dia_semana'),':hi'=>post_str('hora_inicio'),':hf'=>post_str('hora_fin')];
        try {
            if ($id>0) { $data[':id']=$id;
                $pdo->prepare("UPDATE horario_bloque SET dia_semana=:dia,hora_inicio=:hi,hora_fin=:hf WHERE id_horario=:id")->execute($data);
                flash('Bloque actualizado.');
            } else {
                $pdo->prepare("INSERT INTO horario_bloque (dia_semana,hora_inicio,hora_fin) VALUES (:dia,:hi,:hf)")->execute($data);
                flash('Bloque creado.');
            }
        } catch (PDOException $e) { flash('Error: '.$e->getMessage(),'error'); }
        redirect('/?r=horario');
    }
    public function borrar() {
        try { Database::pdo()->prepare("DELETE FROM horario_bloque WHERE id_horario=?")->execute([get_int('id')]); flash('Bloque eliminado.'); }
        catch (PDOException $e) { flash('No se puede eliminar (asignado a grupos): '.$e->getMessage(),'error'); }
        redirect('/?r=horario');
    }
}
