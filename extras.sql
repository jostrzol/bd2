-- Generated by Oracle SQL Developer Data Modeler 21.2.0.165.1515
--   at:        2022-05-29 01:24:32 CEST
--   site:      Oracle Database 21c
--   type:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE OR REPLACE VIEW Srednie_oceny_osob ( id_osoby, email, nazwisko, imie, srednia_ocena ) AS
SELECT
    os.id_osoby,
    os.email,
    os.nazwisko,
    os.imie,
    AVG(o.ocena) AS srednia_ocena
FROM
         odpowiedzi o
    INNER JOIN ankiety a ON ( o.id_ankiety = a.id_ankiety )
    INNER JOIN osoby   os ON ( a.id_agenta = os.id_osoby )
GROUP BY
    os.id_osoby,
    os.email,
    os.nazwisko,
    os.imie 
;


COMMENT ON TABLE Srednie_oceny_osob IS 'Pozwala na łatwy, szybki wgląd w średnie oceny agentów.'
;


GRANT DELETE, INSERT, SELECT, UPDATE 
ON Srednie_oceny_osob TO BD2C070_APP 
;

ALTER VIEW srednie_oceny_osob ADD CONSTRAINT sred_osb_pk PRIMARY KEY ( id_osoby ) DISABLE;

CREATE OR REPLACE VIEW Srednie_oceny_pytan ( kod_typu_ankiety, nr_pytania, tresc, srednia_ocena ) AS
SELECT
    p.kod_typu_ankiety,
    p.nr_pytania,
    p.tresc,
    AVG(o.ocena) AS srednia_ocena
FROM
         odpowiedzi o
    INNER JOIN pytania p ON o.kod_typu_ankiety = p.kod_typu_ankiety
                            AND o.nr_pytania = p.nr_pytania
GROUP BY
    p.kod_typu_ankiety,
    p.nr_pytania,
    p.tresc 
;


COMMENT ON TABLE Srednie_oceny_pytan IS 'Pozwala na łatwy, szybki wgląd w średnie oceny dla każdego pytania.'
;


GRANT DELETE, INSERT, SELECT, UPDATE 
ON Srednie_oceny_pytan TO BD2C070_APP 
;

ALTER VIEW srednie_oceny_pytan ADD CONSTRAINT sred_pyt_pk PRIMARY KEY ( kod_typu_ankiety,
                                                                        nr_pytania ) DISABLE;

CREATE OR REPLACE TRIGGER SG_ANK_WSTAW_ODPOWIEDZI 
    AFTER INSERT ON Ankiety 
    FOR EACH ROW 
/*
Ten wyzwalacz, po wstawieniu nowej ankiety, wstawia do niej 
odpowiedzi na wszystkie pytania.

W połączeniu z innymi wyzwalaczami z przedrostkiem "sg_" pozwala zapewnić
integralność struktury generycznej złożonej z tabel:
    * typy_ankiet
    * pytania
    * ankiety
    * odpowiedzi.

Jeżeli pytanie jest obowiązkowe, to domyślną wartością stworzonych
odpowiedzi jest 0, a jeżeli jest nieobowiązkowe, to NULL.
*/
DECLARE
	pytanie	pytania%ROWTYPE;
	ocena	odpowiedzi.ocena%TYPE;
BEGIN
	FOR pytanie IN (
	   SELECT *
	   FROM pytania
	   WHERE kod_typu_ankiety = :new.kod_typu_ankiety
	)
	LOOP
		ocena := 0;
		IF pytanie.czy_opcjonalne = 1 THEN
			ocena := NULL;
		END IF;
		
		INSERT INTO odpowiedzi VALUES (
			pytanie.kod_typu_ankiety, pytanie.nr_pytania,
			:new.id_ankiety, ocena
);
	END LOOP;
END; 
/

CREATE OR REPLACE TRIGGER SG_ODP_NIE_USUWAJ_GDY_ANK_ISTNIEJE 
    BEFORE INSERT ON Pytania 
    FOR EACH ROW 
/*
Ten wyzwalacz nie pozwala dodać pytań do typu ankiety, jeżeli istnieją już
ankiety mające ten typ. Pozwala on zapobiec następującym sytuacjom, gdzie
ankieta nie posiada odpowiedzi na wszystkie pytania po dodaniu nowego
pytania do typu ankiety.

Alternatywnym rozwiązaniem byłoby automatyczne wstawianie odpowiedzi do
dotychczasowych ankiet nanowo dodane pytania, jednak w przypadku pytań
obowiązkowych wiązałoby się to z przymusem wygenerowania sztucznej 
odpowiedzi niebędącej NULL-em, która w rzeczywistości nie zaistniała.

W połączeniu z innymi wyzwalaczami z przedrostkiem "SG_" pozwala zapewnić
integralność struktury generycznej złożonej z tabel:
    * typy_ankiet
    * pytania
    * ankiety
    * odpowiedzi.
*/
DECLARE
	numer_bledu	 CONSTANT NUMBER(6)      := -20001;
	wiadomosc_bledu CONSTANT VARCHAR(128)   := 
		'Nie można dodawać pytań do typu ankiety, ' ||
		'który jest już w użyciu. Dodaj nowy typ ankiety.';
	
	l_ankiet        NUMBER(1); 
BEGIN
	SELECT COUNT(*) INTO l_ankiet
	FROM ankiety
	WHERE kod_typu_ankiety = :new.kod_typu_ankiety;

	IF l_ankiet <> 0 THEN
		raise_application_error(numer_bledu, wiadomosc_bledu);
	END IF;
END; 
/

CREATE OR REPLACE TRIGGER SG_ODP_OCENA_NIE_NULL_DLA_OBOWIAZKOWYCH 
    BEFORE UPDATE ON Odpowiedzi 
    FOR EACH ROW 
    WHEN ( new.ocena IS NULL ) 
/*
Ten wyzwalacz nie pozwala ustawić oceny na wartość NULL dla odpowiedzi
na pytania obowiązkowe.

W połączeniu z innymi wyzwalaczami z przedrostkiem "SG_" pozwala zapewnić
integralność struktury generycznej złożonej z tabel:
    * typy_ankiet
    * pytania
    * ankiety
    * odpowiedzi.
*/
DECLARE
    numer_bledu     CONSTANT NUMBER(6)      := -20002;
    wiadomosc_bledu CONSTANT VARCHAR(128)   :=
        'Ocena musi mieć wartość określoną dla pytań obowiązkowych';

    czy_opcjonalne  Pytania.czy_opcjonalne%TYPE;
BEGIN
    SELECT czy_opcjonalne INTO czy_opcjonalne
    FROM pytania
    WHERE kod_typu_ankiety = :old.kod_typu_ankiety
        AND nr_pytania = :old.nr_pytania;

    IF czy_opcjonalne = 0 THEN
        raise_application_error(numer_bledu, wiadomosc_bledu);
    END IF;
END; 
/

CREATE OR REPLACE TRIGGER SG_PYT_NIE_WSTAWIAJ_GDY_TANK_W_UZYCIU 
    FOR DELETE ON Odpowiedzi 
compound trigger
/*
Ten wyzwalacz nie pozwala usunąć odpowiedzi, dla której istnieje ankieta.
Odpowiedzi można usuwać poprzez usunięcie całej ankiety dzięki regule
ON DELETE CASCADE.

W połączeniu z innymi wyzwalaczami z przedrostkiem "sg_" pozwala zapewnić
integralność struktury generycznej złożonej z tabel:
* typy_ankiet
* pytania
* ankiety
* odpowiedzi.
*/
TYPE typ_ankiety IS TABLE OF ankiety.id_ankiety%TYPE INDEX BY BINARY_INTEGER;

numer_bledu         CONSTANT NUMBER(6)      := -20000;
wiadomosc_bledu     CONSTANT VARCHAR(128)   :=
	'Nie można usunąć pojedynczych odpowiedzi. ' ||
	'Aby usunąć odpowiedzi należy usunąć całą ankietę';

usuniete_ankiety	typ_ankiety;
czy_znaleziony      BOOLEAN;
l_ankiet            NUMBER(1);

AFTER EACH ROW IS
BEGIN
	czy_znaleziony := FALSE;
	
	FOR i IN 1 .. usuniete_ankiety.COUNT
	LOOP
		IF usuniete_ankiety(i) = :old.id_ankiety THEN
			czy_znaleziony := TRUE;
			EXIT;
		END IF;
	END LOOP;
	
	IF NOT czy_znaleziony THEN
		usuniete_ankiety (usuniete_ankiety.COUNT + 1) := :old.id_ankiety;
	END IF;
END AFTER EACH ROW;

AFTER STATEMENT IS
BEGIN
	FOR i IN 1 .. usuniete_ankiety.COUNT
	LOOP
		SELECT COUNT(*) INTO l_ankiet
		FROM ankiety
		WHERE id_ankiety = usuniete_ankiety(i);
		
		IF l_ankiet <> 0 THEN
			raise_application_error(numer_bledu, wiadomosc_bledu);
		END IF;
	END LOOP;
END AFTER STATEMENT;

END; 
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             0
-- CREATE INDEX                             0
-- ALTER TABLE                              0
-- CREATE VIEW                              2
-- ALTER VIEW                               2
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           4
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
