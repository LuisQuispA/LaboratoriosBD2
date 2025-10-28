-- Tabla S (proveedores)
CREATE TABLE S (
  SNO   VARCHAR2(10) PRIMARY KEY,
  SNAME VARCHAR2(100),
  STATUS NUMBER,
  CITY  VARCHAR2(100)
);

-- Tabla P (partes)
CREATE TABLE P (
  PNO   VARCHAR2(10) PRIMARY KEY,
  PNAME VARCHAR2(100),
  COLOR VARCHAR2(50),
  WEIGHT NUMBER, -- libras
  CITY  VARCHAR2(100)
);

-- Tabla SP (envíos)
CREATE TABLE SP (
  SNO VARCHAR2(10),
  PNO VARCHAR2(10),
  QTY NUMBER,
  CONSTRAINT sp_pk PRIMARY KEY (SNO,PNO),
  CONSTRAINT fk_sp_s FOREIGN KEY (SNO) REFERENCES S(SNO),
  CONSTRAINT fk_sp_p FOREIGN KEY (PNO) REFERENCES P(PNO)
);
CREATE TABLE J (
  J_NO VARCHAR2(5) PRIMARY KEY,
  JNAME VARCHAR2(50),
  CITY VARCHAR2(50)
);

-- Tabla SPJ (Envíos a Proyectos)
CREATE TABLE SPJ (
  SNO VARCHAR2(10),
  PNO VARCHAR2(10),
  J_NO VARCHAR2(10),
  QTY NUMBER,
  PRIMARY KEY (SNO, PNO, J_NO),
  FOREIGN KEY (SNO) REFERENCES S(SNO),
  FOREIGN KEY (PNO) REFERENCES P(PNO),
  FOREIGN KEY (J_NO) REFERENCES J(J_NO)
);

-- =====================================
-- TABLA S (Suppliers)
-- =====================================
INSERT INTO S (SNO, SNAME, STATUS, CITY) VALUES ('S1', 'Smith', 20, 'London');
INSERT INTO S (SNO, SNAME, STATUS, CITY) VALUES ('S2', 'Jones', 10, 'Paris');
INSERT INTO S (SNO, SNAME, STATUS, CITY) VALUES ('S3', 'Blake', 30, 'Paris');
INSERT INTO S (SNO, SNAME, STATUS, CITY) VALUES ('S4', 'Clark', 20, 'London');
INSERT INTO S (SNO, SNAME, STATUS, CITY) VALUES ('S5', 'Adams', 30, 'Athens');

-- =====================================
-- TABLA P (Partes)
-- =====================================
INSERT INTO P (PNO, PNAME, COLOR, WEIGHT, CITY) VALUES ('P1', 'Nut',   'Red',   12, 'London');
INSERT INTO P (PNO, PNAME, COLOR, WEIGHT, CITY) VALUES ('P2', 'Bolt',  'Green', 17, 'Paris');
INSERT INTO P (PNO, PNAME, COLOR, WEIGHT, CITY) VALUES ('P3', 'Screw', 'Blue',  17, 'Rome');
INSERT INTO P (PNO, PNAME, COLOR, WEIGHT, CITY) VALUES ('P4', 'Screw', 'Red',   14, 'London');
INSERT INTO P (PNO, PNAME, COLOR, WEIGHT, CITY) VALUES ('P5', 'Cam',   'Blue',  12, 'Paris');
INSERT INTO P (PNO, PNAME, COLOR, WEIGHT, CITY) VALUES ('P6', 'Cog',   'Red',   19, 'London');

-- =====================================
-- TABLA SP (Envíos)
-- =====================================
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S1', 'P1', 300);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S1', 'P2', 200);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S1', 'P3', 400);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S1', 'P4', 200);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S1', 'P5', 100);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S1', 'P6', 100);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S2', 'P1', 300);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S2', 'P2', 400);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S3', 'P2', 200);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S4', 'P2', 200);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S4', 'P4', 300);
INSERT INTO SP (SNO, PNO, QTY) VALUES ('S4', 'P5', 400);

-- =====================================
-- TABLA J (Proyectos)
-- =====================================
INSERT INTO J (J_NO, JNAME, CITY) VALUES ('J1', 'Sorter',  'Paris');
INSERT INTO J (J_NO, JNAME, CITY) VALUES ('J2', 'Display', 'Rome');
INSERT INTO J (J_NO, JNAME, CITY) VALUES ('J3', 'OCR',     'Athens');
INSERT INTO J (J_NO, JNAME, CITY) VALUES ('J4', 'Console', 'Athens');
INSERT INTO J (J_NO, JNAME, CITY) VALUES ('J5', 'RAID',    'London');
INSERT INTO J (J_NO, JNAME, CITY) VALUES ('J6', 'EDS',     'Oslo');
INSERT INTO J (J_NO, JNAME, CITY) VALUES ('J7', 'Tape',    'London');

-- =====================================
-- TABLA SPJ (Envíos a Proyectos)
-- =====================================
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S1', 'P1', 'J1', 200);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S1', 'P1', 'J4', 700);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S2', 'P3', 'J1', 400);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S2', 'P3', 'J2', 200);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S2', 'P3', 'J3', 200);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S2', 'P3', 'J4', 500);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S2', 'P3', 'J5', 600);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S2', 'P3', 'J6', 400);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S2', 'P3', 'J7', 800);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S2', 'P5', 'J2', 100);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S3', 'P3', 'J1', 200);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S3', 'P4', 'J2', 500);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S4', 'P6', 'J3', 300);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S4', 'P6', 'J7', 300);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S5', 'P2', 'J2', 200);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S5', 'P2', 'J4', 100);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S5', 'P5', 'J5', 500);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S5', 'P5', 'J7', 100);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S5', 'P6', 'J2', 200);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S5', 'P1', 'J4', 100);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S5', 'P3', 'J4', 200);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S5', 'P4', 'J4', 800);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S5', 'P5', 'J4', 400);
INSERT INTO SPJ (SNO, PNO, J_NO, QTY) VALUES ('S5', 'P6', 'J4', 500);

-- 4.1.1 Obtenga el color y ciudad para las partes que no son de París, con un peso mayor de diez.
CREATE OR REPLACE FUNCTION f_411_color_ciudad_no_paris_mayor_10
RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT color, city
    FROM P
    WHERE city <> 'Paris'
      AND weight > 10;
  RETURN rc;
END;
/



-- 4.1.2 Para todas las partes, obtenga el número de parte y el peso de dichas partes en gramos.
CREATE OR REPLACE FUNCTION f_412_peso_en_gramos
RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
  -- 1 libra = 453.59237 gramos
BEGIN
  OPEN rc FOR
    SELECT pno,
           pweight.weight_grams
    FROM (
      SELECT pno, weight * 453.59237 AS weight_grams
      FROM P
    ) pweight;
  RETURN rc;
END;
/



-- 4.1.3 Obtenga el detalle completo de todos los proveedores.
CREATE OR REPLACE PROCEDURE sp_413_todos_proveedores(rc OUT SYS_REFCURSOR) IS
BEGIN
  OPEN rc FOR SELECT * FROM S;
END;
/




-- 4.1.4 Obtenga todas las combinaciones de proveedores y partes para aquellos proveedores y partes co-localizados.
CREATE OR REPLACE FUNCTION f_414_prov_parte_colocalizados
RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT s.sno AS supplier_no,
           s.sname AS supplier_name,
           p.pno AS part_no,
           p.pname AS part_name,
           s.city AS city
    FROM S s
    JOIN P p ON s.city = p.city;
  RETURN rc;
END;
/



-- 4.1.5 Obtenga todos los pares de nombres de ciudades de tal forma que el proveedor localizado en la primera ciudad abastece una parte almacenada en la segunda ciudad del par.
CREATE OR REPLACE FUNCTION f_415_pares_ciudades_abastece
RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT DISTINCT s.city AS ciudad_prov,
                    p.city AS ciudad_parte
    FROM S s
    JOIN SP sp ON s.sno = sp.sno
    JOIN P p ON sp.pno = p.pno;
  RETURN rc;
END;
/




-- 4.1.6 Obtenga todos los pares de número de proveedor tales que los dos proveedores del par estén co-localizados.
CREATE OR REPLACE FUNCTION f_416_pares_proveedores_colocalizados
RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT a.sno AS prov1, b.sno AS prov2, a.city
    FROM S a
    JOIN S b ON a.city = b.city
    WHERE a.sno < b.sno; -- evita duplicados (a,b) y (b,a) y evita pares iguales
  RETURN rc;
END;
/



-- 4.1.7 Obtenga el número total de proveedores.
CREATE OR REPLACE FUNCTION fn_417_total_proveedores RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM S;
  RETURN v_count;
END;
/




-- 4.1.8 Obtenga la cantidad mínima y la cantidad máxima para la parte P2.
CREATE OR REPLACE PROCEDURE sp_418_min_max_p2(min_q OUT NUMBER, max_q OUT NUMBER) IS
BEGIN
  SELECT MIN(qty), MAX(qty)
    INTO min_q, max_q
    FROM SP
   WHERE pno = 'P2';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    min_q := NULL;
    max_q := NULL;
END;
/




-- 4.1.9 Para cada parte abastecida, obtenga el número de parte y el total despachado.
CREATE OR REPLACE FUNCTION f_419_total_por_parte RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT pno, SUM(qty) AS total_despachado
    FROM SP
    GROUP BY pno;
  RETURN rc;
END;
/




-- 4.1.10 Obtenga el número de parte para todas las partes abastecidas por más de un proveedor.
CREATE OR REPLACE FUNCTION f_4110_partes_mas_un_prov RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT pno
    FROM SP
    GROUP BY pno
    HAVING COUNT(DISTINCT sno) > 1;
  RETURN rc;
END;
/




-- 4.1.11 Obtenga el nombre de proveedor para todos los proveedores que abastecen la parte P2.
CREATE OR REPLACE FUNCTION f_4111_nombres_prov_abastecen_p2 RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT DISTINCT s.sname
    FROM S s
    JOIN SP sp ON s.sno = sp.sno
    WHERE sp.pno = 'P2';
  RETURN rc;
END;
/




-- 4.1.12 Obtenga el nombre de proveedor de quienes abastecen por lo menos una parte.
CREATE OR REPLACE FUNCTION f_4112_prov_abastecen_al_menos_una RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT DISTINCT s.sname
    FROM S s
    JOIN SP sp ON s.sno = sp.sno;
  RETURN rc;
END;
/




-- 4.1.13 Obtenga el número de proveedor para los proveedores con estado menor que el máximo valor de estado en la tabla S.
CREATE OR REPLACE FUNCTION f_4113_prov_estado_menor_max RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
  v_max_status NUMBER;
BEGIN
  SELECT MAX(status) INTO v_max_status FROM S;
  OPEN rc FOR
    SELECT sno
    FROM S
    WHERE status < v_max_status;
  RETURN rc;
END;
/



-- 4.1.14 Obtenga el nombre de proveedor para los proveedores que abastecen la parte P2 (aplicar EXISTS).
CREATE OR REPLACE FUNCTION f_4114_prov_abastecen_p2_exists RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT s.sname
    FROM S s
    WHERE EXISTS (
      SELECT 1 FROM SP sp WHERE sp.sno = s.sno AND sp.pno = 'P2'
    );
  RETURN rc;
END;
/



-- 4.1.15 Obtenga el nombre de proveedor para los proveedores que no abastecen la parte P2.
CREATE OR REPLACE FUNCTION f_4115_prov_no_abastecen_p2 RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT s.sname
    FROM S s
    WHERE NOT EXISTS (
      SELECT 1 FROM SP sp WHERE sp.sno = s.sno AND sp.pno = 'P2'
    );
  RETURN rc;
END;
/



-- 4.1.16 Obtenga el nombre de proveedor para los proveedores que abastecen todas las partes.
CREATE OR REPLACE FUNCTION f_4116_prov_abastecen_todas RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
  v_total_parts NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_total_parts FROM P;

  OPEN rc FOR
    SELECT s.sname
    FROM S s
    WHERE (
      SELECT COUNT(DISTINCT sp.pno)
      FROM SP sp
      WHERE sp.sno = s.sno
    ) = v_total_parts;
  RETURN rc;
END;
/



-- 4.1.17 Obtenga el número de parte para todas las partes que pesan más de 16 libras ó son abastecidas por el proveedor S2, ó cumplen con ambos criterios.
CREATE OR REPLACE FUNCTION f_4117_partes_peso_mayor_16_o_abastecidas_por_S2 RETURN SYS_REFCURSOR IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT DISTINCT p.pno
    FROM P p
    LEFT JOIN SP sp ON p.pno = sp.pno
    WHERE p.weight > 16
       OR p.pno IN (SELECT pno FROM SP WHERE sno = 'S2');
  RETURN rc;
END;
/

