--1 CREAR TABLAS SEGUN LOO PEDIIDOO
CREATE TABLE EMPLEADOS (
  dni         NUMBER(8) PRIMARY KEY,
  nombre      VARCHAR2(10) NOT NULL,
  apellido1   VARCHAR2(15) NOT NULL,
  apellido2   VARCHAR2(15),
  direc1      VARCHAR2(25),
  direc2      VARCHAR2(20),
  ciudad      VARCHAR2(20),
  provincia   VARCHAR2(20),
  cod_postal  VARCHAR2(5),
  sexo        CHAR(1) CHECK (sexo IN ('H','M')),
  fecha_nac   DATE
);
CREATE TABLE DEPARTAMENTOS (
  dpto_cod    NUMBER(5) PRIMARY KEY,
  nombre_dpto VARCHAR2(30) NOT NULL UNIQUE,
  dpto_padre  NUMBER(5),
  presupuesto NUMBER NOT NULL,
  pres_actual NUMBER
);

CREATE TABLE TRABAJOS (
  trabajo_cod NUMBER(5) PRIMARY KEY,
  nombre_trab VARCHAR2(20) NOT NULL UNIQUE,
  salario_min NUMBER(10) NOT NULL,
  salario_max NUMBER(10) NOT NULL
);

CREATE TABLE UNIVERSIDADES (
  univ_cod    NUMBER(5) PRIMARY KEY,
  nombre_univ VARCHAR2(25) NOT NULL,
  ciudad      VARCHAR2(20),
  municipio   VARCHAR2(2),
  cod_postal  VARCHAR2(5)
);

CREATE TABLE HISTORIAL_LABORAL (
  empleado_dni  NUMBER(8),
  trabajo_cod   NUMBER(5),
  fecha_inicio  DATE,
  fecha_fin     DATE,
  dpto_cod      NUMBER(5),
  supervisor_dni NUMBER(8),
  CONSTRAINT pk_hist_lab PRIMARY KEY (empleado_dni, trabajo_cod, fecha_inicio),
  CONSTRAINT fk_hl_emp FOREIGN KEY (empleado_dni) REFERENCES empleados(dni),
  CONSTRAINT fk_hl_trab FOREIGN KEY (trabajo_cod) REFERENCES trabajos(trabajo_cod),
  CONSTRAINT fk_hl_dpto FOREIGN KEY (dpto_cod) REFERENCES departamentos(dpto_cod),
  CONSTRAINT fk_hl_sup FOREIGN KEY (supervisor_dni) REFERENCES empleados(dni)
);

CREATE TABLE HISTORIAL_SALARIAL (
  empleado_dni   NUMBER(8),
  trabajo_cod    NUMBER(5),
  salario        NUMBER NOT NULL,
  fecha_comienzo DATE,
  fecha_fin      DATE,
  CONSTRAINT pk_hist_sal PRIMARY KEY (empleado_dni, fecha_comienzo),
  CONSTRAINT fk_hs_emp FOREIGN KEY (empleado_dni) REFERENCES empleados(dni),
  CONSTRAINT fk_hs_trab FOREIGN KEY (trabajo_cod) REFERENCES trabajos(trabajo_cod)
);

CREATE TABLE ESTUDIOS (
  empleado_dni NUMBER(8),
  universidad  NUMBER(5),
  ano          NUMBER,
  grado        VARCHAR2(3),
  especialidad VARCHAR2(20),
  CONSTRAINT fk_est_emp FOREIGN KEY (empleado_dni) REFERENCES empleados(dni),
  CONSTRAINT fk_est_univ FOREIGN KEY (universidad) REFERENCES universidades(univ_cod)
);
--2. FORZAR SOLO HOMBRE O MUJER, YA HECHOO CON CHECK
--3 Asegurar que DEPARTAMENTOS y TRABAJOS no tengan nombres duplicados(lo incluí con UNIQUE sobre nombre_dpto y nombre_trab).
--4.Salario activo por empleado” y “un trabajo activo por empleado
CREATE UNIQUE INDEX ux_hs_unico_vigente
ON historial_salarial (CASE WHEN fecha_fin IS NULL THEN empleado_dni ELSE NULL END);

CREATE UNIQUE INDEX ux_hl_unico_vigente
ON historial_laboral (CASE WHEN fecha_fin IS NULL THEN empleado_dni ELSE NULL END);

--5. Mantener integridad referencial (FK)
--(Lo incluí en CREATE TABLE usando FOREIGN KEY para cada relación n)

--6. Agregar teléfono y celular a EMPLEADOS
ALTER TABLE empleados ADD (telefono VARCHAR2(15), celular VARCHAR2(15));

--7. Inserta filas según  lo  requerido
INSERT INTO empleados (dni, nombre, apellido1, apellido2, sexo) 
VALUES (111222, 'Sergio', 'Palma', 'Entrena', 'H');

INSERT INTO empleados (dni, nombre, apellido1, apellido2, sexo) 
VALUES (222333, 'Lucia', 'Ortega', 'Plus', 'M');
COMMIT;
INSERT INTO departamentos (dpto_cod, nombre_dpto, presupuesto, pres_actual)
VALUES (22233, 'Sistemas', 100000, 50000);
INSERT INTO historial_laboral
  (empleado_dni, trabajo_cod, fecha_inicio, fecha_fin, dpto_cod, supervisor_dni)
VALUES
  (111222,32303, TO_DATE('16/06/1996','DD/MM/YYYY'), NULL, 22233, NULL);
--8. ¿Qué ocurre si se modifica esta última fila de historial_laboral asignándole al empleado 111222 un 
--supervisor que no existe en la tabla de empleados?
--Solución: insertar primero el supervisor en EMPLEADOS o usar NULL/cambiarlas políticas FK.

--9. Borre una universidad de la tabla de UNIVERSIDADES ¿Qué le sucede a la restricción de clave ajena de la tabla ESTUDIOS?
--si Intento borrar me sale -ORA-02292: integrity constraint violated - child record found.
--Altere la definición de la tabla para que se mantenga la restricción, aunque se borre una universidad.
ALTER TABLE estudios DROP CONSTRAINT fk_est_univ;

ALTER TABLE estudios
ADD CONSTRAINT fk_est_univ
FOREIGN KEY (universidad) REFERENCES universidades(univ_cod) ON DELETE SET NULL;

--10.Añada una restricción que obligue a que las personas que hayan introducido la CIUDAD deban tener el campo COD_POSTAL a NOT NULL. ¿Q
--¿Qué ocurre con las filas ya introducidas?
ALTER TABLE empleados
ADD CONSTRAINT chk_ciudad_codpostal CHECK (ciudad IS NULL OR cod_postal IS NOT NULL);

--11. Añadir VALORACIÓN en EMPLEADOS con valor por defecto 5 (1..10)
ALTER TABLE empleados ADD (valoracion NUMBER(2) DEFAULT 5);

ALTER TABLE empleados ADD CONSTRAINT chk_valoracion CHECK (valoracion BETWEEN 1 AND 10);

--12. Quitar la restricción NOT NULL de NOMBRE
ALTER TABLE empleados MODIFY (nombre VARCHAR2(10) NULL);

--13. Modificar direc1 a longitud 40
ALTER TABLE empleados MODIFY (direc1 VARCHAR2(40));

--14.¿Podría modificar el tipo de datos del atributo FECHA_NAC de la tabla EMPLEADOS Y convertirla a tipo cadena?
--No conviene hacer ALTER TABLE ... MODIFY fecha_nac VARCHAR2(...) si hay datos.
ALTER TABLE empleados ADD (fecha_nac_txt VARCHAR2(20));

UPDATE empleados SET fecha_nac_txt = TO_CHAR(fecha_nac, 'YYYY-MM-DD');
COMMIT;

--15.Cambiar la clave primaria de EMPLEADOS al NOMBRE y los dos APELLIDOS.
SELECT nombre, apellido1, apellido2, COUNT(*) FROM empleados
GROUP BY nombre, apellido1, apellido2 HAVING COUNT(*) > 1;

--16. Crear tabla INFORMACIÓN UNIVERSITARIA con nombre completo y universidad y llenarla

CREATE TABLE informacion_universitaria AS
SELECT (e.nombre || ' ' || e.apellido1 || ' ' || NVL(e.apellido2,'')) AS nombre_completo,
       u.nombre_univ
FROM empleados e
JOIN estudios s ON e.dni = s.empleado_dni
JOIN universidades u ON s.universidad = u.univ_cod;

--18.Vista INFORMACION_EMPLEADOS con nombre completo y EDAD
CREATE OR REPLACE VIEW informacion_empleados AS
SELECT dni,
       (nombre || ' ' || apellido1 || ' ' || NVL(apellido2,'')) AS nombre_completo,
       TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_nac)/12) AS edad
FROM empleados;
--19. Vista INFORMACION_ACTUAL = anterior + SALARIO ACTUAL
CREATE OR REPLACE VIEW informacion_actual AS
SELECT e.dni,
       (e.nombre || ' ' || e.apellido1 || ' ' || NVL(e.apellido2,'')) AS nombre_completo,
       TRUNC(MONTHS_BETWEEN(SYSDATE, e.fecha_nac)/12) AS edad,
       hs.salario
FROM empleados e
LEFT JOIN historial_salarial hs
  ON e.dni = hs.empleado_dni AND hs.fecha_fin IS NULL;

--20.Borrar todas las tablas. ¿Hay que tener en cuenta las claves ajenas a la hora de borrar las tablas?
DROP TABLE estudios CASCADE CONSTRAINTS;
DROP TABLE historial_salarial CASCADE CONSTRAINTS;
DROP TABLE historial_laboral CASCADE CONSTRAINTS;
DROP TABLE informacion_universitaria CASCADE CONSTRAINTS;
DROP TABLE empleados CASCADE CONSTRAINTS;
DROP TABLE trabajos CASCADE CONSTRAINTS;
DROP TABLE departamentos CASCADE CONSTRAINTS;
DROP TABLE universidades CASCADE CONSTRAINTS;








