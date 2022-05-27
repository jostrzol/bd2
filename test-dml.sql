set echo on;
set linesize 300;
set pagesize 500;
spool BD2C070_DML.LIS;

-- test unikalności kolumny id_osoby w tabeli osoby
INSERT INTO osoby (id_osoby, email, nazwisko, imie, telefon, pesel, nr_karty_stalego_klienta)
    VALUES (2000, 'test1@mail.com', 'test1', 'test1', '0123456789', '01234567891', '0123456789123');
INSERT INTO osoby (id_osoby, email, nazwisko, imie)
    VALUES (2000, 'test2@mail.com', 'test2', 'test2');

-- test unikalności kolumny email w tabeli osoby
INSERT INTO osoby (id_osoby, email, nazwisko, imie)
    VALUES (2001, 'test1@mail.com', 'test2', 'test2');

-- test unikalności kolumny telefon w tabeli osoby
INSERT INTO osoby (id_osoby, email, nazwisko, imie, telefon)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '0123456789');

-- test unikalności kolumny pesel w tabeli osoby
INSERT INTO osoby (id_osoby, email, nazwisko, imie, pesel)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '01234567891');

-- test unikalności kolumny nr_karty_stalego_klienta w tabeli osoby
INSERT INTO osoby (id_osoby, email, nazwisko, imie, nr_karty_stalego_klienta)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '01234567891');
    
-- test sprawdzenia, że w peselu mogą być tylko cyfry
INSERT INTO osoby (id_osoby, email, nazwisko, imie, pesel)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '012345a7891');

-- test sprawdzenia, że w peselu musi być dokładnie 11 znaków
INSERT INTO osoby (id_osoby, email, nazwisko, imie, pesel)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '012345678912');
INSERT INTO osoby (id_osoby, email, nazwisko, imie, pesel)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '0123456789');

-- test sprawdzenia, że w nr_karty_stalego_klienta mogą być tylko cyfry
INSERT INTO osoby (id_osoby, email, nazwisko, imie, nr_karty_stalego_klienta)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '012345a789123');

-- test sprawdzenia, że w nr_karty_stalego_klienta musi być dokładnie 13 znaków
INSERT INTO osoby (id_osoby, email, nazwisko, imie, nr_karty_stalego_klienta)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '01234567891234');
INSERT INTO osoby (id_osoby, email, nazwisko, imie, nr_karty_stalego_klienta)
    VALUES (2001, 'test2@mail.com', 'test2', 'test2', '012345678912');

-- wyzwalacz SG_ANK_WSTAW_ODPOWIEDZI powinien wstawić odpowiedzi na
-- wszystkie pytania do ankiety
INSERT INTO ankiety VALUES (2000, 'SAT-V02', 1006, TO_DATE('09.06.2022', 'DD.MM.YYYY'), 1003, NULL);
SELECT * FROM odpowiedzi WHERE id_ankiety = 2000;

-- wyzwalacz SG_PYT_NIE_WSTAWIAJ_GDY_TANK_W_UZYCIU powinien nie pozwolić dodawać
-- pytań do wykorzystywanych już typów ankiet.
INSERT INTO pytania VALUES ('SAT-V01', 20, 'TEST', NULL, NULL);

-- ... ale do niewykorzystywanych już tak
INSERT INTO typy_ankiet VALUES ('SAT-V03', 'TEST', NULL);
INSERT INTO pytania VALUES ('SAT-V03', 20, 'TEST', NULL, NULL);

-- wyzwalacz SG_ODP_NIE_USUWAJ_GDY_ANK_ISTNIEJE powinien nie pozwolić usuwać
-- pojedynczych odpowiedzi
DELETE odpowiedzi WHERE id_ankiety = 2000;

-- reguła ON DELETE CASCADE na związku ankiety - odpowiedzi powinna usunąć
-- wszystkie odpowiedzi przy usunięciu ankiety
DELETE ankiety WHERE id_ankiety = 2000;
SELECT COUNT(*) FROM odpowiedzi WHERE id_ankiety = 2000;

-- reguła ON DELETE CASCADE na związku pytania - typy_ankiet powinna usunąć
-- wszystkie pytania przy usunięciu typu ankiety
DELETE typy_ankiet WHERE kod_typu_ankiety = 'SAT-V03';
SELECT COUNT(*) FROM pytania WHERE kod_typu_ankiety = 'SAT-V03';

-- test generatora kluczy sztucznych dla tabeli ankiety
DELETE FROM ankiety;
INSERT INTO ankiety VALUES (NULL, 'SAT-V02', 1006, TO_DATE('09.06.2022', 'DD.MM.YYYY'), 1003, NULL);
INSERT INTO ankiety VALUES (NULL, 'SAT-V02', 1006, TO_DATE('09.06.2022', 'DD.MM.YYYY'), 1003, NULL);
SELECT * FROM ankiety;

-- test generatora kluczy sztucznych dla tabeli osoby
DELETE FROM osoby;
INSERT INTO osoby (email, nazwisko, imie, imie_2, telefon, nr_karty_stalego_klienta)
    VALUES ('jkowalski@mail.com', 'Kowalski', 'Jan', NULL, '111111111', '1111111111111');
INSERT INTO osoby (email, nazwisko, imie, imie_2, telefon, nr_karty_stalego_klienta)
    VALUES ('kmsciungwa@mail.com', 'Mściungwa', 'Kamil', NULL, '222222222', '2222222222222');
SELECT * FROM osoby;

spool off;
ROLLBACK;