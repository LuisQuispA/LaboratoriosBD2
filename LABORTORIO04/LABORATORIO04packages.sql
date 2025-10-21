SET SERVEROUTPUT ON

-- ============================================
-- TABLAS NUEVAS
-- ============================================

-- 1. REGIONES
CREATE TABLE Region (
  region_id NUMBER PRIMARY KEY,
  region_name VARCHAR2(50)
);

-- 2. LOCATIONS
CREATE TABLE Location (
  location_id NUMBER PRIMARY KEY,
  city VARCHAR2(50),
  region_id NUMBER REFERENCES Region(region_id)
);

-- 3. DEPARTAMENTOS
CREATE TABLE Department (
  department_id NUMBER PRIMARY KEY,
  department_name VARCHAR2(50),
  location_id NUMBER REFERENCES Location(location_id)
);

-- 4. TRABAJOS
CREATE TABLE Job (
  job_id NUMBER PRIMARY KEY,
  job_title VARCHAR2(50),
  min_salary NUMBER,
  max_salary NUMBER
);

-- 5. EMPLEADOS
CREATE TABLE Employee (
  employee_id NUMBER PRIMARY KEY,
  first_name VARCHAR2(50),
  last_name VARCHAR2(50),
  hire_date DATE,
  job_id NUMBER REFERENCES Job(job_id),
  salary NUMBER,
  department_id NUMBER REFERENCES Department(department_id)
);

-- 6. HISTORIAL DE PUESTOS
CREATE TABLE Job_History (
  history_id NUMBER PRIMARY KEY,
  employee_id NUMBER REFERENCES Employee(employee_id),
  start_date DATE,
  end_date DATE,
  old_job_id NUMBER,
  new_job_id NUMBER
);

CREATE TABLE Horario (
  dia_sem VARCHAR2(10),
  turno VARCHAR2(10),
  hora_inicio DATE,
  hora_termino DATE
);

CREATE TABLE Empleado_Horario (
  dia_sem VARCHAR2(10),
  turno VARCHAR2(10),
  employee_id NUMBER
);

CREATE TABLE Asistencia_Empleado (
  employee_id NUMBER,
  dia_sem VARCHAR2(10),
  fecha_real DATE,
  hora_inicio_real DATE,
  hora_termino_real DATE
);

CREATE TABLE Capacitacion (
  id_cap NUMBER PRIMARY KEY,
  nombre VARCHAR2(100),
  horas NUMBER,
  descripcion VARCHAR2(400)
);

CREATE TABLE EmpleadoCapacitacion (
  employee_id NUMBER REFERENCES Employee(employee_id),
  id_cap NUMBER REFERENCES Capacitacion(id_cap)
);

CREATE TABLE Inasistencias (
  employee_id NUMBER,
  fecha DATE,
  motivo VARCHAR2(100)
);

-- ============================================
-- INSERTS DE DATOS
-- ============================================

INSERT INTO Region VALUES (1, 'América');
INSERT INTO Region VALUES (2, 'Europa');

INSERT INTO Location VALUES (1, 'Lima', 1);
INSERT INTO Location VALUES (2, 'Madrid', 2);

INSERT INTO Department VALUES (1, 'Ventas', 1);
INSERT INTO Department VALUES (2, 'Finanzas', 2);

INSERT INTO Job VALUES (1, 'Vendedor', 1200, 2500);
INSERT INTO Job VALUES (2, 'Contador', 2000, 3500);
INSERT INTO Job VALUES (3, 'Gerente', 4000, 7000);

INSERT INTO Employee VALUES (1, 'Luis', 'Quispe', TO_DATE('2020-01-10','YYYY-MM-DD'), 1, 1800, 1);
INSERT INTO Employee VALUES (2, 'Ana', 'Torres', TO_DATE('2021-03-12','YYYY-MM-DD'), 2, 3200, 2);
INSERT INTO Employee VALUES (3, 'Carlos', 'Rojas', TO_DATE('2022-07-05','YYYY-MM-DD'), 1, 1500, 1);
INSERT INTO Employee VALUES (4, 'Marta', 'Luna', TO_DATE('2019-09-01','YYYY-MM-DD'), 3, 6500, 2);

INSERT INTO Job_History VALUES (1, 1, TO_DATE('2020-01-10','YYYY-MM-DD'), TO_DATE('2021-02-01','YYYY-MM-DD'), 1, 2);
INSERT INTO Job_History VALUES (2, 2, TO_DATE('2021-03-12','YYYY-MM-DD'), TO_DATE('2022-06-01','YYYY-MM-DD'), 2, 3);
INSERT INTO Job_History VALUES (3, 3, TO_DATE('2022-07-05','YYYY-MM-DD'), TO_DATE('2023-08-10','YYYY-MM-DD'), 1, 2);

INSERT INTO Horario VALUES ('Lunes', 'Mañana', TO_DATE('08:00','HH24:MI'), TO_DATE('16:00','HH24:MI'));
INSERT INTO Horario VALUES ('Martes', 'Mañana', TO_DATE('08:00','HH24:MI'), TO_DATE('16:00','HH24:MI'));

INSERT INTO Empleado_Horario VALUES ('Lunes','Mañana',1);
INSERT INTO Empleado_Horario VALUES ('Martes','Mañana',1);
INSERT INTO Empleado_Horario VALUES ('Lunes','Mañana',2);
INSERT INTO Empleado_Horario VALUES ('Martes','Mañana',2);

INSERT INTO Capacitacion VALUES (1,'Liderazgo',10,'Curso de liderazgo empresarial');
INSERT INTO Capacitacion VALUES (2,'Ventas Efectivas',8,'Curso de ventas y atención al cliente');

INSERT INTO EmpleadoCapacitacion VALUES (1,1);
INSERT INTO EmpleadoCapacitacion VALUES (2,2);

-- ============================================
-- TRIGGERS
-- ============================================

CREATE OR REPLACE TRIGGER trg_check_asistencia
BEFORE INSERT OR UPDATE ON Asistencia_Empleado
FOR EACH ROW
DECLARE
  v_dia VARCHAR2(10);
BEGIN
  v_dia := TRIM(TO_CHAR(:NEW.fecha_real,'Day','NLS_DATE_LANGUAGE=SPANISH'));
  IF UPPER(v_dia) != UPPER(:NEW.dia_sem) THEN
    RAISE_APPLICATION_ERROR(-20001,'La fecha no corresponde al día indicado');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_check_salary_job
BEFORE INSERT OR UPDATE ON Employee
FOR EACH ROW
DECLARE
  vmin NUMBER; vmax NUMBER;
BEGIN
  SELECT min_salary, max_salary INTO vmin, vmax FROM Job WHERE job_id=:NEW.job_id;
  IF :NEW.salary < vmin OR :NEW.salary > vmax THEN
    RAISE_APPLICATION_ERROR(-20003,'Salario fuera del rango del puesto');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_inasistencia
BEFORE INSERT ON Asistencia_Empleado
FOR EACH ROW
DECLARE
  v_prog_inicio DATE;
  v_dif NUMBER;
BEGIN
  SELECT h.hora_inicio INTO v_prog_inicio
  FROM Horario h
  WHERE h.dia_sem = :NEW.dia_sem AND ROWNUM = 1;

  v_dif := ABS((:NEW.hora_inicio_real - v_prog_inicio) * 24 * 60);
  IF v_dif > 30 THEN
    INSERT INTO Inasistencias(employee_id, fecha, motivo)
    VALUES (:NEW.employee_id, :NEW.fecha_real, 'Llegó fuera de rango +/-30min');
  END IF;
END;
/

-- ============================================
-- PAQUETE EMPLOYEE
-- ============================================

CREATE OR REPLACE PACKAGE pkg_employee AS
  PROCEDURE insert_employee(p_id NUMBER, p_fname VARCHAR2, p_lname VARCHAR2, p_hire DATE, p_job NUMBER, p_salary NUMBER, p_dept NUMBER);
  PROCEDURE update_employee(p_id NUMBER, p_salary NUMBER);
  PROCEDURE delete_employee(p_id NUMBER);
  PROCEDURE get_employee_by_id(p_id NUMBER);
  PROCEDURE empleados_mas_rotacion;
  FUNCTION promedio_contrataciones RETURN NUMBER;
  PROCEDURE gastos_por_region;
  FUNCTION tiempo_servicio RETURN NUMBER;
  FUNCTION horas_laboradas(p_emp NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER;
  FUNCTION horas_faltadas(p_emp NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER;
  PROCEDURE sueldo_mensual(p_mes NUMBER, p_anio NUMBER);
END pkg_employee;
/

CREATE OR REPLACE PACKAGE BODY pkg_employee AS

  PROCEDURE insert_employee(p_id NUMBER, p_fname VARCHAR2, p_lname VARCHAR2, p_hire DATE, p_job NUMBER, p_salary NUMBER, p_dept NUMBER) IS
  BEGIN
    INSERT INTO Employee VALUES (p_id,p_fname,p_lname,p_hire,p_job,p_salary,p_dept);
  END;

  PROCEDURE update_employee(p_id NUMBER, p_salary NUMBER) IS
  BEGIN
    UPDATE Employee SET salary=p_salary WHERE employee_id=p_id;
  END;

  PROCEDURE delete_employee(p_id NUMBER) IS
  BEGIN
    DELETE FROM Employee WHERE employee_id=p_id;
  END;

  PROCEDURE get_employee_by_id(p_id NUMBER) IS
    v_fname Employee.first_name%TYPE;
    v_lname Employee.last_name%TYPE;
  BEGIN
    SELECT first_name,last_name INTO v_fname,v_lname FROM Employee WHERE employee_id=p_id;
    DBMS_OUTPUT.PUT_LINE('Empleado: '||v_fname||' '||v_lname);
  END;

  PROCEDURE empleados_mas_rotacion IS
  BEGIN
    FOR r IN (
      SELECT e.employee_id,e.last_name,e.first_name,e.job_id,j.job_title,COUNT(jh.history_id) AS cambios
      FROM Employee e
      JOIN Job j ON e.job_id=j.job_id
      LEFT JOIN Job_History jh ON e.employee_id=jh.employee_id
      GROUP BY e.employee_id,e.last_name,e.first_name,e.job_id,j.job_title
      ORDER BY COUNT(jh.history_id) DESC FETCH FIRST 4 ROWS ONLY
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(r.employee_id||' '||r.last_name||' '||r.first_name||' '||r.job_title||' Cambios:'||r.cambios);
    END LOOP;
  END;

  FUNCTION promedio_contrataciones RETURN NUMBER IS
    v_total NUMBER:=0;
  BEGIN
    FOR r IN (
      SELECT TO_CHAR(hire_date,'Month') mes, ROUND(COUNT(*) / COUNT(DISTINCT TO_CHAR(hire_date,'YYYY')),2) promedio
      FROM Employee
      GROUP BY TO_CHAR(hire_date,'Month')
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(r.mes||' -> '||r.promedio);
      v_total:=v_total+1;
    END LOOP;
    RETURN v_total;
  END;

  PROCEDURE gastos_por_region IS
  BEGIN
    FOR r IN (
      SELECT r.region_name, SUM(e.salary) total_salarios, COUNT(e.employee_id) total_empleados, MIN(e.hire_date) mas_antiguo
      FROM Employee e
      JOIN Department d ON e.department_id=d.department_id
      JOIN Location l ON d.location_id=l.location_id
      JOIN Region r ON l.region_id=r.region_id
      GROUP BY r.region_name
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(r.region_name||' -> '||r.total_salarios||' / Empleados:'||r.total_empleados||' / Antiguo:'||r.mas_antiguo);
    END LOOP;
  END;

  FUNCTION tiempo_servicio RETURN NUMBER IS
    v_total_vac NUMBER:=0;
    v_anios NUMBER;
  BEGIN
    FOR r IN (SELECT employee_id, FLOOR(MONTHS_BETWEEN(SYSDATE,hire_date)/12) anios FROM Employee) LOOP
      DBMS_OUTPUT.PUT_LINE('Empleado '||r.employee_id||' -> '||r.anios||' años');
      v_total_vac:=v_total_vac + r.anios;
    END LOOP;
    RETURN v_total_vac;
  END;

  FUNCTION horas_laboradas(p_emp NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER IS
    v_horas NUMBER:=0;
  BEGIN
    SELECT SUM((hora_termino_real - hora_inicio_real)*24)
    INTO v_horas
    FROM Asistencia_Empleado
    WHERE employee_id=p_emp AND EXTRACT(MONTH FROM fecha_real)=p_mes AND EXTRACT(YEAR FROM fecha_real)=p_anio;
    RETURN NVL(v_horas,0);
  END;

  FUNCTION horas_faltadas(p_emp NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER IS
    v_horas NUMBER:=0;
  BEGIN
    SELECT COUNT(*)*8 INTO v_horas
    FROM Inasistencias
    WHERE employee_id=p_emp AND EXTRACT(MONTH FROM fecha)=p_mes AND EXTRACT(YEAR FROM fecha)=p_anio;
    RETURN NVL(v_horas,0);
  END;

  PROCEDURE sueldo_mensual(p_mes NUMBER, p_anio NUMBER) IS
    v_horas NUMBER; v_faltas NUMBER; v_sueldo NUMBER;
  BEGIN
    FOR r IN (SELECT * FROM Employee) LOOP
      v_horas := horas_laboradas(r.employee_id,p_mes,p_anio);
      v_faltas := horas_faltadas(r.employee_id,p_mes,p_anio);
      v_sueldo := r.salary * (v_horas/(v_horas+v_faltas));
      DBMS_OUTPUT.PUT_LINE(r.first_name||' '||r.last_name||' -> S/. '||ROUND(v_sueldo,2));
    END LOOP;
  END;

END pkg_employee;
/

-- ============================================
-- PAQUETE CAPACITACION
-- ============================================

CREATE OR REPLACE PACKAGE pkg_capacitacion AS
  FUNCTION total_horas_emp RETURN NUMBER;
  PROCEDURE listado_capacitaciones;
END pkg_capacitacion;
/

CREATE OR REPLACE PACKAGE BODY pkg_capacitacion AS

  FUNCTION total_horas_emp RETURN NUMBER IS
    v_total NUMBER:=0;
  BEGIN
    FOR r IN (
      SELECT e.employee_id,SUM(c.horas) total
      FROM EmpleadoCapacitacion ec
      JOIN Employee e ON ec.employee_id=e.employee_id
      JOIN Capacitacion c ON ec.id_cap=c.id_cap
      GROUP BY e.employee_id
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Empleado '||r.employee_id||' -> '||r.total||' horas');
      v_total:=v_total+r.total;
    END LOOP;
    RETURN v_total;
  END;

  PROCEDURE listado_capacitaciones IS
  BEGIN
    FOR r IN (
      SELECT c.nombre cap, e.first_name||' '||e.last_name empleado, SUM(c.horas) total
      FROM EmpleadoCapacitacion ec
      JOIN Employee e ON ec.employee_id=e.employee_id
      JOIN Capacitacion c ON ec.id_cap=c.id_cap
      GROUP BY c.nombre,e.first_name,e.last_name
      ORDER BY total DESC
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(r.cap||' - '||r.empleado||' -> '||r.total||' horas');
    END LOOP;
  END;

END pkg_capacitacion;
/
