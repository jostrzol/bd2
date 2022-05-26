set echo on;
set linesize 300;
set pagesize 500;
spool BD2C070_DML.LIS;



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