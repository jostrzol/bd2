set echo on;
set linesize 300;
set pagesize 500;
spool BD2C070_DML.LIS;

/****************
 * TABELA OSOBY *
 ****************/
-- unikalność kolumny id_osoby (klucz główny)
INSERT INTO osoby (id_osoby, email, nazwisko, imie, telefon, pesel, nr_karty_stalego_klienta)
    VALUES (2000, 'test1@mail.com', 'test1', 'test1', '0123456789', '01234567891', '0123456789123');
INSERT INTO osoby (id_osoby, email, nazwisko, imie)
    VALUES (2000, 'test2@mail.com', 'test2', 'test2');

-- unikalność kolumny email
INSERT INTO osoby (id_osoby, email, nazwisko, imie)
    VALUES (2001, 'test1@mail.com', 'test2', 'test2');

-- unikalność kolumny telefon
INSERT INTO osoby (id_osoby, email, nazwisko, imie, telefon)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '0123456789');

-- unikalność kolumny pesel
INSERT INTO osoby (id_osoby, email, nazwisko, imie, pesel)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '01234567891');

-- unikalność kolumny nr_karty_stalego_klienta
INSERT INTO osoby (id_osoby, email, nazwisko, imie, nr_karty_stalego_klienta)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '0123456789123');
    
-- pesel składa się tylko z cyfr
INSERT INTO osoby (id_osoby, email, nazwisko, imie, pesel)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '012345a7891');

-- pesel musi mieć dokładnie 11 znaków
INSERT INTO osoby (id_osoby, email, nazwisko, imie, pesel)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '012345678912');
INSERT INTO osoby (id_osoby, email, nazwisko, imie, pesel)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '0123456789');

-- nr_karty_stalego_klienta składa się tylko z cyfr
INSERT INTO osoby (id_osoby, email, nazwisko, imie, nr_karty_stalego_klienta)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '012345a789123');

-- nr_karty_stalego_klienta musi mieć dokładnie 13 znaków
INSERT INTO osoby (id_osoby, email, nazwisko, imie, nr_karty_stalego_klienta)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '01234567891234');
INSERT INTO osoby (id_osoby, email, nazwisko, imie, nr_karty_stalego_klienta)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '012345678912');

/**********************
 * TABELA TYPY_ANKIET *
 **********************/
-- unikalność kolumny kod_typu_ankiety (klucz główny)
INSERT INTO typy_ankiet VALUES ('TEST1', 'TEST1', NULL);
INSERT INTO typy_ankiet VALUES ('TEST1', 'TEST2', NULL);

/******************
 * TABELA PYTANIA *
 ******************/
-- unikalność kolumn kod_typu_ankiety i nr_pytania (klucz główny)
INSERT INTO pytania VALUES ('TEST1', 1, 'TEST1', 1, NULL);
-- źle
INSERT INTO pytania VALUES ('TEST1', 1, 'TEST2', 1, NULL);
-- dobrze
INSERT INTO pytania VALUES ('TEST1', 2, 'TEST2', 1, NULL);

-- wartości dopuszczalne kolumny czy_opcjonalne: 0, 1
-- źle
INSERT INTO pytania VALUES ('TEST1', 3, 'TEST2', -1, NULL);
-- dobrze
INSERT INTO pytania VALUES ('TEST1', 4, 'TEST2', 0, NULL);
-- dobrze
INSERT INTO pytania VALUES ('TEST1', 5, 'TEST2', 1, NULL);
-- źle
INSERT INTO pytania VALUES ('TEST1', 6, 'TEST2', 2, NULL);

/******************
 * TABELA ANKIETY *
 ******************/
-- unikalność kolumny id_ankiety (klucz główny)
INSERT INTO ankiety VALUES (2000, 'TEST1', 2000, TO_DATE('01.01.2022', 'DD.MM.YYYY'), NULL, NULL);
INSERT INTO ankiety VALUES (2000, 'TEST1', 2000, TO_DATE('01.01.2022', 'DD.MM.YYYY'), NULL, NULL);

/*********************
 * TABELA ODPOWIEDZI *
 *********************/
-- wartości dopuszczalne kolumny ocena: 0, 50, 100
-- (wartość nieokreślona dla pytań opcjonalnych przetestowana w sekcji WYZWALACZE)
-- źle
UPDATE odpowiedzi SET ocena = -1 WHERE id_ankiety = 2000 AND nr_pytania = 1;
-- dobrze
UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 2000 AND nr_pytania = 1;
-- źle
UPDATE odpowiedzi SET ocena = 1 WHERE id_ankiety = 2000 AND nr_pytania = 1;
-- źle
UPDATE odpowiedzi SET ocena = 49 WHERE id_ankiety = 2000 AND nr_pytania = 1;
-- dobrze
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 2000 AND nr_pytania = 1;
-- źle
UPDATE odpowiedzi SET ocena = 51 WHERE id_ankiety = 2000 AND nr_pytania = 1;
-- źle
UPDATE odpowiedzi SET ocena = 99 WHERE id_ankiety = 2000 AND nr_pytania = 1;
-- dobrze
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 2000 AND nr_pytania = 1;
-- źle
UPDATE odpowiedzi SET ocena = 101 WHERE id_ankiety = 2000 AND nr_pytania = 1;

/**************
 * WYZWALACZE *
 **************/
-- nietransferowalność związku typy_ankiet - pytania
-- dobrze (brak zmiany)
UPDATE pytania SET kod_typu_ankiety = 'TEST1'
WHERE kod_typu_ankiety = 'TEST1' AND nr_pytania = 1;
-- źle
UPDATE pytania SET kod_typu_ankiety = 'SAT-V01'
WHERE kod_typu_ankiety = 'TEST1' AND nr_pytania = 1;

-- nietransferowalność związku ankiety - agenci
-- dobrze (brak zmiany)
UPDATE ankiety SET id_agenta = 2000 WHERE id_ankiety = 2000;
-- źle
UPDATE ankiety SET id_agenta = 1006 WHERE id_ankiety = 2000;

-- nietransferowalność związku ankiety - klienci
-- dobrze (zmiana z NULL)
UPDATE ankiety SET id_klienta = 2000 WHERE id_ankiety = 2000;
-- dobrze (brak zmiany)
UPDATE ankiety SET id_klienta = 2000 WHERE id_ankiety = 2000;
-- źle
UPDATE ankiety SET id_klienta = 1001 WHERE id_ankiety = 2000;

-- nietransferowalność związku ankiety - typy_ankiet
-- dobrze (brak zmiany)
UPDATE ankiety SET kod_typu_ankiety = 'TEST1' WHERE id_ankiety = 2000;
-- źle
UPDATE ankiety SET kod_typu_ankiety = 'SAT-V01' WHERE id_ankiety = 2000;

-- nietransferowalność związku odpowiedzi - ankiety
-- dobrze (brak zmiany)
UPDATE odpowiedzi SET id_ankiety = 2000 WHERE id_ankiety = 2000;
-- źle (nietransferowalność + unikalność)
UPDATE odpowiedzi SET id_ankiety = 1001 WHERE id_ankiety = 2000;

-- nietransferowalność związku odpowiedzi - pytania
-- dobrze (brak zmiany)
UPDATE odpowiedzi SET kod_typu_ankiety = 'TEST1', nr_pytania = 1
WHERE id_ankiety = 2000 AND kod_typu_ankiety = 'TEST1' AND nr_pytania = 1;
-- źle
UPDATE odpowiedzi SET kod_typu_ankiety = 'SAT-V01', nr_pytania = 1
WHERE id_ankiety = 2000 AND kod_typu_ankiety = 'TEST1' AND nr_pytania = 1;
-- źle
UPDATE odpowiedzi SET kod_typu_ankiety = 'SAT-V01', nr_pytania = 2
WHERE id_ankiety = 2000 AND kod_typu_ankiety = 'TEST1' AND nr_pytania = 1;

-- wyzwalacz SG_ANK_WSTAW_ODPOWIEDZI wstawia odpowiedzi na wszystkie pytania do ankiety
INSERT INTO ankiety VALUES (2001, 'SAT-V02', 1006, TO_DATE('09.06.2022', 'DD.MM.YYYY'), 1003, NULL);
SELECT * FROM odpowiedzi WHERE id_ankiety = 2001;

-- wyzwalacz SG_PYT_NIE_WSTAWIAJ_GDY_TANK_W_UZYCIU nie pozwala dodawać
-- pytań do wykorzystywanych już typów ankiet.
INSERT INTO pytania VALUES ('SAT-V01', 20, 'TEST', 0, NULL);
-- ... ale do niewykorzystywanych już tak
INSERT INTO typy_ankiet VALUES ('SAT-V03', 'TEST', NULL);
INSERT INTO pytania VALUES ('SAT-V03', 20, 'TEST', 0, NULL);

-- wyzwalacz SG_ODP_NIE_USUWAJ_GDY_ANK_ISTNIEJE nie pozwala usuwać
-- pojedynczych odpowiedzi bez usunięcia całej ankiety
-- (przypadek usuwania całej ankiety w sekcji ON DELETE CASCADE)
DELETE odpowiedzi WHERE id_ankiety = 2001;

-- wyzwalacz SG_ODP_OCENA_NIE_NULL_DLA_OBOWIAZKOWYCH nie pozwala ustawić
-- wartości nieokreślonej dla odpowiedzi na pytania obowiązkowe
UPDATE odpowiedzi SET ocena = NULL WHERE id_ankiety = 2001 AND nr_pytania = 1;
-- ... ale dla odpowiedzi na pytania opcjonalne już tak
UPDATE odpowiedzi SET ocena = NULL WHERE id_ankiety = 2001 AND nr_pytania = 5;

/****************************
 * REGUŁY ON DELETE CASCADE *
 ****************************/
-- reguła ON DELETE CASCADE na związku ankiety - odpowiedzi powinna usunąć
-- wszystkie odpowiedzi przy usunięciu ankiety
SELECT COUNT(*) FROM odpowiedzi WHERE id_ankiety = 2001;
DELETE ankiety WHERE id_ankiety = 2001;
SELECT COUNT(*) FROM odpowiedzi WHERE id_ankiety = 2001;

-- reguła ON DELETE CASCADE na związku pytania - typy_ankiet powinna usunąć
-- wszystkie pytania przy usunięciu typu ankiety
SELECT COUNT(*) FROM pytania WHERE kod_typu_ankiety = 'SAT-V03';
DELETE typy_ankiet WHERE kod_typu_ankiety = 'SAT-V03';
SELECT COUNT(*) FROM pytania WHERE kod_typu_ankiety = 'SAT-V03';

/********************************
 * GENERATORY KLUCZY SZTUCZNYCH *
 ********************************/
-- test generatora kluczy sztucznych dla tabeli ankiety
DELETE FROM ankiety WHERE 1 = 1;
INSERT INTO ankiety VALUES (NULL, 'SAT-V02', 1006, TO_DATE('09.06.2022', 'DD.MM.YYYY'), NULL, NULL);
INSERT INTO ankiety VALUES (NULL, 'SAT-V02', 1006, TO_DATE('09.06.2022', 'DD.MM.YYYY'), NULL, NULL);
SELECT * FROM ankiety;

-- test generatora kluczy sztucznych dla tabeli osoby
DELETE FROM ankiety WHERE 1 = 1;
DELETE FROM osoby WHERE 1 = 1;
INSERT INTO osoby (email, nazwisko, imie, imie_2, telefon, nr_karty_stalego_klienta)
    VALUES ('jkowalski@mail.com', 'Kowalski', 'Jan', NULL, '111111111', '1111111111111');
INSERT INTO osoby (email, nazwisko, imie, imie_2, telefon, nr_karty_stalego_klienta)
    VALUES ('kmsciungwa@mail.com', 'Mściungwa', 'Kamil', NULL, '222222222', '2222222222222');
SELECT * FROM osoby;

spool off;
ROLLBACK;