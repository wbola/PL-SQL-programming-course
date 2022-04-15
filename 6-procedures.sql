/*Napisz procedurę wygeneruj_liste_produktow, która wyświetli na konsoli wszystkie produkty (tabela products).*/

CREATE OR REPLACE PROCEDURE wygeneruj_liste_produktow
IS
	CURSOR c_products IS
        		SELECT *
        		FROM products;
BEGIN           	 
	FOR i IN c_products
	LOOP
        		DBMS_OUTPUT.PUT_LINE(i.product_name);  
	END LOOP;
END wygeneruj_liste_produktow;
/

BEGIN
	wygeneruj_liste_produktow;
END;
/

/*Stwórz procedurę o nazwie wyswietl_przelozonego_pracownika, która będzie wyświetlać imię i nazwisko pracownika oraz imię i nazwisko jego przełożonego(manager_id). W parametrze procedury przekazywany powinien być id_pracownika. Przykładowo: EXECUTE wyswietl_przelozonego_pracownika(101);  powinno zwrócić informację “Steven King jest przełożonym pracownika: Neena Jochhar”.*/

CREATE OR REPLACE PROCEDURE wyswietl_przelozonego_pracownika (in_employee_id IN NUMBER)
IS
	CURSOR c_employee IS
     	SELECT e.first_name AS e_first_name, e.last_name AS e_last_name, m.first_name AS m_first_name, m.last_name AS m_last_name
        		FROM employees e
        		LEFT JOIN employees m
        		ON m.employee_id=e.manager_id
        		WHERE e.employee_id=in_employee_id;
       	 
        	v_emp  c_employee%ROWTYPE;
        	v_tmp BOOLEAN := TRUE;
BEGIN           	 
	OPEN c_employee;
    
	WHILE v_tmp
	LOOP
    		FETCH c_employee INTO v_emp;
    		v_tmp := c_employee%FOUND;
	END LOOP;

	CLOSE c_employee;
	DBMS_OUTPUT.put_line(v_emp.m_first_name || ' ' || v_emp.m_last_name || ' jest przelozonym pracownika: ' || v_emp.e_first_name || ' ' || v_emp.e_last_name);

END wyswietl_przelozonego_pracownika;
/

BEGIN
	wyswietl_przelozonego_pracownika(101);
END;
/

/*Stwórz procedurę o dowolnie wybranej (sensownej) nazwie, która będzie zmieniać nazwę_kraju(country_name) na duże litery dla wszystkich krajów z podanego w parametrze id regionu. W parametrze w trybie OUT zwróć informację o liczbie zmodyfikowanych rekordów. Wynik uruchomienia procedury powinien wyglądać następująco: “Zmodyfikowano nazwę x krajów należących do regionu id_regionu”.
Wywołaj program notacją nazwaną dla regionu o id=4.
*/

CREATE OR REPLACE PROCEDURE duze_litery_nazwy_kraju(							 in_reg_id       IN  countries.region_id%TYPE	      			          , out_rowscount OUT NUMBER
)
IS
BEGIN
	UPDATE countries
   	SET country_name = UPPER(country_name)
 	WHERE region_id = in_reg_id;
    
	out_rowscount:= sql%rowcount;
END duze_litery_nazwy_kraju;
/

DECLARE
	v_rowscount NUMBER;
	v_reg_id countries.region_id%TYPE := 4;
BEGIN
	duze_litery_nazwy_kraju (in_reg_id => v_reg_id, out_rowscount => v_rowscount);
	DBMS_OUTPUT.PUT_LINE('Zmodyfikowano nazwe '||v_rowscount||' krajow nalezacych do regionu ' || v_reg_id);
END;
/

/*Zmodyfikuj blok anonimowy z MODUŁU 7 lekcja 4, tak by wszystkie wyświetlane atrybuty_kursorowe (przed i po poleceniu SELECT) wyświetlały się poprzez wywołanie lokalnej procedury wyświetl_atrybuty_kursorowe.*/

DECLARE
	v_last_name employees.last_name%TYPE;
	v_found 	VARCHAR2(20);
	v_notfound  VARCHAR2(20);
	v_rowcount  NUMBER;
	v_isopen	VARCHAR2(20);
    
PROCEDURE wyświetl_atrybuty_kursorowe IS
BEGIN
	v_found := CASE
             	WHEN sql%found=TRUE THEN 'TRUE'
             	WHEN sql%found=FALSE THEN 'FALSE'
             	ELSE 'NULL'
           	END;
          	 
	v_notfound := CASE
                	WHEN sql%notfound=TRUE THEN 'TRUE'
                	WHEN sql%notfound=FALSE THEN 'FALSE'
                	ELSE 'NULL'
              	END;
             	 
	v_rowcount := sql%rowcount;
    
	v_isopen := CASE
                	WHEN sql%isopen=TRUE THEN 'TRUE'
                	WHEN sql%isopen=FALSE THEN 'FALSE'
            	END;
  	 
	DBMS_OUTPUT.PUT_LINE('%found: '   ||v_found);
	DBMS_OUTPUT.PUT_LINE('%notfound: '||v_notfound);
	DBMS_OUTPUT.PUT_LINE('%rowcount: '||v_rowcount);
	DBMS_OUTPUT.PUT_LINE('%isopen: '  ||v_isopen);
 	 
END wyświetl_atrybuty_kursorowe;

BEGIN
DBMS_OUTPUT.PUT_LINE('== PRZED POLECENIEM ==');
wyświetl_atrybuty_kursorowe;
SELECT last_name
  	INTO v_last_name
  	FROM employees
  	WHERE employee_id = 100
  	;
DBMS_OUTPUT.PUT_LINE('== PO POLECENIU ==');
wyświetl_atrybuty_kursorowe;

END;

/*Napisz procedurę, która wyświetli wszystkie nieskompilowane obiekty w schemacie użytkownika kurs_plsql. Jeśli nie znajdziesz żadnego takiego obiektu to wyświetl informację: “Wszystkie obiekty w schemacie kurs_plsql są skompilowane”.*/

CREATE OR REPLACE PROCEDURE nieskompilowane_obiekty
IS
	CURSOR c_obj IS
        		SELECT object_name, status FROM user_objects
        		WHERE STATUS = 'INVALID';
	v_c NUMBER := 0;

BEGIN           	 
	FOR i in c_obj
	LOOP
		DBMS_OUTPUT.put_line(i.object_name);
		v_c := v_c + 1;
	END LOOP;
	IF v_c = 0 THEN DBMS_OUTPUT.put_line('Wszystkie obiekty w schemacie kurs_plsql są skompilowane');
	END IF;
END nieskompilowane_obiekty;
/

BEGIN
	nieskompilowane_obiekty;
END;
/
