-- ==============================================
-- EJERCICIO 1: CONTROL BÁSICO DE TRANSACCIONES
-- ==============================================

SET SERVEROUTPUT ON;

BEGIN
  -- Aumentar salario en 10% para empleados del departamento 90
  UPDATE employee
  SET salary = salary * 1.10
  WHERE department_id = 90;

  -- Crear SAVEPOINT
  SAVEPOINT punto1;

  -- Aumentar salario en 5% para empleados del departamento 60
  UPDATE employee
  SET salary = salary * 1.05
  WHERE department_id = 60;

  -- Revertir al SAVEPOINT punto1
  ROLLBACK TO punto1;

  -- Confirmar cambios finales
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Transacción completada con COMMIT.');
END;
/
SELECT employee_id, department_id, salary
FROM employee
WHERE department_id IN (60, 90);

--Preguntas:
--a. ¿Qué departamento mantuvo los cambios?
--El departamento 90 mantiene los cambios.
--b. ¿Qué efecto tuvo el ROLLBACK parcial?
--El ROLLBACK parcial revierte solo lo hecho después del SAVEPOINT.
--c. ¿Qué ocurriría si se ejecutara ROLLBACK sin especificar SAVEPOINT?
--Si haces ROLLBACK sin SAVEPOINT, se revierten todos los cambios.



-- ==============================================
-- EJERCICIO 2: CONTROL BÁSICO DE TRANSACCIONES
-- ==============================================


UPDATE employee
SET salary = salary + 500
WHERE employee_id = 103;

ROLLBACK; 

/*Preguntas:
a. ¿Por qué la segunda sesión quedó bloqueada?
La segunda sesión se bloqueó porque la primera tenía el registro bloqueado (sin COMMIT).
b. ¿Qué comando libera los bloqueos?
El comando que libera bloqueos es COMMIT o ROLLBACK.
c. ¿Qué vistas del diccionario permiten verificar sesiones bloqueadas?
Vistas útiles: V$LOCK, V$SESSION, DBA_BLOCKERS, DBA_WAITERS.
 */

-- ===============================================
-- EJERCICIO 3: TRANSFERENCIA DE EMPLEADO CON HISTORIAL
-- ===============================================
SET SERVEROUTPUT ON;

DECLARE
    v_emp_id      employees.employee_id%TYPE := 104;
    v_new_dept_id employees.department_id%TYPE := 110;
    v_old_dept_id employees.department_id%TYPE;
    v_job_id      employees.job_id%TYPE;
    v_start_date  job_history.start_date%TYPE;
BEGIN
    
    SELECT department_id, job_id, hire_date
    INTO v_old_dept_id, v_job_id, v_start_date
    FROM employees
    WHERE employee_id = v_emp_id;

   
    UPDATE employees
    SET department_id = v_new_dept_id
    WHERE employee_id = v_emp_id;

    
    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (v_emp_id, v_start_date, SYSDATE, v_job_id, v_old_dept_id);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transferencia completada correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en la transacción: ' || SQLERRM);
END;
/

SELECT employee_id, department_id FROM employee WHERE employee_id = 104;
SELECT * FROM job_history WHERE employee_id = 104;

/*Preguntas:
a. ¿Por qué se debe garantizar la atomicidad entre las dos operaciones?
Se garantiza atomicidad porque ambas operaciones (update e insert) deben ocurrir juntas.
b. ¿Qué pasaría si se produce un error antes del COMMIT?
Si hay error antes del COMMIT → se hace ROLLBACK.
c. ¿Cómo se asegura la integridad entre EMPLOYEES y JOB_HISTORY?
La integridad se asegura por claves foráneas (employee_id y department_id).
*/

-- ============================================
-- EJERCICIO 4: SAVEPOINT Y REVERSIÓN PARCIAL
-- ============================================

SET SERVEROUTPUT ON;

BEGIN
    
    UPDATE employee
    SET salary = salary * 1.08
    WHERE department_id = 100;
    SAVEPOINT A;

    
    UPDATE employee
    SET salary = salary * 1.05
    WHERE department_id = 80;
    SAVEPOINT B;

  
    DELETE FROM employee
    WHERE department_id = 50;

   
    ROLLBACK TO B;

    -- Confirmar cambios
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Transacción completada con reversión parcial.');
END;
/

/*Preguntas:
a. ¿Qué cambios quedan persistentes?
Los cambios hasta el SAVEPOINT B permanecen (depto 100 y 80).
b. ¿Qué sucede con las filas eliminadas?
Las filas eliminadas del depto 50 fueron revertidas.
c. ¿Cómo puedes verificar los cambios antes y después del COMMIT? 
Puedes verificar antes con SELECT sin COMMIT y luego después del COMMIT.*/










