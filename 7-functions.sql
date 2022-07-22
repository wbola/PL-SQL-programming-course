/*Zamień blok anonimowy z pracy domowej z MODUŁ 5 ZADANIE 3 na funkcję o nazwie licz_bmi. Funkcja powinna zwracać wskaźnik BMI i przyjmować w parametrze wzrost i wagę.
Uwaga. W funkcji powinna się znaleźć jedynie jedna instrukcja RETURN.*/

CREATE OR REPLACE FUNCTION licz_bmi (in_wzrost IN NUMBER, in_waga IN NUMBER) RETURN NUMBER
IS
        v_bmi     NUMBER;
BEGIN
        v_bmi := in_waga/POWER(in_wzrost/100,2);
        RETURN v_bmi;
END licz_bmi;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(licz_bmi(230,80));
END;
/

/*Napisz program, który sprawdzi czy podana w parametrze liczba jest parzysta czy nie. Wywołaj funkcję na 2 sposoby:
w poleceniu SELECT dla wszystkich id pracownika z tabeli employees
w programie PL/SQL w pętli zwracającej liczby od 1 do 10*/

CREATE OR REPLACE FUNCTION czy_parzysta (in_liczba IN employees.employee_id%TYPE) RETURN VARCHAR2
IS
        v_parz VARCHAR2(100);
BEGIN
        IF mod(in_liczba,2) = 0
        THEN v_parz := 'Liczba jest parzysta';
        ELSE v_parz := 'Liczba jest nieparzysta';
        END IF;
        RETURN v_parz;
END czy_parzysta;
/

SELECT employee_id, czy_parzysta(employee_id) as czy_parzysta
FROM employees;
/

BEGIN
    FOR i in 1..10
    LOOP
       DBMS_OUTPUT.PUT_LINE(i || ': ' || czy_parzysta(i));
    END LOOP;
END;
/

/*Napisz funkcję, która zwróci nową pensję pracownika w zależności od jego aktualnych zarobków, tj. jeśli pracownik:
zarabia mniej niż 5000 to podwyżka o 20%
zarabia między 5000 a 7000 to podwyżka o 15%
pozostali podwyżka o 10%
Funkcję zwracającą nową pensję wykorzystaj w procedurze aktualizuj_pensję, która będzie modyfikowała aktualną wysokość pensji pracownika na tą zwracaną przez funkcję. 
Wywołaj procedurę aktualizuj_pensję dla departamentu 50.*/

CREATE OR REPLACE FUNCTION update_salary (in_salary IN NUMBER) RETURN NUMBER
IS
        v_salary NUMBER;
BEGIN
        IF in_salary < 5000
        THEN v_salary := in_salary*(1+TO_NUMBER('0.2','9.9'));
        ELSIF in_salary >= 5000 and in_salary <= 7000
        THEN v_salary := in_salary*(1+TO_NUMBER('0.15','9.99'));
        ELSE v_salary := in_salary*(1+TO_NUMBER('0.1','9.9'));
        END IF;
        RETURN v_salary;
END update_salary;
/

CREATE OR REPLACE PROCEDURE aktualizuj_pensję (in_department_id IN NUMBER)
IS
BEGIN
                UPDATE employees
                SET salary = update_salary(salary)
                WHERE department_id = in_department_id;
END aktualizuj_pensję;
/

BEGIN
    aktualizuj_pensję(50);
END;
/

/****Dla chętnych. Zamień powyższy program na pojedynczą instrukcję UPDATE.*/

UPDATE employees
SET salary = CASE WHEN salary < 5000 THEN salary*(1+TO_NUMBER('0.2','9.9'))
                              WHEN salary >= 5000 and salary <= 7000 THEN salary*(1+TO_NUMBER('0.15','9.99'))
                              ELSE salary*(1+TO_NUMBER('0.1','9.9'))
                     END
WHERE department_id = 50;