/*Napisz program, który wyliczy wskaźnik BMI osoby o następujących danych. Zmienne nazwij wedle uznania.
wzrost 180cm
waga: 80kg
wzór na BMI: waga/wzrost do kwadratu
Na konsoli wyświetl napis: Twój wskaźnik BMI to: TWÓJ_WYNIK.*/

DECLARE
    v_wzrost     NUMBER := 180;
    v_waga    NUMBER := 80;
    v_bmi     NUMBER;
BEGIN
    v_bmi := v_waga/POWER(v_wzrost/100,2);
    DBMS_OUTPUT.PUT_LINE('Twój wskaźnik BMI to: '||ROUND(v_bmi,2));
END;
/

/*Stwórz program, który wyliczy cenę netto produktu. Zmienne i stałe nazwij wedle uznania.
cena brutto: 1600zł(w tym VAT 23%)
użyj stałej zamiast zmiennej dla stawki podatku
wyświetl w konsoli cenę netto używając do tego zmiennej*/
    
DECLARE
    v_brutto    NUMBER := 1600;
    v_vat        CONSTANT NUMBER := 0.23;
    v_netto    NUMBER;
BEGIN
    v_netto := v_brutto/(1+v_vat);
    DBMS_OUTPUT.PUT_LINE('Cena netto: '||ROUND(v_netto,2));
END;
/

/*Dodaj w bloku PL/SQL nowy produkt do tabeli “produkty” o nazwie “monitor”.
Użyj instrukcji RETURNING INTO by zwrócić identyfikator(product_id) nowego produktu
Odczytaną wartość przypisz do zmiennej, która korzysta z kotwiczenia(%TYPE)*/
    
DECLARE
    v_product_name PRODUCTS.PRODUCT_NAME%TYPE;
BEGIN
    INSERT INTO PRODUCTS (PRODUCT_NAME) VALUES ('monitor')
    RETURNING PRODUCT_ID INTO v_product_name;
END;
/

/*Stwórz program z 3 zmiennymi:
v_imie, typ varchar, 40 znaków
v_wiek, typ numeryczny, rozmiar 2 cyfr
w sekcji wykonawczej przypisz Twoje dane do obu zmiennych
na konsoli wyświetl napis: TWOJE_IMIE ma TWÓJ_WIEK lat, np. Darek ma 29 lat*/
    
DECLARE
    v_imie  VARCHAR2(40);
    v_wiek  NUMBER(2);
BEGIN
    v_imie := 'Weronika';
    v_wiek := 26;
    DBMS_OUTPUT.PUT_LINE(v_imie || ' ma ' || v_wiek || ' lat');
END;
/

/*Oblicz obwód i pole koła o promieniu 10. Wykorzystaj stałą do deklaracji liczby pi.*/
    
DECLARE
    v_promien  NUMBER := 10;
    v_pi       CONSTANT NUMBER := 3.14;
    v_obwod    NUMBER;
    v_pole     NUMBER;
BEGIN
    v_obwod := 2*v_pi*v_promien;
    v_pole := v_pi*power(v_promien,2);
    DBMS_OUTPUT.PUT_LINE('Obwód koła wynosi: ' || v_obwod);
    DBMS_OUTPUT.PUT_LINE('Pole koła wynosi: ' || v_pole);
END;
/