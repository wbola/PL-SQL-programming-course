/*Napisz program, który za pomocą wyrażenia CASE wygeneruje wyjątek CASE_NOT_FOUND. Obsłuż go wyświetlając na konsoli informację o kodzie błędu ORA i komunikacie błędu ORA. W nowej linii konsoli napisz użytkownikowi jaką akcję powinien podjąć by pozbyć się tego błędu.*/

DECLARE
    v_liczba NUMBER;
BEGIN
    CASE
            WHEN v_liczba IS NOT NULL THEN NULL;
    END CASE;
EXCEPTION
    WHEN CASE_NOT_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Wykryto błąd, kod: '||SQLCODE||', komunikat: '||SQLERRM);
            DBMS_OUTPUT.PUT_LINE('W wyrażeniu CASE musi zostać wykonana chociaż jedna instrukcja.');
END;
/

/*Napisz program PL/SQL, który będzie dodawał do tabeli countries nowy rekord o następujących wartościach:
country_id: ML
country_name: Malta
Obsłuż komunikat błędu o naruszeniu constraintu wykorzystując klauzulę PRAGMA EXCEPTION_INIT.*/

DECLARE
    ex_constraint EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_constraint, -00001);
BEGIN
    INSERT INTO COUNTRIES(country_id, country_name) VALUES ('ML', 'Malta');
EXCEPTION
    WHEN ex_constraint THEN
    DBMS_OUTPUT.PUT_LINE('Zostalo naruszone ograniczenie unikatowe.');
END;
/

/*Wykorzystaj program z poprzedniej pracy domowej liczący wskaźnik BMI. Zadeklaruj w nim własny wyjątek o nazwie ex_too_big. Jeśli wzrost użytkownika jest wyższy niż 225cm rzuć zdefiniowany wyjątek (ex_too_big).
Program powinien w takiej sytuacji zwracać przyjazną użytkownikowi informację, że podany wzrost jest nienaturalnie duży i należy wprowadzić poprawną wartość.*/

DECLARE
    v_wzrost     NUMBER := 230;
    v_waga    NUMBER := 80;
    v_bmi     NUMBER;
    ex_too_big EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_too_big, -20002);
BEGIN
    IF v_wzrost > 225 THEN
           RAISE ex_too_big;
    END IF;
    v_bmi := v_waga/POWER(v_wzrost/100,2);
    DBMS_OUTPUT.PUT_LINE('Twój wskaźnik BMI to: '||ROUND(v_bmi,2));
    IF  ROUND(v_bmi,2) < 16 THEN
           DBMS_OUTPUT.PUT_LINE('ale z Ciebie niejadek');
    ELSIF ROUND(v_bmi,2)>=16 AND ROUND(v_bmi,2) < 25 THEN
           DBMS_OUTPUT.PUT_LINE('dobra forma, tak trzymaj');
    ELSIF ROUND(v_bmi,2) >= 25 THEN
           DBMS_OUTPUT.PUT_LINE('zrób kilka pompek');
    END IF;
EXCEPTION
    WHEN ex_too_big THEN
    DBMS_OUTPUT.PUT_LINE('Twój wzrost ' ||v_wzrost||'cm '||'jest nienaturalnie duży. Wprowadź poprawna wartość.');
END;
/
    
/*Jakie 3 rodzaje wyjątków istnieją w bazie danych Oracle i czym się od siebie różnią?
systemowe predefiniowane - wyjątki wywoływane przez Oracle, którym producent nadał własne nazwy
systemowe niedefiniowane - wyjątki wywoływane przez Oracle, którym producent nie nadał własnej nazwy
użytkownika - wyjątki, które samemu trzeba zdefiniować i wywołać*/