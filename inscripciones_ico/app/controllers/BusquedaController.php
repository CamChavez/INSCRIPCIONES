<?php
/**
 * Busqueda transversal por todas las tablas.
 * Permite buscar por palabra clave y filtrar por tipo de entidad y atributo.
 */
class BusquedaController {
    public function index() {
        $q = trim($_GET['q'] ?? '');
        $tipo = $_GET['tipo'] ?? 'todos';
        $resultados = [];
        if ($q !== '') {
            $pdo = Database::pdo();
            $lk = "%$q%";

            if (in_array($tipo, ['todos','alumno'])) {
                $st = $pdo->prepare("SELECT 'Alumno' AS entidad, id_alumno AS id, CONCAT(matricula,' - ',ap_paterno,' ',ap_materno,' ',nombre,' (',correo,')') AS detalle, '/?r=alumno&accion=editar' AS url FROM alumno WHERE matricula LIKE :q OR nombre LIKE :q OR ap_paterno LIKE :q OR ap_materno LIKE :q OR correo LIKE :q LIMIT 50");
                $st->execute([':q'=>$lk]);
                $resultados = array_merge($resultados, $st->fetchAll());
            }
            if (in_array($tipo, ['todos','profesor'])) {
                $st = $pdo->prepare("SELECT 'Profesor' AS entidad, id_profesor AS id, CONCAT(ap_paterno,' ',ap_materno,' ',nombre,' (',correo,')') AS detalle, '/?r=profesor&accion=editar' AS url FROM profesor WHERE nombre LIKE :q OR ap_paterno LIKE :q OR ap_materno LIKE :q OR correo LIKE :q LIMIT 50");
                $st->execute([':q'=>$lk]);
                $resultados = array_merge($resultados, $st->fetchAll());
            }
            if (in_array($tipo, ['todos','materia'])) {
                $st = $pdo->prepare("SELECT 'Materia' AS entidad, id_materia AS id, CONCAT(clave_materia,' - ',nombre,' (',semestre,'° sem)') AS detalle, '/?r=materia&accion=editar' AS url FROM materia WHERE clave_materia LIKE :q OR nombre LIKE :q LIMIT 50");
                $st->execute([':q'=>$lk]);
                $resultados = array_merge($resultados, $st->fetchAll());
            }
            if (in_array($tipo, ['todos','aula'])) {
                $st = $pdo->prepare("SELECT 'Aula' AS entidad, id_aula AS id, CONCAT(clave_aula,' (Edif. ',edificio,', cap. ',capacidad,')') AS detalle, '/?r=aula&accion=editar' AS url FROM aula WHERE clave_aula LIKE :q OR edificio LIKE :q LIMIT 50");
                $st->execute([':q'=>$lk]);
                $resultados = array_merge($resultados, $st->fetchAll());
            }
            if (in_array($tipo, ['todos','grupo'])) {
                $st = $pdo->prepare("SELECT 'Grupo' AS entidad, g.id_grupo AS id, CONCAT('Grupo ',g.clave_grupo,' - ',m.nombre,' (',g.turno,')') AS detalle, '/?r=grupo&accion=editar' AS url FROM grupo g JOIN materia m ON m.id_materia=g.id_materia WHERE g.clave_grupo LIKE :q OR m.nombre LIKE :q LIMIT 50");
                $st->execute([':q'=>$lk]);
                $resultados = array_merge($resultados, $st->fetchAll());
            }
            if (in_array($tipo, ['todos','inscripcion'])) {
                $st = $pdo->prepare("SELECT 'Inscripcion' AS entidad, i.id_inscripcion AS id, CONCAT(i.folio,' - ',a.matricula,' ',a.ap_paterno,' ',a.nombre,' (',i.estatus,')') AS detalle, '/?r=comprobante&accion=ver' AS url FROM inscripcion i JOIN alumno a ON a.id_alumno=i.id_alumno WHERE i.folio LIKE :q OR a.matricula LIKE :q OR a.nombre LIKE :q OR a.ap_paterno LIKE :q LIMIT 50");
                $st->execute([':q'=>$lk]);
                $resultados = array_merge($resultados, $st->fetchAll());
            }
        }
        render('busqueda/index', ['title'=>'Busqueda','q'=>$q,'tipo'=>$tipo,'resultados'=>$resultados]);
    }
}
