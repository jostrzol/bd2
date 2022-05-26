CREATE OR REPLACE TRIGGER fknto_ankiety BEFORE
    UPDATE OF id_klienta ON ankiety
    FOR EACH ROW
    WHEN (new.id_klienta <> old.id_klienta)
BEGIN
    IF :old.id_klienta IS NOT NULL THEN
        raise_application_error(-20225, 'Non Transferable FK constraint ANK_KLI_FK on table Ankiety is violated');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER fkntm_ankiety BEFORE
    UPDATE OF kod_typu_ankiety, id_agenta ON ankiety
    FOR EACH ROW
    WHEN (new.kod_typu_ankiety <> old.kod_typu_ankiety or new.id_agenta <> old.id_agenta)
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint ANK_AGT_FK or ANK_TANK_FK on table Ankiety is violated');
END;
/

CREATE OR REPLACE TRIGGER fkntm_odpowiedzi BEFORE
    UPDATE OF kod_typu_ankiety, nr_pytania, id_ankiety ON odpowiedzi
    FOR EACH ROW
    WHEN (new.kod_typu_ankiety <> old.kod_typu_ankiety or new.nr_pytania <> old.nr_pytania or new.id_ankiety <> old.id_ankiety)
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint ODP_ANK_FK or ODP_PYT_FK on table Odpowiedzi is violated');
END;
/

CREATE OR REPLACE TRIGGER fkntm_pytania BEFORE
    UPDATE OF kod_typu_ankiety ON pytania
    FOR EACH ROW
    WHEN (new.kod_typu_ankiety <> old.kod_typu_ankiety)
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint PYT_TANK_FK on table Pytania is violated');
END;
/