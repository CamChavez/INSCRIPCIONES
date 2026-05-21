-- =====================================================================
-- Base de Datos: inscripciones_ico
-- Sistema de Inscripciones - Ingenieria en Computacion (1° a 3° semestre)
-- Equipo 13 - FES Aragon UNAM
-- Integrantes (orden alfabetico):
--   Chavez Ramirez Camila Simone
--   Padilla Torres Michelle Denise
--   Villagomez Venegas Leslie Naomi
-- Fecha: 2026-05-20
-- =====================================================================

DROP DATABASE IF EXISTS inscripciones_ico;
CREATE DATABASE inscripciones_ico CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE inscripciones_ico;

-- =====================================================================
-- TABLAS BASE (sin dependencias)
-- =====================================================================

CREATE TABLE area_estudio (
    id_area      INT AUTO_INCREMENT PRIMARY KEY,
    nombre_area  VARCHAR(60)  NOT NULL UNIQUE,
    descripcion  VARCHAR(200) NOT NULL DEFAULT ''
) ENGINE=InnoDB;

CREATE TABLE carrera (
    id_carrera             INT AUTO_INCREMENT PRIMARY KEY,
    clave_carrera          INT          NOT NULL UNIQUE,
    nombre_carrera         VARCHAR(100) NOT NULL,
    modalidad              VARCHAR(30)  NOT NULL DEFAULT 'Escolarizado',
    duracion_sem           INT          NOT NULL DEFAULT 9,
    creditos_obligatorios  INT          NOT NULL DEFAULT 0,
    creditos_optativos     INT          NOT NULL DEFAULT 0,
    plan_estudios          INT          NOT NULL DEFAULT 2016
) ENGINE=InnoDB;

CREATE TABLE aula (
    id_aula     INT AUTO_INCREMENT PRIMARY KEY,
    clave_aula  VARCHAR(15) NOT NULL UNIQUE,
    edificio   VARCHAR(10)  NOT NULL DEFAULT '',
    capacidad  INT          NOT NULL DEFAULT 40
) ENGINE=InnoDB;

CREATE TABLE profesor (
    id_profesor  INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(60) NOT NULL,
    ap_paterno   VARCHAR(60) NOT NULL,
    ap_materno   VARCHAR(60) NOT NULL DEFAULT '',
    correo       VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE horario_bloque (
    id_horario   INT AUTO_INCREMENT PRIMARY KEY,
    dia_semana   ENUM('Lunes','Martes','Miercoles','Jueves','Viernes','Sabado') NOT NULL,
    hora_inicio  TIME NOT NULL,
    hora_fin     TIME NOT NULL,
    UNIQUE KEY uk_bloque (dia_semana, hora_inicio, hora_fin),
    CHECK (hora_inicio < hora_fin)
) ENGINE=InnoDB;

-- =====================================================================
-- TABLAS DEPENDIENTES
-- =====================================================================

CREATE TABLE materia (
    id_materia    INT AUTO_INCREMENT PRIMARY KEY,
    clave_materia INT          NOT NULL UNIQUE,
    nombre        VARCHAR(80)  NOT NULL,
    semestre      TINYINT      NOT NULL DEFAULT 1,
    creditos      INT          NOT NULL DEFAULT 0,
    tipo          ENUM('obligatoria','optativa') NOT NULL DEFAULT 'obligatoria',
    laboratorio   TINYINT(1)   NOT NULL DEFAULT 0,
    id_area       INT          NOT NULL,
    id_carrera    INT          NOT NULL,
    CONSTRAINT fk_materia_area    FOREIGN KEY (id_area)    REFERENCES area_estudio(id_area),
    CONSTRAINT fk_materia_carrera FOREIGN KEY (id_carrera) REFERENCES carrera(id_carrera)
) ENGINE=InnoDB;

CREATE TABLE alumno (
    id_alumno         INT AUTO_INCREMENT PRIMARY KEY,
    matricula         BIGINT       NOT NULL UNIQUE,
    nombre            VARCHAR(60)  NOT NULL,
    ap_paterno        VARCHAR(60)  NOT NULL,
    ap_materno        VARCHAR(60)  NOT NULL DEFAULT '',
    correo            VARCHAR(80)  NOT NULL UNIQUE,
    fecha_nacimiento  DATE         NOT NULL DEFAULT '2000-01-01',
    generacion        INT          NOT NULL DEFAULT 2023,
    turno             ENUM('Matutino','Vespertino') NOT NULL DEFAULT 'Matutino',
    semestre          TINYINT      NOT NULL DEFAULT 1,
    sistema           ENUM('Escolarizado','Abierto') NOT NULL DEFAULT 'Escolarizado',
    estado            ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
    estatus_pago      TINYINT(1)   NOT NULL DEFAULT 1,
    promedio          DECIMAL(4,2) NOT NULL DEFAULT 0.00,
    id_carrera        INT          NOT NULL,
    CONSTRAINT fk_alumno_carrera FOREIGN KEY (id_carrera) REFERENCES carrera(id_carrera)
) ENGINE=InnoDB;

CREATE TABLE grupo (
    id_grupo     INT AUTO_INCREMENT PRIMARY KEY,
    clave_grupo  INT NOT NULL,
    turno        ENUM('Matutino','Vespertino') NOT NULL DEFAULT 'Matutino',
    modalidad    ENUM('Presencial','En linea') NOT NULL DEFAULT 'Presencial',
    cupo         INT NOT NULL DEFAULT 30,
    inscritos    INT NOT NULL DEFAULT 0,
    id_materia   INT NOT NULL,
    id_profesor  INT NOT NULL,
    id_aula      INT NOT NULL,
    UNIQUE KEY uk_grupo_materia (clave_grupo, id_materia),
    CONSTRAINT fk_grupo_materia  FOREIGN KEY (id_materia)  REFERENCES materia(id_materia),
    CONSTRAINT fk_grupo_profesor FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    CONSTRAINT fk_grupo_aula     FOREIGN KEY (id_aula)     REFERENCES aula(id_aula)
) ENGINE=InnoDB;

CREATE TABLE grupo_horario (
    id_grupo_horario INT AUTO_INCREMENT PRIMARY KEY,
    id_grupo         INT NOT NULL,
    id_horario       INT NOT NULL,
    UNIQUE KEY uk_grupo_horario (id_grupo, id_horario),
    CONSTRAINT fk_gh_grupo   FOREIGN KEY (id_grupo)   REFERENCES grupo(id_grupo)   ON DELETE CASCADE,
    CONSTRAINT fk_gh_horario FOREIGN KEY (id_horario) REFERENCES horario_bloque(id_horario)
) ENGINE=InnoDB;

CREATE TABLE inscripcion (
    id_inscripcion     INT AUTO_INCREMENT PRIMARY KEY,
    folio              VARCHAR(20) NOT NULL UNIQUE,
    id_alumno          INT         NOT NULL,
    fecha_inscripcion  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estatus            ENUM('activa','cancelada') NOT NULL DEFAULT 'activa',
    total_creditos     INT         NOT NULL DEFAULT 0,
    CONSTRAINT fk_insc_alumno FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno)
) ENGINE=InnoDB;

CREATE TABLE inscripcion_detalle (
    id_detalle      INT AUTO_INCREMENT PRIMARY KEY,
    id_inscripcion  INT NOT NULL,
    id_grupo        INT NOT NULL,
    UNIQUE KEY uk_detalle (id_inscripcion, id_grupo),
    CONSTRAINT fk_det_insc  FOREIGN KEY (id_inscripcion) REFERENCES inscripcion(id_inscripcion) ON DELETE CASCADE,
    CONSTRAINT fk_det_grupo FOREIGN KEY (id_grupo)       REFERENCES grupo(id_grupo)
) ENGINE=InnoDB;

-- =====================================================================
-- DATOS: AREA_ESTUDIO
-- =====================================================================
INSERT INTO area_estudio (id_area, nombre_area, descripcion) VALUES
(1, 'Ciencias Basicas y Matematicas', 'Algebra, calculo, geometria, ecuaciones diferenciales y similares'),
(2, 'Sistemas Computacionales',       'Programacion, bases de datos, ingenieria de software'),
(3, 'Electrica y Electronica',        'Circuitos, dispositivos electronicos, microprocesadores'),
(4, 'Sociales y Humanidades',         'Comunicacion, emprendimiento, habilidades directivas'),
(5, 'Ingenieria Aplicada',            'Redes, sistemas operativos, administracion de proyectos'),
(6, 'Optativas',                      'Asignaturas optativas y temas especiales');

-- =====================================================================
-- DATOS: CARRERA
-- =====================================================================
INSERT INTO carrera (id_carrera, clave_carrera, nombre_carrera, modalidad, duracion_sem, creditos_obligatorios, creditos_optativos, plan_estudios) VALUES
(1, 110, 'Ingenieria en Computacion', 'Escolarizado', 9, 348, 48, 2016);


-- =====================================================================
-- DATOS: AULA
-- =====================================================================
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (1, 'A11201', 'A11', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (2, 'A11202', 'A11', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (3, 'A11203', 'A11', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (4, 'A11204', 'A11', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (5, 'A203', 'A20', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (6, 'A204', 'A20', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (7, 'A205', 'A20', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (8, 'A211', 'A21', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (9, 'A212', 'A21', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (10, 'A213', 'A21', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (11, 'A214', 'A21', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (12, 'A215', 'A21', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (13, 'A216', 'A21', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (14, 'A504', 'A50', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (15, 'A505', 'A50', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (16, 'A506', 'A50', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (17, 'A507', 'A50', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (18, 'A521', 'A52', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (19, 'A8117', 'A81', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (20, 'A8118', 'A81', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (21, 'A8119', 'A81', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (22, 'A8120', 'A81', 40);
INSERT INTO aula (id_aula, clave_aula, edificio, capacidad) VALUES (23, 'A8121', 'A81', 40);

-- =====================================================================
-- DATOS: PROFESOR (solo los que dan clase a 1°-3° sem)
-- =====================================================================
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (1, 'Sergio', 'Hernandez', 'Lopez', 'sergiohernandezhel@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (2, 'Maria Algelica', 'Feria', 'Victoria', 'angelicaferiaf6@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (3, 'Miguel Angel', 'Sanchez', 'Hernandez', 'miguelsanchezt32@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (4, 'Rodolfo', 'Vazquez', 'Morales', 'rodolfovazquezh6@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (5, 'Gerardo', 'Gonzalez', 'Hernandez', 'gerardogonzalezgoh@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (6, 'Jose Antonio', 'Avila', 'Monroy', 'antonioavilana@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (7, 'Juan', 'Gastaldi', 'Perez', 'juangastaldi9a@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (8, 'Luis Armando', 'Vieyra', 'Reboyo', 'luisvieyra26@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (9, 'Aaron', 'Velasco', 'Agustin', 'aaronvelascovea@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (10, 'Jonathan', 'Martinez', 'Romero', 'jonathanmartinezky7@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (11, 'Jesus Angel', 'Romero', 'Andalon', 'jesusandalonsa@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (12, 'Juan Manuel', 'Arellano', 'Orozco', 'manuelarellanoa6@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (13, 'Berenice Itzel', 'Falcon', 'Arellano', 'berenicefalconlk6@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (14, 'Miriam', 'Cruz', 'Ortiz', 'profesor18@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (15, 'Enrique', 'Sanchez', 'Sanchez', 'victorsanchez27@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (16, 'Arturo', 'Rodriguez', 'Garcia', 'arturorodriguez35@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (17, 'Jose Manuel', 'Garibay', 'Pedraza', 'almagaribayr7@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (18, 'Carlos Alberto', 'Parrales', 'Castañeda', 'carlosparralesgi2@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (19, 'Juan Carlos', 'Ramos', 'Marquez', 'juanramosram@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (20, 'Antonio Gerardo', 'Perez', 'Muñoz', 'gerardoperez23@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (21, 'Everardo', 'Solis', 'Alcantar', 'everardosolisr0@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (22, 'Ernesto', 'Peñaloza', 'Romero', 'ernestopenalozaffa@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (23, 'Alfredo', 'Mondragon', 'Escobar', 'alfredomondragontg8@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (24, 'Blanca Pamela', 'Aburto', 'Camacho', 'blancaaburto6c4@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (25, 'Alejandro', 'Suarez', 'Herrera', 'alejandrosuarezsuh@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (26, 'Ma. Del Pilar', 'Garcia', 'Villanueva', 'magarciap9@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (27, 'Clara Yahaira', 'Islas', 'Hernandez', 'yahairaislasv6@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (28, 'Jorge Luis', 'Candelario', 'Álvarez', 'jorgecandelariocaa@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (29, 'Joel Alfredo', 'Perez', 'Baldes', 'joelperezpev@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (30, 'Matilde', 'Colunga', 'Vazquez', 'matildecolungacov@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (31, 'Jorge Arturo', 'Lopez', 'Hernandez', 'jorgelopez91@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (32, 'Gabriel', 'Ortiz', 'Cordero', 'gabrielortizoic@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (33, 'Alejandro', 'Perez', 'Guzman', 'alejandropereze9@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (34, 'Belen Anaid', 'Alba', 'Villa', 'belenalba749@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (35, 'Cesar Francisco', 'German', 'Rosas', 'cesargermanx9@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (36, 'Alma Rosa', 'Gutierrez', 'Castillo', 'almagutierrez88@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (37, 'Blanca Estela', 'Cruz', 'Luevano', 'blancaluevanoq9@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (38, 'Cuauhtemoc', 'Chiapa', 'Monroy', 'cuauhtemocchiapacim@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (39, 'Efren', 'Guerrero', 'Santamaria', 'efrenguerreroc91@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (40, 'Enrique', 'Garcia', 'Guzman', 'profesor49@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (41, 'Jorge Ivan', 'Campos', 'Bravo', 'jorgecampos47@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (42, 'Jose Antonio', 'Castro', 'Diaz', 'josecastrocad@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (43, 'Jose Gil', 'Juarez', 'Palma', 'giljuarezb9@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (44, 'Judith', 'Ugalde', 'Lopez', 'judithugalde86@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (45, 'Maria Guadalupe', 'Almanzar', 'Vazquez', 'guadalupealmanzar1a@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (46, 'Rafael', 'Betancourt', 'Gonzalez', 'cuauhtemocchiapacim1@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (47, 'Roberto', 'Blanco', 'Bautista', 'robertoblancoir4@aragon.unam.mx');
INSERT INTO profesor (id_profesor, nombre, ap_paterno, ap_materno, correo) VALUES (48, 'Arcelia', 'Bernal', 'Diaz', 'arceliabernal83@aragon.unam.mx');

-- =====================================================================
-- DATOS: MATERIA (1°-3° sem ICO)
-- =====================================================================
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (1, 1110, 'Algebra', 1, 9, 'obligatoria', 0, 1, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (2, 1109, 'Calculo Diferencial E Integral', 1, 9, 'obligatoria', 0, 1, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (3, 1111, 'Computadoras Y Programación', 1, 9, 'obligatoria', 0, 2, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (4, 1108, 'Geometría Analítica', 1, 9, 'obligatoria', 0, 1, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (5, 1112, 'Introducción A La Ingeniería En Computación', 1, 6, 'obligatoria', 0, 2, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (6, 62, 'Algebra Lineal', 2, 9, 'obligatoria', 0, 1, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (7, 63, 'Calculo Vectorial', 2, 9, 'obligatoria', 0, 1, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (8, 1209, 'Comunicación', 2, 8, 'obligatoria', 0, 4, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (9, 1210, 'Emprendimiento 1', 2, 8, 'obligatoria', 0, 4, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (10, 1203, 'Programación Orientada A Objetos', 2, 8, 'obligatoria', 0, 2, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (11, 1211, 'Taller De Creatividad E Inovación', 2, 3, 'obligatoria', 0, 4, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (12, 1303, 'Ecuaciones Diferenciales', 3, 9, 'obligatoria', 0, 1, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (13, 71, 'Electricidad Y Magnetismo', 3, 11, 'obligatoria', 1, 3, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (14, 1311, 'Emprendimiento 2', 3, 8, 'obligatoria', 0, 4, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (15, 190, 'Estructura De Datos', 3, 8, 'obligatoria', 0, 2, 1);
INSERT INTO materia (id_materia, clave_materia, nombre, semestre, creditos, tipo, laboratorio, id_area, id_carrera) VALUES (16, 480, 'Metodos Númericos', 3, 9, 'obligatoria', 0, 1, 1);

-- =====================================================================
-- DATOS: HORARIO_BLOQUE
-- =====================================================================
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (1, 'Jueves', '07:00:00', '08:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (2, 'Jueves', '07:00:00', '09:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (3, 'Jueves', '07:00:00', '09:15:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (4, 'Jueves', '09:00:00', '10:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (5, 'Jueves', '09:00:00', '11:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (6, 'Jueves', '10:30:00', '12:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (7, 'Jueves', '10:45:00', '13:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (8, 'Jueves', '11:00:00', '13:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (9, 'Jueves', '13:00:00', '15:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (10, 'Jueves', '13:00:00', '15:15:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (11, 'Jueves', '15:00:00', '17:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (12, 'Jueves', '15:15:00', '17:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (13, 'Jueves', '15:45:00', '18:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (14, 'Jueves', '16:00:00', '17:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (15, 'Jueves', '16:00:00', '18:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (16, 'Jueves', '17:00:00', '18:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (17, 'Jueves', '17:00:00', '19:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (18, 'Jueves', '17:30:00', '19:45:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (19, 'Jueves', '18:00:00', '20:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (20, 'Jueves', '19:00:00', '21:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (21, 'Jueves', '19:50:00', '21:50:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (22, 'Jueves', '20:00:00', '22:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (23, 'Lunes', '07:00:00', '08:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (24, 'Lunes', '07:00:00', '08:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (25, 'Lunes', '08:00:00', '10:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (26, 'Lunes', '08:30:00', '10:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (27, 'Lunes', '10:00:00', '11:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (28, 'Lunes', '10:00:00', '11:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (29, 'Lunes', '10:00:00', '12:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (30, 'Lunes', '10:30:00', '12:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (31, 'Lunes', '11:00:00', '13:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (32, 'Lunes', '11:15:00', '13:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (33, 'Lunes', '11:30:00', '12:50:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (34, 'Lunes', '11:30:00', '13:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (35, 'Lunes', '13:00:00', '14:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (36, 'Lunes', '13:00:00', '14:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (37, 'Lunes', '13:00:00', '15:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (38, 'Lunes', '14:10:00', '15:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (39, 'Lunes', '14:30:00', '16:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (40, 'Lunes', '14:40:00', '16:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (41, 'Lunes', '16:00:00', '17:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (42, 'Lunes', '16:00:00', '17:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (43, 'Lunes', '17:30:00', '18:50:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (44, 'Lunes', '17:30:00', '19:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (45, 'Lunes', '19:00:00', '20:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (46, 'Lunes', '19:00:00', '20:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (47, 'Lunes', '20:00:00', '22:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (48, 'Martes', '07:00:00', '08:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (49, 'Martes', '07:00:00', '09:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (50, 'Martes', '07:00:00', '09:15:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (51, 'Martes', '09:00:00', '10:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (52, 'Martes', '09:00:00', '11:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (53, 'Martes', '10:30:00', '12:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (54, 'Martes', '10:45:00', '13:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (55, 'Martes', '11:00:00', '13:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (56, 'Martes', '13:00:00', '15:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (57, 'Martes', '13:00:00', '15:15:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (58, 'Martes', '15:00:00', '17:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (59, 'Martes', '15:15:00', '17:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (60, 'Martes', '15:45:00', '18:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (61, 'Martes', '16:00:00', '17:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (62, 'Martes', '16:00:00', '18:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (63, 'Martes', '17:00:00', '18:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (64, 'Martes', '17:00:00', '19:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (65, 'Martes', '17:30:00', '19:45:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (66, 'Martes', '18:00:00', '20:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (67, 'Martes', '19:00:00', '21:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (68, 'Martes', '19:50:00', '21:50:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (69, 'Martes', '20:00:00', '22:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (70, 'Miercoles', '07:00:00', '08:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (71, 'Miercoles', '07:00:00', '08:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (72, 'Miercoles', '08:00:00', '10:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (73, 'Miercoles', '08:30:00', '10:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (74, 'Miercoles', '10:00:00', '11:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (75, 'Miercoles', '10:00:00', '11:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (76, 'Miercoles', '10:00:00', '12:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (77, 'Miercoles', '10:30:00', '12:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (78, 'Miercoles', '11:00:00', '13:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (79, 'Miercoles', '11:15:00', '13:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (80, 'Miercoles', '11:30:00', '12:50:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (81, 'Miercoles', '11:30:00', '13:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (82, 'Miercoles', '13:00:00', '14:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (83, 'Miercoles', '13:00:00', '14:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (84, 'Miercoles', '13:00:00', '15:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (85, 'Miercoles', '14:10:00', '15:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (86, 'Miercoles', '14:30:00', '16:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (87, 'Miercoles', '14:40:00', '16:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (88, 'Miercoles', '16:00:00', '17:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (89, 'Miercoles', '16:00:00', '17:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (90, 'Miercoles', '17:30:00', '18:50:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (91, 'Miercoles', '17:30:00', '19:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (92, 'Miercoles', '19:00:00', '20:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (93, 'Miercoles', '19:00:00', '20:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (94, 'Miercoles', '20:00:00', '22:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (95, 'Viernes', '07:00:00', '08:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (96, 'Viernes', '07:00:00', '08:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (97, 'Viernes', '08:30:00', '10:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (98, 'Viernes', '10:00:00', '11:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (99, 'Viernes', '10:00:00', '11:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (100, 'Viernes', '11:30:00', '12:50:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (101, 'Viernes', '11:30:00', '13:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (102, 'Viernes', '11:30:00', '14:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (103, 'Viernes', '13:00:00', '14:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (104, 'Viernes', '13:00:00', '14:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (105, 'Viernes', '14:10:00', '15:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (106, 'Viernes', '14:40:00', '16:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (107, 'Viernes', '16:00:00', '17:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (108, 'Viernes', '16:00:00', '17:30:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (109, 'Viernes', '17:30:00', '18:50:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (110, 'Viernes', '17:30:00', '19:00:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (111, 'Viernes', '19:00:00', '20:20:00');
INSERT INTO horario_bloque (id_horario, dia_semana, hora_inicio, hora_fin) VALUES (112, 'Viernes', '19:00:00', '20:30:00');

-- =====================================================================
-- DATOS: GRUPO
-- =====================================================================
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (1, 2107, 'Matutino', 'Presencial', 30, 0, 1, 1, 3);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (2, 2107, 'Matutino', 'Presencial', 30, 0, 2, 5, 1);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (3, 2107, 'Matutino', 'Presencial', 30, 0, 3, 7, 21);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (4, 2107, 'Matutino', 'Presencial', 30, 0, 4, 10, 7);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (5, 2107, 'Matutino', 'Presencial', 30, 0, 5, 12, 19);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (6, 2108, 'Matutino', 'Presencial', 30, 0, 1, 13, 22);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (7, 2108, 'Matutino', 'Presencial', 30, 0, 3, 14, 23);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (8, 2157, 'Vespertino', 'Presencial', 30, 0, 1, 10, 19);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (9, 2157, 'Vespertino', 'Presencial', 30, 0, 2, 16, 16);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (10, 2157, 'Vespertino', 'Presencial', 30, 0, 3, 19, 2);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (11, 2157, 'Vespertino', 'Presencial', 30, 0, 4, 21, 13);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (12, 2157, 'Vespertino', 'Presencial', 30, 0, 5, 18, 19);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (13, 2158, 'Vespertino', 'Presencial', 30, 0, 5, 18, 19);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (14, 2207, 'Matutino', 'Presencial', 30, 0, 6, 8, 9);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (15, 2207, 'Matutino', 'Presencial', 30, 0, 7, 10, 15);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (16, 2207, 'Matutino', 'Presencial', 30, 0, 8, 23, 11);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (17, 2207, 'Matutino', 'Presencial', 30, 0, 9, 2, 8);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (18, 2207, 'Matutino', 'Presencial', 30, 0, 10, 4, 15);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (19, 2207, 'Matutino', 'Presencial', 30, 0, 11, 31, 16);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (20, 2208, 'Matutino', 'Presencial', 30, 0, 6, 47, 12);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (21, 2208, 'Matutino', 'Presencial', 30, 0, 7, 10, 12);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (22, 2208, 'Matutino', 'Presencial', 30, 0, 8, 23, 12);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (23, 2208, 'Matutino', 'Presencial', 30, 0, 9, 26, 12);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (24, 2208, 'Matutino', 'Presencial', 30, 0, 10, 22, 18);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (25, 2208, 'Matutino', 'Presencial', 30, 0, 11, 11, 15);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (26, 2209, 'Matutino', 'Presencial', 30, 0, 6, 5, 11);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (27, 2209, 'Matutino', 'Presencial', 30, 0, 7, 5, 10);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (28, 2209, 'Matutino', 'Presencial', 30, 0, 8, 6, 13);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (29, 2209, 'Matutino', 'Presencial', 30, 0, 9, 23, 13);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (30, 2209, 'Matutino', 'Presencial', 30, 0, 10, 3, 11);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (31, 2209, 'Matutino', 'Presencial', 30, 0, 11, 23, 8);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (32, 2210, 'Matutino', 'Presencial', 30, 0, 6, 32, 16);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (33, 2210, 'Matutino', 'Presencial', 30, 0, 7, 33, 14);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (34, 2210, 'Matutino', 'Presencial', 30, 0, 8, 23, 8);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (35, 2210, 'Matutino', 'Presencial', 30, 0, 9, 26, 16);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (36, 2210, 'Matutino', 'Presencial', 30, 0, 10, 22, 6);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (37, 2210, 'Matutino', 'Presencial', 30, 0, 11, 28, 9);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (38, 2211, 'Matutino', 'Presencial', 30, 0, 10, 15, 5);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (39, 2211, 'Matutino', 'Presencial', 30, 0, 11, 24, 1);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (40, 2212, 'Matutino', 'Presencial', 30, 0, 11, 24, 23);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (41, 2257, 'Vespertino', 'Presencial', 30, 0, 6, 25, 8);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (42, 2257, 'Vespertino', 'Presencial', 30, 0, 7, 17, 11);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (43, 2257, 'Vespertino', 'Presencial', 30, 0, 8, 27, 10);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (44, 2257, 'Vespertino', 'Presencial', 30, 0, 9, 30, 8);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (45, 2257, 'Vespertino', 'Presencial', 30, 0, 10, 19, 5);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (46, 2257, 'Vespertino', 'Presencial', 30, 0, 11, 9, 10);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (47, 2258, 'Vespertino', 'Presencial', 30, 0, 6, 21, 9);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (48, 2258, 'Vespertino', 'Presencial', 30, 0, 7, 20, 15);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (49, 2258, 'Vespertino', 'Presencial', 30, 0, 8, 34, 14);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (50, 2258, 'Vespertino', 'Presencial', 30, 0, 9, 30, 8);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (51, 2258, 'Vespertino', 'Presencial', 30, 0, 10, 29, 13);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (52, 2258, 'Vespertino', 'Presencial', 30, 0, 11, 34, 14);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (53, 2259, 'Vespertino', 'Presencial', 30, 0, 6, 21, 14);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (54, 2259, 'Vespertino', 'Presencial', 30, 0, 7, 16, 9);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (55, 2259, 'Vespertino', 'Presencial', 30, 0, 8, 45, 11);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (56, 2259, 'Vespertino', 'Presencial', 30, 0, 9, 30, 8);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (57, 2259, 'Vespertino', 'Presencial', 30, 0, 10, 28, 17);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (58, 2259, 'Vespertino', 'Presencial', 30, 0, 11, 9, 14);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (59, 2260, 'Vespertino', 'Presencial', 30, 0, 6, 46, 11);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (60, 2260, 'Vespertino', 'Presencial', 30, 0, 7, 35, 13);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (61, 2260, 'Vespertino', 'Presencial', 30, 0, 8, 45, 12);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (62, 2260, 'Vespertino', 'Presencial', 30, 0, 9, 39, 15);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (63, 2260, 'Vespertino', 'Presencial', 30, 0, 10, 48, 10);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (64, 2260, 'Vespertino', 'Presencial', 30, 0, 11, 38, 19);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (65, 2261, 'Vespertino', 'Presencial', 30, 0, 10, 28, 15);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (66, 2307, 'Matutino', 'Presencial', 30, 0, 12, 33, 2);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (67, 2307, 'Matutino', 'Presencial', 30, 0, 13, 25, 3);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (68, 2307, 'Matutino', 'Presencial', 30, 0, 14, 26, 14);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (69, 2307, 'Matutino', 'Presencial', 30, 0, 15, 47, 19);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (70, 2307, 'Matutino', 'Presencial', 30, 0, 16, 47, 21);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (71, 2308, 'Matutino', 'Presencial', 30, 0, 13, 1, 20);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (72, 2308, 'Matutino', 'Presencial', 30, 0, 14, 42, 22);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (73, 2308, 'Matutino', 'Presencial', 30, 0, 16, 47, 19);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (74, 2357, 'Vespertino', 'Presencial', 30, 0, 12, 37, 21);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (75, 2357, 'Vespertino', 'Presencial', 30, 0, 13, 40, 21);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (76, 2357, 'Vespertino', 'Presencial', 30, 0, 14, 36, 21);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (77, 2357, 'Vespertino', 'Presencial', 30, 0, 15, 41, 20);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (78, 2357, 'Vespertino', 'Presencial', 30, 0, 16, 47, 4);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (79, 2359, 'Vespertino', 'Presencial', 30, 0, 12, 43, 21);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (80, 2359, 'Vespertino', 'Presencial', 30, 0, 13, 44, 20);
INSERT INTO grupo (id_grupo, clave_grupo, turno, modalidad, cupo, inscritos, id_materia, id_profesor, id_aula) VALUES (81, 2359, 'Vespertino', 'Presencial', 30, 0, 15, 36, 21);

-- =====================================================================
-- DATOS: GRUPO_HORARIO (bloques de horario de cada grupo)
-- =====================================================================
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (1, 1, 50);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (2, 1, 3);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (3, 2, 26);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (4, 2, 73);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (5, 2, 97);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (6, 3, 52);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (7, 3, 5);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (8, 4, 34);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (9, 4, 81);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (10, 4, 101);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (11, 5, 48);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (12, 5, 1);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (13, 6, 32);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (14, 6, 79);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (15, 7, 62);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (16, 7, 15);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (17, 8, 36);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (18, 8, 83);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (19, 8, 104);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (20, 9, 57);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (21, 9, 10);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (22, 10, 64);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (23, 10, 17);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (24, 11, 44);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (25, 11, 91);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (26, 11, 110);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (27, 12, 39);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (28, 12, 86);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (29, 13, 42);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (30, 13, 89);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (31, 14, 26);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (32, 14, 73);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (33, 14, 97);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (34, 15, 28);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (35, 15, 75);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (36, 15, 99);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (37, 16, 23);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (38, 16, 70);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (39, 16, 95);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (40, 17, 49);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (41, 17, 2);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (42, 18, 52);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (43, 18, 5);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (44, 19, 102);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (45, 20, 34);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (46, 20, 81);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (47, 20, 101);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (48, 21, 26);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (49, 21, 73);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (50, 21, 97);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (51, 22, 27);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (52, 22, 74);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (53, 22, 98);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (54, 23, 52);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (55, 23, 5);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (56, 24, 23);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (57, 24, 70);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (58, 24, 95);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (59, 25, 48);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (60, 25, 1);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (61, 26, 28);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (62, 26, 75);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (63, 26, 99);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (64, 27, 24);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (65, 27, 71);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (66, 27, 96);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (67, 28, 55);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (68, 28, 8);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (69, 29, 35);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (70, 29, 82);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (71, 29, 103);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (72, 30, 34);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (73, 30, 81);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (74, 30, 101);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (75, 31, 26);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (76, 31, 73);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (77, 31, 97);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (78, 32, 55);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (79, 32, 8);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (80, 33, 37);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (81, 33, 84);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (82, 34, 33);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (83, 34, 80);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (84, 34, 100);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (85, 35, 25);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (86, 35, 72);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (87, 36, 49);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (88, 36, 2);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (89, 37, 51);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (90, 37, 4);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (91, 38, 33);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (92, 38, 80);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (93, 38, 100);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (94, 39, 30);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (95, 39, 77);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (96, 40, 53);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (97, 40, 6);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (98, 41, 57);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (99, 41, 10);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (100, 42, 60);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (101, 42, 13);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (102, 43, 66);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (103, 43, 19);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (104, 44, 43);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (105, 44, 90);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (106, 44, 109);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (107, 45, 69);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (108, 45, 22);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (109, 46, 46);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (110, 46, 93);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (111, 47, 42);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (112, 47, 89);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (113, 47, 108);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (114, 48, 36);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (115, 48, 83);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (116, 48, 104);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (117, 49, 67);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (118, 49, 20);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (119, 50, 45);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (120, 50, 92);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (121, 50, 111);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (122, 51, 40);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (123, 51, 87);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (124, 51, 106);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (125, 52, 63);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (126, 52, 16);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (127, 53, 46);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (128, 53, 93);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (129, 53, 112);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (130, 54, 69);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (131, 54, 22);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (132, 55, 66);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (133, 55, 19);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (134, 56, 41);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (135, 56, 88);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (136, 56, 107);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (137, 57, 58);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (138, 57, 11);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (139, 58, 44);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (140, 58, 91);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (141, 59, 44);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (142, 59, 91);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (143, 59, 110);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (144, 60, 65);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (145, 60, 18);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (146, 61, 69);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (147, 61, 22);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (148, 62, 47);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (149, 62, 94);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (150, 63, 56);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (151, 63, 9);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (152, 64, 61);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (153, 64, 14);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (154, 65, 56);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (155, 65, 9);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (156, 66, 31);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (157, 66, 78);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (158, 67, 54);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (159, 67, 7);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (160, 68, 29);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (161, 68, 76);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (162, 69, 28);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (163, 69, 75);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (164, 69, 99);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (165, 70, 24);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (166, 70, 71);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (167, 70, 96);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (168, 71, 26);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (169, 71, 73);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (170, 71, 97);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (171, 72, 38);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (172, 72, 85);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (173, 72, 105);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (174, 73, 26);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (175, 73, 73);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (176, 73, 97);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (177, 74, 59);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (178, 74, 12);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (179, 75, 42);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (180, 75, 89);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (181, 75, 108);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (182, 76, 43);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (183, 76, 90);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (184, 76, 109);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (185, 77, 68);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (186, 77, 21);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (187, 78, 46);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (188, 78, 93);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (189, 78, 112);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (190, 79, 65);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (191, 79, 18);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (192, 80, 36);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (193, 80, 83);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (194, 80, 104);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (195, 81, 45);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (196, 81, 92);
INSERT INTO grupo_horario (id_grupo_horario, id_grupo, id_horario) VALUES (197, 81, 111);

-- =====================================================================
-- DATOS: ALUMNO (45 estudiantes de ICO - grupo 2808)
-- =====================================================================
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (1, 320184208, 'Alan Moises', 'Sánchez', 'Juárez', 'alansanchez208@aragon.unam.mx', '2003-11-25', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.61, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (2, 320239597, 'Alejandro', 'Galicia', 'López', 'alejandrogalicia97@aragon.unam.mx', '2004-07-18', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (3, 320041394, 'Alejandro', 'Ramírez', 'Balderas', 'alejandroramirez94@aragon.unam.mx', '2004-01-09', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.92, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (4, 320200461, 'Alejandro', 'Rodriguez', 'Zamorate', 'alejandrorodriguez461@aragon.unam.mx', '2004-04-13', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (5, 320227552, 'Alejandro Uriel', 'Castro', 'Pérez', 'urielcastro52@aragon.unam.mx', '2004-06-01', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (6, 320308945, 'Alfonso', 'Castañeda', 'Alvarez', 'alfonsoalvarez45@aragon.unam.mx', '2004-05-23', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (7, 320194524, 'Andrea', 'Ramírez', 'Gonzalez', 'andrearamirez24@aragon.unam.mx', '2004-10-24', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.5, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (8, 320126802, 'Andrea', 'Robles', 'Guerrero', 'andrearobles02@aragon.unam.mx', '2003-11-28', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 9.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (9, 320320361, 'Angel Emmanuel', 'Reyes', 'Romero', 'angelreyes361@aragon.unam.mx', '2004-08-19', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (10, 320236273, 'Armando', 'López', 'González', 'armandolopez73@unam.unam.mx', '2003-12-17', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.78, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (11, 320321492, 'Arturo Eduardo', 'Leon', 'Magdaleno', 'arturoleon320@aragon.unam.mx', '2004-06-06', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (12, 320002791, 'Bruno Alejandro', 'Cuecapan', 'García', 'brunocuecapan91@aragon.unam.mx', '2004-03-20', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 9.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (13, 320123859, 'Camila Simone', 'Chavez', 'Ramirez', 'camilachavez320@aragon.unam.mx', '2004-03-04', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (14, 423001806, 'Carlos Alberto', 'De La Cruz', 'Castelan', 'carloscastelan2003@aragon.unam.mc', '2003-10-25', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.65, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (15, 423054723, 'Cesar', 'Venancio', 'Martinez', 'cesarvenancio23@aragon.unam.mx', '2003-11-16', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.04, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (16, 320147984, 'Edgar Ivan', 'Hernandez', 'Castellanos', 'ivancastellanos84@aragon.unam.mx', '2006-07-31', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.65, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (17, 320311987, 'Eduardo', 'Domínguez', 'Cuapio', 'eduardocuapio87@aragon.unam.mx', '2004-03-09', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (18, 320327205, 'Eduardo', 'Pomposo', 'Ortiz', 'eldelpalenque@aragon.unam.mx', '2003-11-28', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.23, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (19, 320060221, 'Fernanda Aketzalli', 'Perez', 'Rodriguez', 'aketzallirodriguez21@aragon.unam.mx', '2003-04-27', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 3.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (20, 320053690, 'Fernando Karam', 'Soriano', 'Morales', 'karamsoriano90@aragon.unam.mx', '2003-03-12', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (21, 320262793, 'Hans Eduardo', 'Ruiz', 'Percastregui', 'hansruiz93@aragon.unam.mx', '2004-11-07', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 9.11, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (22, 320207123, 'Ignacio Alberto', 'Ruiz', 'Alejandro', 'ignacioruiz320@aragon.unam.mx', '2004-03-21', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 9.41, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (23, 114001126, 'Jesús', 'Garcia', 'Muñoz', 'jesusgarcia114@aragon.unam.mx', '2001-04-12', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (24, 320006926, 'Jesús Armando', 'Rivera', 'Rodríguez', 'armandorivera26@aragon.unam.mx', '2004-07-06', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.57, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (25, 320208199, 'Jesus Eduardo', 'Diaz', 'Pompa', 'eduardodiaz99@aragon.unam.mx', '2004-11-22', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.87, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (26, 320105005, 'Jonathan Alberto', 'Salinas', 'Sánchez', 'jonathansalinas@aragon.unam.mx', '2004-05-10', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (27, 320102891, 'José Arturo', 'Pedraza', 'Cruz', 'arturopedraza91@aragon.unam.mx', '2004-04-14', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.91, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (28, 320326923, 'Josué Alejandro', 'Pérez', 'Lozano', 'josueperez23@aragon.unam.mx', '2004-04-01', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.79, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (29, 423045260, 'Julio', 'Zacaria', 'Vital', 'juliozacaria60@aragon.unam.mx', '2002-12-10', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (30, 320132687, 'Kaory Marlene', 'Ocampo', 'Canales', 'kaorycanales87@aragon.unam.mx', '2004-12-27', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (31, 320169953, 'Kelly Jocelyn', 'Aramburo', 'Gonzalez', 'kellyaramburo953@aragon.unam.mx', '2004-04-11', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (32, 320107889, 'Luis Ricardo', 'Vega', 'Hernandez', 'luisvega89@aragon.unam.mx', '2003-08-21', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.45, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (33, 423110249, 'Michelle Denise', 'Padilla', 'Torres', 'denisetorres49@aragon.unam.mx', '2004-11-14', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (34, 320076910, 'Moisés', 'Mares', 'Martínez', 'moisesmares910@aragon.unam.mx', '2004-01-21', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 7.94, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (35, 320108817, 'Moises Daniel', 'Zayas', 'Rios', 'danielzayas17@aragon.unam.mx', '2004-09-04', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 9.41, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (36, 320239834, 'Pablo Isaías', 'Martínez', 'Leyva', 'pabloleyva34@aragon.unam.mx', '2004-02-28', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (37, 423001112, 'Pamela', 'Ramírez', 'Arevalo', 'pamelaarevalo12@aragon.unam.mx', '2002-08-02', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 9.77, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (38, 320041394, 'Paulina', 'Avila', 'Téllez', 'paulinaavila96@aragon.unam.mx', '2004-08-07', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (39, 320187618, 'Said Eduardo', 'Lopez', 'Garcia', 'saidlopez618@aragon.unam.mx', '2004-06-01', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (40, 320232804, 'Samantha Agali', 'Hernández', 'Ramírez', 'agalihernandez04@aragon.unam.mx', '2004-10-10', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 9.05, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (41, 320113240, 'Santiago Antonio', 'Dueñas', 'Salas', 'santiagosalas@aragon.unam.mx', '1990-05-17', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.7, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (42, 320374373, 'Tristán Javier', 'Cruz', 'Hernández', 'cruz.hernandez.javier@aragon.unam.mx', '2003-07-12', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 5.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (43, 320167408, 'Uriel Jefté', 'Aguirre', 'Rivera', 'urielaguirre09@aragon.unam.mx', '2004-11-23', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 9.0, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (44, 320265024, 'Xaili Ximena', 'Marcial', 'Martinez', 'xailimarcial24@aragon.unam.mx', '2003-07-25', 2023, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 8.12, 1);
INSERT INTO alumno (id_alumno, matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES (45, 418090732, 'Yenifer', 'Quintero', 'Tolentino', 'yeniferquintero32@aragon.unam.mx', '2003-01-27', 2022, 'Matutino', 8, 'Escolarizado', 'Activo', 1, 9.36, 1);

-- Alumnos demo de 1°, 2° y 3° semestre (para probar inscripciones)
INSERT INTO alumno (matricula, nombre, ap_paterno, ap_materno, correo, fecha_nacimiento, generacion, turno, semestre, sistema, estado, estatus_pago, promedio, id_carrera) VALUES
(425001001, 'Ana Sofia',    'Lopez',    'Hernandez', 'analopez01@aragon.unam.mx',    '2006-03-15', 2025, 'Matutino', 1, 'Escolarizado', 'Activo', 1, 0.00, 1),
(425001002, 'Bruno',        'Martinez', 'Cruz',      'brunomartinez02@aragon.unam.mx','2006-07-22', 2025, 'Matutino', 1, 'Escolarizado', 'Activo', 1, 0.00, 1),
(424002001, 'Carla',        'Gomez',    'Reyes',     'carlagomez01@aragon.unam.mx',   '2005-01-10', 2024, 'Matutino', 2, 'Escolarizado', 'Activo', 1, 8.50, 1),
(424002002, 'Diego',        'Soto',     'Vargas',    'diegosoto02@aragon.unam.mx',    '2005-09-30', 2024, 'Vespertino', 2, 'Escolarizado', 'Activo', 1, 7.80, 1),
(423003001, 'Elena',        'Ortiz',    'Mendoza',   'elenaortiz01@aragon.unam.mx',   '2004-05-18', 2023, 'Matutino', 3, 'Escolarizado', 'Activo', 1, 9.10, 1),
(423003002, 'Fernando',     'Ruiz',     'Cabrera',   'fernandoruiz02@aragon.unam.mx', '2004-11-02', 2023, 'Vespertino', 3, 'Escolarizado', 'Activo', 1, 8.20, 1);


-- =====================================================================
-- INDICES PARA OPTIMIZAR BUSQUEDAS DESDE LA UI
-- =====================================================================
CREATE INDEX idx_alumno_nombre    ON alumno(nombre, ap_paterno);
CREATE INDEX idx_alumno_semestre  ON alumno(semestre);
CREATE INDEX idx_profesor_nombre  ON profesor(nombre, ap_paterno);
CREATE INDEX idx_materia_nombre   ON materia(nombre);
CREATE INDEX idx_materia_semestre ON materia(semestre);
CREATE INDEX idx_grupo_clave      ON grupo(clave_grupo);
CREATE INDEX idx_aula_clave       ON aula(clave_aula);

-- =====================================================================
-- VISTA: detalle completo de oferta academica (para CRUD y consultas)
-- =====================================================================
CREATE OR REPLACE VIEW v_oferta AS
SELECT
    g.id_grupo,
    g.clave_grupo,
    m.id_materia,
    m.clave_materia,
    m.nombre   AS materia,
    m.semestre,
    m.creditos,
    m.tipo,
    ae.nombre_area AS area,
    CONCAT(p.nombre,' ',p.ap_paterno,' ',p.ap_materno) AS profesor,
    a.clave_aula AS aula,
    g.turno,
    g.cupo,
    g.inscritos,
    (g.cupo - g.inscritos) AS disponibles
FROM grupo g
JOIN materia m       ON m.id_materia  = g.id_materia
JOIN profesor p      ON p.id_profesor = g.id_profesor
JOIN aula a          ON a.id_aula     = g.id_aula
JOIN area_estudio ae ON ae.id_area    = m.id_area;
