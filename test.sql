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

-- jaka część agentow ma nielepszą średnią ocenę na dane pytanie niż agent 1007
WITH sr_odp_agentow as (
    SELECT os.id_osoby, kod_typu_ankiety, nr_pytania, AVG(o.ocena) as srednia_ocena
    FROM odpowiedzi o NATURAL JOIN ankiety a JOIN osoby os ON (a.id_agenta = os.id_osoby)
    GROUP BY os.id_osoby, kod_typu_ankiety, nr_pytania)
SELECT o1.kod_typu_ankiety, o1.nr_pytania, ROUND(
        (
            SELECT COUNT(*)
            FROM sr_odp_agentow
            WHERE id_osoby <> 1007
                AND o1.kod_typu_ankiety = kod_typu_ankiety
                AND o1.nr_pytania = nr_pytania
                AND srednia_ocena <= (
                    SELECT srednia_ocena
                    FROM sr_odp_agentow 
                    WHERE id_osoby = 1007 
                        AND o1.kod_typu_ankiety = kod_typu_ankiety
                        AND o1.nr_pytania = nr_pytania
                )
        ) / (
            SELECT COUNT(*)
            FROM sr_odp_agentow
            WHERE id_osoby <> 1007
                AND o1.kod_typu_ankiety = kod_typu_ankiety
                AND o1.nr_pytania = nr_pytania
        )
    , 2) as niegorszy_od
FROM sr_odp_agentow o1
WHERE o1.id_osoby = 1007
ORDER BY o1.kod_typu_ankiety, o1.nr_pytania;

-- wszyscy pracownicy ze średnią ocen poniżej 50
SELECT *
FROM srednie_oceny_osob
WHERE srednia_ocena < 50;

spool off;