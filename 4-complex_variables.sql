/*Używając kotwiczenia %ROWTYPE wczytaj całą tabelę departments do kolekcji:*/
--asocjacyjnej

DECLARE
    TYPE t_departments IS TABLE OF departments%ROWTYPE INDEX BY PLS_INTEGER;
    at_departments t_departments := t_departments();
BEGIN
    SELECT *
    BULK COLLECT INTO at_departments
    FROM departments
    ;
    
    FOR i IN at_departments.FIRST..at_departments.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE(at_departments(i).department_name||', '||at_departments(i).manager_id);
    END LOOP;
END;
/

--zagnieżdżonej

DECLARE
    TYPE t_departments IS TABLE OF departments%ROWTYPE;
    nt_departments t_departments := t_departments();
BEGIN
    SELECT *
    BULK COLLECT INTO nt_departments
    FROM departments
    ;
    
    FOR i IN nt_departments.FIRST..nt_departments.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE(nt_departments(i).department_name||', '||nt_departments(i).manager_id);
    END LOOP;
END;
/

--varray

DECLARE
    TYPE t_departments IS VARRAY(100) OF departments%ROWTYPE;
    vt_departments t_departments := t_departments();
BEGIN
    SELECT *
    BULK COLLECT INTO vt_departments
    FROM departments
    ;
    
    FOR i IN vt_departments.FIRST..vt_departments.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE(vt_departments(i).department_name||', '||vt_departments(i).manager_id);
    END LOOP;
END;
/

/*Użyj pętli FOR by wyświetlić nazwę departamentu i id_managera na konsoli.
Stwórz kolekcję asocjacyjną indeksowaną tekstem. Zapisz do niej listę wszystkich predefiniowanych wyjątków Oracle. Indeks kolekcji to kod ORA, wartość przechowywana w kolekcji to nazwa wyjątku, np. kolekcja(‘ora-01422’) powinna zwracać wartość “too_many_rows”, a kolekcja(‘ora-01001’) powinna zwracać wartość “invalid_cursor”. Do wyświetlenia zawartości kolekcji w konsoli użyj pętli WHILE.
Uwaga. Listę wyjątków znajdziesz w Twojej poprzedniej pracy domowej*/

DECLARE
    TYPE typ_at IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    kolekcja_at typ_at := typ_at('ORA-6530'  => 'ACCESS_INTO_NULL',
                                 'ORA-6592'  => 'CASE_NOT_FOUND',
                                 'ORA-6531'  => 'COLLECTION_IS_NULL',
                                 'ORA-6511'  => 'CURSOR_ALREADY_OPEN',
                                 'ORA-1'     => 'DUP_VAL_ON_INDEX',
                                 'ORA-1001'  => 'INVALID_CURSOR',
                                 'ORA-1722'  => 'INVALID_NUMBER',
                                 'ORA-1017'  => 'LOGIN_DENIED',
                                 'ORA+100'   => 'NO_DATA_FOUND',
                                 'ORA-6548'  => 'NO_DATA_NEEDED',
                                 'ORA-1012'  => 'NOT_LOGGED_ON',
                                 'ORA-6501'  => 'PROGRAM_ERROR',
                                 'ORA-6504'  => 'ROWTYPE_MISMATCH',
                                 'ORA-30625' => 'SELF_IS_NULL',
                                 'ORA-6500'  => 'STORAGE_ERROR',
                                 'ORA-6533'  => 'SUBSCRIPT_BEYOND_COUNT',
                                 'ORA-6532'  => 'SUBSCRIPT_OUTSIDE_LIMIT',
                                 'ORA-1410'  => 'SYS_INVALID_ROWID',
                                 'ORA-51'    => 'TIMEOUT_ON_RESOURCE',
                                 'ORA-1422'  => 'TOO_MANY_ROWS',
                                 'ORA-6502'  => 'VALUE_ERROR',
                                 'ORA-1476'  => 'ZERO_DIVIDE');  
    v_indeks VARCHAR2(20);
BEGIN    
    v_indeks := kolekcja_at.first;
    WHILE (v_indeks IS NOT NULL)
    LOOP
            DBMS_OUTPUT.PUT_LINE(kolekcja_at(v_indeks));
            v_indeks := kolekcja_at.next(v_indeks);
    END LOOP;
END;
/

/*Stwórz kolekcję nested table zawierającą liczby od 1 do 10. Następnie wykorzystując metodę DELETE usuń element 2, 5 i 9. Wyświetl następnie zawartość całej kolekcji wykorzystując metodę NEXT.
Uwaga. Metoda NEXT jest Ci potrzebna do tego, by w  pętli iterować wyłącznie po elementach kolekcji, tzn. by z indeksu 1 przejeść do indeksu 3, a z indeksu 4 do indeksu 6, itd. Inaczej mówiąc Twoja pętla powinna wykonać 7, a nie 10 iteracji, bo tyle elementów zawiera kolekcja.*/

DECLARE
    TYPE typ_nt IS TABLE OF VARCHAR2(10);
    kolekcja_nt typ_nt  := typ_nt(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
    v_indeks VARCHAR2(20);
BEGIN
    kolekcja_nt.DELETE(2);
    kolekcja_nt.DELETE(5);
    kolekcja_nt.DELETE(9);
    
    v_indeks := kolekcja_nt.first;
    WHILE (v_indeks IS NOT NULL)
    LOOP
            DBMS_OUTPUT.PUT_LINE(kolekcja_nt(v_indeks));
            v_indeks := kolekcja_nt.next(v_indeks);
    END LOOP;
END;
/

/*Udziel odpowiedzi na poniższe pytania pisząc: AT(kolekcja asocjacyjna), NT (kolekcja nested table) lub  VT(kolekcja VARRAY). 
Która kolekcja:
ma maksymalną liczbę elementów? VT
może być indeksowana tekstem? AT
ma dodatkowe operatory do porównywania kolekcji? NT
nie wymaga inicjalizacji? AT
nie może być rzadka? VT
nie może być użyta w SQL? AT*/