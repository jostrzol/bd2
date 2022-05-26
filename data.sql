ROLLBACK;

TRUNCATE TABLE odpowiedzi;
TRUNCATE TABLE ankiety;
TRUNCATE TABLE pytania;
TRUNCATE TABLE typy_ankiet;
TRUNCATE TABLE osoby;


INSERT INTO osoby (id_osoby, email, nazwisko, imie, imie_2, telefon, nr_karty_stalego_klienta)
VALUES (1001, 'jkowalski@mail.com', 'Kowalski', 'Jan', NULL, '111111111', '1111111111111');
INSERT INTO osoby (id_osoby, email, nazwisko, imie, imie_2, telefon, nr_karty_stalego_klienta)
VALUES (1002, 'kmsciungwa@mail.com', 'Mściungwa', 'Kamil', NULL, '222222222', '2222222222222');
INSERT INTO osoby (id_osoby, email, nazwisko, imie, imie_2, telefon, nr_karty_stalego_klienta)
VALUES (1003, 'adrzewo@mail.com', 'Drzewo', 'Albert', 'Anastazy', '333333333', '3333333333333');
INSERT INTO osoby (id_osoby, email, nazwisko, imie, imie_2, telefon, nr_karty_stalego_klienta)
VALUES (1004, 'jbombrowicz@mail.com', 'Bombrowicz', 'Jakub', 'Edward', '444444444', '4444444444444');
INSERT INTO osoby (id_osoby, email, nazwisko, imie, imie_2, telefon, nr_karty_stalego_klienta)
VALUES (1005, 'nmazur@mail.com', 'Mazur', 'Natalia', NULL, '555555555', '5555555555555');


INSERT INTO osoby (id_osoby, email, nazwisko, imie, imie_2, telefon, pesel, data_urodzenia, panstwo, miasto, ulica, nr_domu, nr_mieszkania)
VALUES (1006, 'akozlowski@mail.com', 'Kozłowski', 'Andrzej', NULL, '666666666', '45102000859', TO_DATE('20.10.1945', 'DD.MM.YYYY'), 'Polska', 'Warszawa', 'Długa', '1A', NULL);
INSERT INTO osoby (id_osoby, email, nazwisko, imie, imie_2, telefon, pesel, data_urodzenia, panstwo, miasto, ulica, nr_domu, nr_mieszkania)
VALUES (1007, 'jczerwienska@mail.com', 'Czerwieńska', 'Józefa', 'Maria', '777777777', '58050197229', TO_DATE('01.05.1958', 'DD.MM.YYYY'), 'Polska', 'Chorzów', 'Krótka', '12', '2');
INSERT INTO osoby (id_osoby, email, nazwisko, imie, imie_2, telefon, pesel, data_urodzenia, panstwo, miasto, ulica, nr_domu, nr_mieszkania)
VALUES (1008, 'jostrowska@mail.com', 'Ostrowska', 'Julianna', NULL, '888888888', '42092804885', TO_DATE('28.09.1942', 'DD.MM.YYYY'), 'Polska', 'Rzeszów', 'Szeroka', '43', NULL);
INSERT INTO osoby (id_osoby, email, nazwisko, imie, imie_2, telefon, pesel, data_urodzenia, panstwo, miasto, ulica, nr_domu, nr_mieszkania)
VALUES (1009, 'ipiotrowski@mail.com', 'Piotrowski', 'Ignacy', NULL, '999999999', '77011733157', TO_DATE('17.01.1977', 'DD.MM.YYYY'), 'Polska', 'Jastrzębie', 'Wąska', '55', '11');
INSERT INTO osoby (id_osoby, email, nazwisko, imie, imie_2, telefon, pesel, data_urodzenia, panstwo, miasto, ulica, nr_domu, nr_mieszkania)
VALUES (1010, 'kwalczak@mail.com', 'Walczak', 'Karol', 'Mateusz', '000000000', '76040623635', TO_DATE('06.04.1976', 'DD.MM.YYYY'), 'Polska', 'Szczecin', 'Średnia', '102', '17');


INSERT INTO typy_ankiet VALUES ('SAT-V01', 'Ankieta satysfakcji wersja 1', 'Ankieta wypełniana przez klienta po obsłużeniu przez dowolnego agenta.');
INSERT INTO typy_ankiet VALUES ('SAT-V02', 'Ankieta satysfakcji wersja 2', 'Ankieta wypełniana przez klienta po obsłużeniu przez dowolnego agenta. Uwzględnia ocenę biura agenta.');
INSERT INTO typy_ankiet VALUES ('KUR-V01', 'Ankieta kuriera wersja 1', 'Ankieta oceniająca jakość obsługi przez kuriera.');

INSERT INTO pytania VALUES ('SAT-V01', 1, 'Jak ocenia Pan/Pani punktualność agenta?', 0, NULL);
INSERT INTO pytania VALUES ('SAT-V01', 2, 'Jak ocenia Pan/Pani kooperatywność agenta?', 0, NULL);
INSERT INTO pytania VALUES ('SAT-V01', 3, 'Jak ocenia Pan/Pani wiedzę agenta?', 0, NULL);
INSERT INTO pytania VALUES ('SAT-V01', 4, 'Jak ocenia Pan/Pani chęć do pomocy agenta?', 0, NULL);

INSERT INTO pytania VALUES ('SAT-V02', 1, 'Jak ocenia Pan/Pani punktualność agenta?', 0, NULL);
INSERT INTO pytania VALUES ('SAT-V02', 2, 'Jak ocenia Pan/Pani przygotowanie agenta?', 0, NULL);
INSERT INTO pytania VALUES ('SAT-V02', 3, 'Jak ocenia Pan/Pani wiedzę agenta?', 0, NULL);
INSERT INTO pytania VALUES ('SAT-V02', 4, 'Jak ocenia Pan/Pani chęć do pomocy agenta?', 0, NULL);
INSERT INTO pytania VALUES ('SAT-V02', 5, 'Jeśli spotkanie odbyło się w biurze, to jak Pan/Pani ocenia porządek w biurze agenta?', 1, NULL);
INSERT INTO pytania VALUES ('SAT-V02', 6, 'Jeśli spotkanie odbyło się w biurze, to jak Pan/Pani ocenia sprawność obsługi sprzętu elektronicznego w biurze przez agenta?', 1, NULL);

INSERT INTO pytania VALUES ('KUR-V01', 1, 'Jak ocenia Pan/Pani punktualność kuriera?', 0, NULL);
INSERT INTO pytania VALUES ('KUR-V01', 2, 'Jak ocenia Pan/Pani stan przesyłanego obiektu po dotarciu?', 0, NULL);


INSERT INTO ankiety VALUES (1001, 'SAT-V01', 1005, TO_DATE('17.01.2020', 'DD.MM.YYYY'), 1001, NULL);
INSERT INTO ankiety VALUES (1002, 'SAT-V01', 1007, TO_DATE('01.02.2020', 'DD.MM.YYYY'), 1001, NULL);
INSERT INTO ankiety VALUES (1003, 'SAT-V02', 1005, TO_DATE('09.03.2021', 'DD.MM.YYYY'), NULL, NULL);
INSERT INTO ankiety VALUES (1004, 'SAT-V02', 1009, TO_DATE('23.08.2021', 'DD.MM.YYYY'), 1004, NULL);
INSERT INTO ankiety VALUES (1005, 'KUR-V01', 1007, TO_DATE('30.10.2021', 'DD.MM.YYYY'), 1004, NULL);
INSERT INTO ankiety VALUES (1006, 'KUR-V01', 1008, TO_DATE('11.11.2021', 'DD.MM.YYYY'), 1005, NULL);
INSERT INTO ankiety VALUES (1007, 'KUR-V01', 1008, TO_DATE('12.12.2021', 'DD.MM.YYYY'), 1002, NULL);
INSERT INTO ankiety VALUES (1008, 'SAT-V02', 1008, TO_DATE('23.05.2022', 'DD.MM.YYYY'), 1001, NULL);
INSERT INTO ankiety VALUES (1009, 'SAT-V02', 1009, TO_DATE('02.05.2022', 'DD.MM.YYYY'), 1005, NULL);
INSERT INTO ankiety VALUES (1010, 'SAT-V02', 1007, TO_DATE('12.06.2022', 'DD.MM.YYYY'), NULL, NULL);
INSERT INTO ankiety VALUES (1011, 'SAT-V02', 1007, TO_DATE('10.06.2022', 'DD.MM.YYYY'), NULL, NULL);
INSERT INTO ankiety VALUES (1012, 'SAT-V02', 1006, TO_DATE('09.06.2022', 'DD.MM.YYYY'), 1003, NULL);

UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1001 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1001 AND nr_pytania = 2;
UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 1001 AND nr_pytania = 3;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1001 AND nr_pytania = 4;

UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 1002 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1002 AND nr_pytania = 2;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1002 AND nr_pytania = 3;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1002 AND nr_pytania = 4;

UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1003 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1003 AND nr_pytania = 2;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1003 AND nr_pytania = 3;
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1003 AND nr_pytania = 4;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1003 AND nr_pytania = 5;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1003 AND nr_pytania = 6;

UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1004 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 1004 AND nr_pytania = 2;
UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 1004 AND nr_pytania = 3;
UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 1004 AND nr_pytania = 4;
UPDATE odpowiedzi SET ocena = NULL WHERE id_ankiety = 1004 AND nr_pytania = 5;
UPDATE odpowiedzi SET ocena = NULL WHERE id_ankiety = 1004 AND nr_pytania = 6;

UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1005 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1005 AND nr_pytania = 2;

UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1006 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 1006 AND nr_pytania = 2;

UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1007 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1007 AND nr_pytania = 2;

UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 1008 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1008 AND nr_pytania = 2;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1008 AND nr_pytania = 3;
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1008 AND nr_pytania = 4;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1008 AND nr_pytania = 5;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1008 AND nr_pytania = 6;

UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1009 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1009 AND nr_pytania = 2;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1009 AND nr_pytania = 3;
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1009 AND nr_pytania = 4;
UPDATE odpowiedzi SET ocena = NULL WHERE id_ankiety = 1009 AND nr_pytania = 5;
UPDATE odpowiedzi SET ocena = NULL WHERE id_ankiety = 1009 AND nr_pytania = 6;

UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1010 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1010 AND nr_pytania = 2;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1010 AND nr_pytania = 3;
UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 1010 AND nr_pytania = 4;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1010 AND nr_pytania = 5;
UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 1010 AND nr_pytania = 6;

UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1011 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 0 WHERE id_ankiety = 1011 AND nr_pytania = 2;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1011 AND nr_pytania = 3;
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1011 AND nr_pytania = 4;
UPDATE odpowiedzi SET ocena = NULL WHERE id_ankiety = 1011 AND nr_pytania = 5;
UPDATE odpowiedzi SET ocena = NULL WHERE id_ankiety = 1011 AND nr_pytania = 6;

UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1012 AND nr_pytania = 1;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1012 AND nr_pytania = 2;
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1012 AND nr_pytania = 3;
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1012 AND nr_pytania = 4;
UPDATE odpowiedzi SET ocena = 100 WHERE id_ankiety = 1012 AND nr_pytania = 5;
UPDATE odpowiedzi SET ocena = 50 WHERE id_ankiety = 1012 AND nr_pytania = 6;

COMMIT;
