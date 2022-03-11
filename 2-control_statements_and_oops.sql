/*Rozszerz funkcjonalność programu z poprzedniego modułu, który liczył wskaźnik BMI.
Wyświetl odpowiedni komunikat na konsoli w zależności od wyniku:
<16 “ale z Ciebie niejadek”
>=16 i <25 “dobra forma, tak trzymaj”
>=25 “zrób kilka pompek”*/

DECLARE
    v_wzrost     NUMBER := 180;
    v_waga    NUMBER := 80;
    v_bmi     NUMBER;
BEGIN
    v_bmi := v_waga/POWER(v_wzrost/100,2);
    DBMS_OUTPUT.PUT_LINE('Twój wskaźnik BMI to: '||ROUND(v_bmi,2));
    IF  ROUND(v_bmi,2) < 16 THEN
            DBMS_OUTPUT.PUT_LINE('ale z Ciebie niejadek');
    ELSIF ROUND(v_bmi,2)>=16 AND ROUND(v_bmi,2) < 25 THEN
            DBMS_OUTPUT.PUT_LINE('dobra forma, tak trzymaj');
    ELSIF ROUND(v_bmi,2) >= 25 THEN
            DBMS_OUTPUT.PUT_LINE('zrób kilka pompek');
    END IF;
END;
/

/*Napisz program zwracający liczby od 20 do 41 co 3, tzn. 20, 23, 26..41. Na konsoli wyświetl napis: “aktualna wartość: x , poprzednia wartość: y”, gdzie x i y to odpowiednie wartości zmiennej.
Uwaga. Możesz wykorzystać dowolny rodzaj pętli.*/

DECLARE
    x    NUMBER := 20;
    y    NUMBER;
BEGIN
    WHILE x<=41
    LOOP
		DBMS_OUTPUT.PUT_LINE('aktualna wartość: ' || x || ' poprzednia wartość: ' || y);
        x := x+3;
        y := x-3;
    END LOOP;
END;
/

/*Napisz trzy programy, wyświetlające wyłącznie liczby parzyste z zakresu od 1 do 10. Każdy program powinien użyć innego rodzaju pętli(simple, while loop, for loop).*/
--PĘTLA SIMPLE LOOP
DECLARE
    v_lp NUMBER := 0;
BEGIN
    LOOP
        v_lp := v_lp+1;
        EXIT WHEN v_lp>10;
        CONTINUE WHEN mod(v_lp,2) = 1;
        DBMS_OUTPUT.PUT_LINE(v_lp);
    END LOOP;
END;
/

--PĘTLA WHILE LOOP
DECLARE
    v_lp NUMBER := 0;
BEGIN
    WHILE v_lp<10
    LOOP
        v_lp := v_lp+2;
        DBMS_OUTPUT.PUT_LINE(v_lp);
    END LOOP;
END;
/

--PĘTLA FOR LOOP
BEGIN
    FOR i IN 1..10
    LOOP
       IF mod(i,2) = 0 THEN
       DBMS_OUTPUT.PUT_LINE(i);
       END IF;
    END LOOP;
END;
/

/*Stwórz program z użyciem pętli zagnieżdżonej, który będzie iterował 3 razy po pętli zewnętrznej i 3 raz po pętli wewnętrznej za każdym razem wyświetlając numer obiegu każdej pętli, tzn. 1.1, 1.2, 1.3, 2.1 …, 3.2, 3.3*/
--pętla zewnętrzna: for, wewnętrzna: simple
DECLARE
    a NUMBER := 0;
BEGIN
    FOR i IN 1..3
    LOOP
    a := 0;
         LOOP
            a := a + 1;
            DBMS_OUTPUT.PUT_LINE(i||'.'||a);
            EXIT WHEN a = 3;
         END LOOP;
    END LOOP;
END;
/

--pętla zewnętrzna: simple, wewnętrzna: for
DECLARE
    a NUMBER := 0;
BEGIN
    LOOP
        a := a + 1;
        EXIT WHEN a > 3;
        FOR i IN 1..3
        LOOP
              DBMS_OUTPUT.PUT_LINE(a||'.'||i);
        END LOOP;
    END LOOP;
END;
/

--pętla zewnętrzna: while, wewnętrzna: for
DECLARE
    a NUMBER := 0;
BEGIN
    WHILE a < 3
    LOOP
        a := a + 1;
        FOR i IN 1..3
        LOOP
               DBMS_OUTPUT.PUT_LINE(a||'.'||i);
        END LOOP;
    END LOOP;
END;
/

/*Wyjaśnij czym różni się EXIT od CONTINUE.
EXIT - powoduje całkowite wyjście z pętli
CONTINUE - kontynuuje wykonywanie kodu, przechodząc do następnej iteracji w pętli*/
