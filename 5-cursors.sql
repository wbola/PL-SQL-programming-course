/*Stwórz kursor jawny, który w pętli WHILE wyświetli wszystkie rekordy z tabeli REGIONS.*/

DECLARE
    CURSOR c_regions IS
            SELECT *
            FROM regions;

    v_regions  c_regions%ROWTYPE;
    v_tmp BOOLEAN := TRUE;
BEGIN
    OPEN c_regions;
    
    WHILE v_tmp
    LOOP
    DBMS_OUTPUT.put_line(v_regions.region_id || ', ' || v_regions.region_name);
            FETCH c_regions INTO v_regions;
            v_tmp := c_regions%FOUND;
    END LOOP;

    CLOSE c_regions;
END;
/

/*Przepisz program z zadania 1 na program korzystający z pętli FOR kursorowej i kursora niejawnego.*/

DECLARE
    CURSOR c_regions IS
            SELECT *
            FROM regions;
              
BEGIN   
    FOR i IN c_regions
    LOOP
            DBMS_OUTPUT.PUT_LINE(i.region_id || ', ' || i.region_name);  
    END LOOP;
END;
/

/*Wyjaśnij czym różni się sql%rowcount od cursor_name%rowcount

sql%rowcount jest atrybutem kursora niejawnego, wyświetla ile rekordów przetworzył kursor do tej pory, natomiast cursor_name%rowcount jest atrybutem kursora jawnego, wyświetla ile rekordów przetworzył kursor do tej pory*/

/*Sprawdź przy pomocy %rowcount czy w bazie danych istnieją departamenty, których managerowie zarabiają mniej niż 8000.*/

DECLARE
    CURSOR c_manag IS
            SELECT *
                FROM departments d
                LEFT JOIN employees e
                ON d.manager_id=e.employee_id
                WHERE e.salary<8000;
              
    v_manag  c_manag%ROWTYPE;
    v_rowcount NUMBER;
BEGIN   
    OPEN c_manag;
    LOOP
            FETCH c_manag INTO v_manag;
                EXIT WHEN c_manag%NOTFOUND;
    END LOOP;
    v_rowcount := c_manag%rowcount;
    CLOSE c_manag;
   
    DBMS_OUTPUT.PUT_LINE('Jest ich: '||v_rowcount);  
END;
/

/*Napisz jawny kursor z parametrem, który będzie zwracał listę pracowników z podanego w parametrze nazwy departamentu(department_name).*/

DECLARE
    CURSOR c_dep(in_dep_name VARCHAR2) IS
            SELECT *
            FROM employees e
            LEFT JOIN departments d
            ON e.department_id=d.department_id
            WHERE department_name = in_dep_name;
              
    v_dep  c_dep%ROWTYPE;
BEGIN   
    OPEN c_dep('Finance');
    LOOP
         FETCH c_dep INTO v_dep;
                EXIT WHEN c_dep%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE(v_dep.first_name);
    END LOOP;
    CLOSE c_dep;
END;
/

/*Rozwiń program z punktu 5 o:
podniesienie pensji pracowników o 20%
oczekiwanie na blokowanie rekordów przez maksymalnie 6 sekund
blokowanie wyłącznie rekordów z tabeli employees
wykorzystanie where current of*/

DECLARE
    CURSOR c_dep(in_dep_name VARCHAR2) IS
            SELECT *
            FROM employees e
            LEFT JOIN departments d
            ON e.department_id=d.department_id
            WHERE department_name = in_dep_name
            FOR UPDATE OF e.salary WAIT 6;
              
    v_dep  c_dep%ROWTYPE;
BEGIN   
    OPEN c_dep('Finance');
    LOOP
            FETCH c_dep INTO v_dep;
                    EXIT WHEN c_dep%NOTFOUND;
                    DBMS_OUTPUT.PUT_LINE(v_dep.first_name);

                    UPDATE employees
                    SET salary = salary * TO_NUMBER(1.2)
                    WHERE CURRENT OF c_dep;
    END LOOP;
    CLOSE c_dep;
END;
/