/*Stwórz pakiet w schemacie KURS_PLSQL, który będzie posiadał 4 programy do zarządzania produktami w firmie:
- procedurę do dodawania/usuwania/modyfikacji  produktów(usuwanie i modyfikacja produktów powinna się odbywać na podstawie parametru product_id)
- funkcję zwracającą informacje o produktach (wszystkie kolumny z tabeli products na podstawie parametru product_id)
Nadaj uprawnienie do korzystania z pakietu użytkownikowi HR.*/


CREATE OR REPLACE PACKAGE manag_products
IS
    PROCEDURE add_products (in_product_id IN products.product_id%TYPE,
                            in_product_name IN products.product_name%TYPE);
    PROCEDURE delete_products (in_product_id IN products.product_id%TYPE);
    PROCEDURE update_products (in_product_id IN products.product_id%TYPE,
                               in_product_name IN products.product_name%TYPE);
    FUNCTION inf_products (in_product_id IN products.product_id%TYPE) RETURN products%ROWTYPE;
END manag_products;
/

CREATE OR REPLACE PACKAGE BODY manag_products
IS
    PROCEDURE add_products (in_product_id IN products.product_id%TYPE,
                            in_product_name IN products.product_name%TYPE)
    IS
    BEGIN
        INSERT INTO products (product_id, product_name) VALUES (in_product_id, in_product_name);
    END add_products;
    
    PROCEDURE delete_products (in_product_id IN products.product_id%TYPE)
    IS
    BEGIN
        DELETE FROM products WHERE product_id = in_product_id;
    END delete_products;
    
    PROCEDURE update_products (in_product_id IN products.product_id%TYPE,
                               in_product_name IN products.product_name%TYPE)
    IS
    BEGIN
        UPDATE products
        SET product_name = in_product_name
        WHERE product_id = in_product_id;
    END update_products;
    
    FUNCTION inf_products (in_product_id IN products.product_id%TYPE) RETURN products%ROWTYPE
    IS
        v_products products%ROWTYPE;
    BEGIN
        SELECT product_id 
        INTO v_products
        FROM products
        WHERE product_id = in_product_id;
        
        RETURN v_products;
    END inf_products;
END manag_products;
/

GRANT EXECUTE ON manag_products TO HR;

/*Stwórz w pakiecie przeciążoną funkcję get_high_dept_salary zwracającą najwyższą pensję w przekazywanym w parametrze id departamentu. Druga z funkcji ma dodatkowo zawierać kolejny parametr job_id, tak by zwracała najwyższą pensję w danym departamencie na danym stanowisku. 
Następnie wywołaj funkcję w dowolny sposób, tak by za pierwszym razem została użyta funkcja z 1 parametrem, w za drugim razem z dwoma.*/

CREATE OR REPLACE PACKAGE overloaded_function
IS
    FUNCTION get_high_dept_salary (in_department_id IN employees.department_id%TYPE) RETURN employees.department_id%TYPE; 
    FUNCTION get_high_dept_salary (in_department_id IN employees.department_id%TYPE, in_job_id IN employees.job_id%TYPE) RETURN employees.salary%TYPE;
END overloaded_function;
/

CREATE OR REPLACE PACKAGE BODY overloaded_function
IS
    FUNCTION get_high_dept_salary (in_department_id IN employees.department_id%TYPE) RETURN employees.department_id%TYPE
    IS
       v_salary employees.department_id%TYPE;
    BEGIN
       SELECT max(salary)
       INTO v_salary
       FROM employees
       WHERE department_id = in_department_id; 
       
       RETURN v_salary;
    END get_high_dept_salary;
    FUNCTION get_high_dept_salary (in_department_id IN employees.department_id%TYPE, in_job_id IN employees.job_id%TYPE) RETURN employees.salary%TYPE
    IS
       v_salary employees.salary%TYPE;
    BEGIN
       SELECT max(salary)
       INTO v_salary
       FROM employees
       WHERE department_id = in_department_id AND job_id = in_job_id; 
       
       RETURN v_salary;
    END get_high_dept_salary;
END overloaded_function;
/

BEGIN
    dbms_output.put_line(overloaded_function.get_high_dept_salary(206));
    dbms_output.put_line(overloaded_function.get_high_dept_salary(206,'AC_ACCOUNT'));
END;
/

/*Zmodyfikuj zadanie 2 z MODUŁU 5 w taki sposób, by obsługa błędu znajdowała się w pakiecie error_pkg.*/
CREATE OR REPLACE PACKAGE error_pkg
IS
    ex_constraint EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_constraint, -00001);
END error_pkg;
/

BEGIN
    INSERT INTO COUNTRIES(country_id, country_name) VALUES ('ML', 'Malta');
EXCEPTION
    WHEN error_pkg.ex_constraint THEN
        DBMS_OUTPUT.PUT_LINE('Zostalo naruszone ograniczenie unikatowe.');
END;
/