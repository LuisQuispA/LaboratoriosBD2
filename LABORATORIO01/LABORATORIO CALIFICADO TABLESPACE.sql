-- SEGUN EL SIZING HECHO PODEMOS CREAR LA BASE DE DATOS:
-- 1.CREACION DE LOS TABLESPACE
CREATE TABLESPACE ts_datos
DATAFILE 'C:\app\USER\product\21c\oradata\XE\ts_datos.dbf'
SIZE 100M AUTOEXTEND ON NEXT 10M MAXSIZE 200M
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT MANUAL
LOGGING;

CREATE TEMPORARY TABLESPACE ts_temp
TEMPFILE 'C:\app\USER\product\21c\oradata\XE\ts_temp.dbf'
SIZE 50M
EXTENT MANAGEMENT LOCAL;

-- 3.CREACION DE LOS TABLAS
CREATE TABLE director (
    id_director INT PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    nacionalidad VARCHAR2(50) NOT NULL,
    fecha_nacimiento DATE
) TABLESPACE ts_datos;

CREATE TABLE equipo (
    id_equipo INT PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    nacionalidad VARCHAR2(50) NOT NULL,
    id_director INT NOT NULL,
    FOREIGN KEY (id_director) REFERENCES director(id_director)
) TABLESPACE ts_datos;

CREATE TABLE ciclista (
    id_ciclista INT PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    nacionalidad VARCHAR2(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    id_equipo_actual INT NOT NULL,
    FOREIGN KEY (id_equipo_actual) REFERENCES equipo(id_equipo)
) TABLESPACE ts_datos;

CREATE TABLE contrato (
    id_contrato INT PRIMARY KEY,
    id_ciclista INT NOT NULL,
    id_equipo INT NOT NULL,
    inicio_contrato DATE NOT NULL,
    fin_contrato DATE,
    FOREIGN KEY (id_ciclista) REFERENCES ciclista(id_ciclista),
    FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo)
) TABLESPACE ts_datos;

CREATE TABLE prueba (
    id_prueba INT PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    anio NUMBER(4) NOT NULL,
    etapas NUMBER NOT NULL,
    km_totales NUMBER NOT NULL,
    id_ciclista_ganador INT,
    FOREIGN KEY (id_ciclista_ganador) REFERENCES ciclista(id_ciclista)
) TABLESPACE ts_datos;

CREATE TABLE participacion (
    id_equipo INT,
    id_prueba INT,
    puesto_final NUMBER NOT NULL,
    PRIMARY KEY (id_equipo, id_prueba),
    FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo),
    FOREIGN KEY (id_prueba) REFERENCES prueba(id_prueba)
) TABLESPACE ts_datos;

-- 3.INSERCION DE DATOS
INSERT INTO director (id_director, nombre, nacionalidad, fecha_nacimiento) 
VALUES (1, 'Juan Pérez', 'España', TO_DATE('1975-03-15','YYYY-MM-DD'));
INSERT INTO director (id_director, nombre, nacionalidad, fecha_nacimiento) 
VALUES (2, 'Chris Smith', 'Reino Unido', TO_DATE('1968-08-22','YYYY-MM-DD'));

INSERT INTO equipo (id_equipo, nombre, nacionalidad, id_director) 
VALUES (1, 'Movistar', 'España', 1);
INSERT INTO equipo (id_equipo, nombre, nacionalidad, id_director) 
VALUES (2, 'Ineos Grenadiers', 'Reino Unido', 2);

INSERT INTO ciclista (id_ciclista, nombre, nacionalidad, fecha_nacimiento, id_equipo_actual) 
VALUES (1, 'Carlos Gómez', 'Colombia', TO_DATE('1990-05-10','YYYY-MM-DD'), 1);
INSERT INTO ciclista (id_ciclista, nombre, nacionalidad, fecha_nacimiento, id_equipo_actual) 
VALUES (2, 'Luis Martínez', 'España', TO_DATE('1995-07-22','YYYY-MM-DD'), 1);
INSERT INTO ciclista (id_ciclista, nombre, nacionalidad, fecha_nacimiento, id_equipo_actual) 
VALUES (3, 'John Evans', 'Reino Unido', TO_DATE('1992-11-15','YYYY-MM-DD'), 2);

INSERT INTO contrato (id_contrato, id_ciclista, id_equipo, inicio_contrato, fin_contrato) 
VALUES (1, 1, 1, TO_DATE('2020-01-01','YYYY-MM-DD'), TO_DATE('2023-12-31','YYYY-MM-DD'));
INSERT INTO contrato (id_contrato, id_ciclista, id_equipo, inicio_contrato, fin_contrato) 
VALUES (2, 2, 1, TO_DATE('2021-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'));
INSERT INTO contrato (id_contrato, id_ciclista, id_equipo, inicio_contrato, fin_contrato) 
VALUES (3, 3, 2, TO_DATE('2020-01-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'));

INSERT INTO prueba (id_prueba, nombre, anio, etapas, km_totales, id_ciclista_ganador) 
VALUES (1, 'Tour de Francia', 2023, 21, 3400, 1);
INSERT INTO prueba (id_prueba, nombre, anio, etapas, km_totales, id_ciclista_ganador) 
VALUES (2, 'Giro de Italia', 2023, 20, 3300, 3);

INSERT INTO participacion (id_equipo, id_prueba, puesto_final) 
VALUES (1, 1, 2);
INSERT INTO participacion (id_equipo, id_prueba, puesto_final) 
VALUES (2, 1, 1);
INSERT INTO participacion (id_equipo, id_prueba, puesto_final) 
VALUES (1, 2, 3);
INSERT INTO participacion (id_equipo, id_prueba, puesto_final) 
VALUES (2, 2, 2);

-- 4. CONSULTAS

SELECT * FROM director;
SELECT * FROM equipo;
SELECT * FROM ciclista;
SELECT * FROM contrato;
SELECT * FROM prueba;
SELECT * FROM participacion;

-- Todos los ciclistas con su equipo actual
SELECT c.id_ciclista, c.nombre, c.nacionalidad, e.nombre as equipo_actual
FROM ciclista c
JOIN equipo e ON c.id_equipo_actual = e.id_equipo
ORDER BY e.nombre, c.nombre;

-- Todos los equipos con su director
SELECT e.id_equipo, e.nombre as equipo, e.nacionalidad, d.nombre as director
FROM equipo e
JOIN director d ON e.id_director = d.id_director
ORDER BY e.nombre;

SELECT c.nombre as ciclista, e.nombre as equipo, 
       con.inicio_contrato, con.fin_contrato,
       CASE 
           WHEN con.fin_contrato IS NULL OR con.fin_contrato > SYSDATE 
           THEN 'ACTIVO' 
           ELSE 'FINALIZADO' 
       END as estado_contrato
FROM contrato con
JOIN ciclista c ON con.id_ciclista = c.id_ciclista
JOIN equipo e ON con.id_equipo = e.id_equipo
ORDER BY e.nombre, c.nombre;

-- Historial completo de contratos de cada ciclista
SELECT c.nombre as ciclista, e.nombre as equipo, 
       con.inicio_contrato, con.fin_contrato,
       EXTRACT(YEAR FROM con.inicio_contrato) as año_inicio
FROM contrato con
JOIN ciclista c ON con.id_ciclista = c.id_ciclista
JOIN equipo e ON con.id_equipo = e.id_equipo
ORDER BY c.nombre, con.inicio_contrato;

-- Pruebas con su ganador y equipo del ganador
SELECT p.nombre as prueba, p.anio, p.etapas, p.km_totales,
       c.nombre as ganador, c.nacionalidad as nacionalidad_ganador,
       e.nombre as equipo_ganador
FROM prueba p
JOIN ciclista c ON p.id_ciclista_ganador = c.id_ciclista
JOIN equipo e ON c.id_equipo_actual = e.id_equipo
ORDER BY p.anio DESC, p.nombre;

-- Estructura completa: Equipos con sus ciclistas y contratos
SELECT e.nombre as equipo, d.nombre as director,
       c.nombre as ciclista, c.nacionalidad,
       con.inicio_contrato, con.fin_contrato
FROM equipo e
JOIN director d ON e.id_director = d.id_director
JOIN ciclista c ON e.id_equipo = c.id_equipo_actual
JOIN contrato con ON c.id_ciclista = con.id_ciclista AND e.id_equipo = con.id_equipo
ORDER BY e.nombre, c.nombre;
