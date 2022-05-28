set echo on;
set linesize 300;
set pagesize 500;
spool BD2C070.LIS;

-- średnie oceny ze wszystkich ankiet na każdego agenta
SELECT id_osoby, email, nazwisko, imie, ROUND(srednia_ocena, 2)
FROM srednie_oceny_osob;

-- średnie oceny ze wszystkich ankiet na każde pytanie
SELECT kod_typu_ankiety, nr_pytania, p.tresc,
    ROUND(AVG(o.ocena), 2) as srednia_ocena
FROM odpowiedzi o NATURAL JOIN pytania p
GROUP BY kod_typu_ankiety, nr_pytania, p.tresc
ORDER BY kod_typu_ankiety, nr_pytania;

-- średnie oceny ze wszystkich ankiet na każdy miesiąc
WITH miesiac_ankiety as (
    SELECT id_ankiety,
        EXTRACT(YEAR FROM ankiety.data_wypelnienia) as rok,
        EXTRACT(MONTH FROM ankiety.data_wypelnienia) as miesiac
    FROM ankiety)
SELECT rok, miesiac, ROUND(AVG(ocena), 2) as srednia_ocena
FROM odpowiedzi NATURAL JOIN miesiac_ankiety
GROUP BY rok, miesiac
ORDER BY rok DESC, miesiac DESC;

-- pracownik z najlepszą średnią ocen na obecny miesiąc (pracownik miesiąca)
WITH oceny_ten_miesiac as (
    SELECT id_agenta, ocena
    FROM odpowiedzi NATURAL JOIN ankiety
    WHERE ocena IS NOT NULL AND
        EXTRACT(YEAR FROM data_wypelnienia) = EXTRACT(YEAR FROM sysdate) AND
        EXTRACT(MONTH FROM data_wypelnienia) = EXTRACT(MONTH FROM sysdate))
SELECT os.id_osoby, os.email, os.nazwisko, os.imie, AVG(om.ocena) as srednia_ocen
FROM osoby os JOIN oceny_ten_miesiac om ON (os.id_osoby = om.id_agenta)
GROUP BY os.id_osoby, os.email, os.nazwisko, os.imie
ORDER BY srednia_ocen DESC
FETCH NEXT 1 ROW ONLY;

-- jaka część agentów ma nielepszą średnią ocenę na dane pytanie niż agent 1006
WITH sr_odp_agentow as (
    SELECT os.id_osoby, kod_typu_ankiety, nr_pytania, AVG(o.ocena) as srednia_ocena
    FROM odpowiedzi o NATURAL JOIN ankiety a JOIN osoby os ON (a.id_agenta = os.id_osoby)
    GROUP BY os.id_osoby, kod_typu_ankiety, nr_pytania)
SELECT dany_agt.kod_typu_ankiety, dany_agt.nr_pytania, ROUND(
        (
            -- liczba agentów z nielepszą średnią oceną za pytanie niż dany agent
            SELECT COUNT(*)
            FROM sr_odp_agentow
            WHERE dany_agt.kod_typu_ankiety = kod_typu_ankiety
                AND dany_agt.nr_pytania = nr_pytania
                AND srednia_ocena <= (
                    -- średnia ocena za pytanie danego agenta
                    SELECT srednia_ocena
                    FROM sr_odp_agentow
                    WHERE id_osoby = dany_agt.id_osoby
                        AND dany_agt.kod_typu_ankiety = kod_typu_ankiety
                        AND dany_agt.nr_pytania = nr_pytania
                )
        ) / (
            -- łączna liczba agentów z zarejestrowaną odpowiedzią na pytanie
            SELECT COUNT(*)
            FROM sr_odp_agentow
            WHERE dany_agt.kod_typu_ankiety = kod_typu_ankiety
                AND dany_agt.nr_pytania = nr_pytania
        )
    , 2) as niegorszy_od
FROM sr_odp_agentow dany_agt
WHERE dany_agt.id_osoby = 1006
ORDER BY dany_agt.kod_typu_ankiety, dany_agt.nr_pytania;

-- wszyscy pracownicy ze średnią ocen poniżej 50
SELECT *
FROM srednie_oceny_osob
WHERE srednia_ocena < 50;

-- wyświetl kto ocenił kogo w ankiecie i z jaką średnią oceną
SELECT
    NVL2(agt.id_osoby, agt.nazwisko || ' ' || agt.imie || ' ' || agt.imie_2, NULL) as agent,
    NVL2(kli.id_osoby, kli.nazwisko || ' ' || kli.imie || ' ' || kli.imie_2, NULL) as klient,
    ROUND(AVG(odp.ocena), 2) as srednia_ocena
FROM ankiety ank
    JOIN osoby agt ON (ank.id_agenta = agt.id_osoby)
    LEFT JOIN osoby kli ON (ank.id_klienta = kli.id_osoby)
    JOIN odpowiedzi odp ON (ank.id_ankiety = odp.id_ankiety)
GROUP BY
    ank.id_ankiety,
    agt.id_osoby, agt.nazwisko, agt.imie, agt.imie_2,
    kli.id_osoby, kli.nazwisko, kli.imie, kli.imie_2;

spool off;