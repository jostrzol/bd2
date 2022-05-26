CREATE OR REPLACE TRIGGER SG_ANK_WSTAW_ODPOWIEDZI
    AFTER INSERT ON ankiety
    FOR EACH ROW
DECLARE
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
    pytanie     pytania%ROWTYPE;
    ocena       odpowiedzi.ocena%TYPE;
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
            pytanie.kod_typu_ankiety, pytanie.nr_pytania, :new.id_ankiety,
            ocena
        );
    END LOOP;
END;
/

CREATE OR REPLACE TRIGGER SG_PYT_NIE_WSTAWIAJ_GDY_TANK_W_UZYCIU
    FOR DELETE ON odpowiedzi
COMPOUND TRIGGER
    /*
    Ten wyzwalacz nie pozwala usunąć odpowiedzi, dla której istnieje ankieta.
    Odpowiedzi można usuwać poprzez usunięcie całej ankiety dzięki regule
    ON DELETE CASCADE.
    
    W połączeniu z innymi wyzwalaczami z przedrostkiem "sg_" pozwala zapewnić
    integralność struktury generycznej złożonej z tabel:
        * typy_ankiet
        * pytania
        * ankiety
        * odpowiedzi. */
    TYPE typ_ankiety IS TABLE OF ankiety.id_ankiety%TYPE INDEX BY BINARY_INTEGER;
    
    numer_bledu         CONSTANT NUMBER(6)      := -20000;
    wiadomosc_bledu     CONSTANT VARCHAR(128)   := 'Nie można usunąć pojedynczych odpowiedzi. Aby usunąć odpowiedzi należy usunąć całą ankietę';
    
    usuniete_ankiety    typ_ankiety;
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

CREATE OR REPLACE TRIGGER SG_ODP_NIE_USUWAJ_GDY_ANK_ISTNIEJE
    BEFORE INSERT ON pytania
    FOR EACH ROW
DECLARE
    /*
    Ten wyzwalacz nie pozwala dodać pytań do typu ankiety, jeżeli istnieją już
    ankiety mające ten typ. Pozwala on zapobiec następującym sytuacjom, gdzie
    ankieta nie posiada odpowiedzi na wszystkie pytania po dodaniu nowego
    pytania do typu ankiety.
    
    Alternatywnym rozwiązaniem byłoby automatyczne wstawianie odpowiedzi do
    dotychczasowych ankiet nanowo dodane pytania, jednak w przypadku pytań
    obowiązkowych wiązałoby się to z przymusem wygenerowania sztucznej 
    odpowiedzi niebędącej NULL-em, która w rzeczywistości nie zaistniała.
    
    W połączeniu z innymi wyzwalaczami z przedrostkiem "sg_" pozwala zapewnić
    integralność struktury generycznej złożonej z tabel:
        * typy_ankiet
        * pytania
        * ankiety
        * odpowiedzi.
    */
    numer_bledu     CONSTANT NUMBER(6)      := -20001;
    wiadomosc_bledu CONSTANT VARCHAR(128)   := 'Nie można dodawać pytań do typu ankiety, który jest już w użyciu. Dodaj nowy typ ankiety.';
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

