-- średnie oceny ze wszystkich ankiet na każdego agenta
SELECT os.id_osoby, os.email, os.nazwisko, os.imie, ROUND(AVG(o.ocena), 2) as srednia_ocena
    FROM odpowiedzi o NATURAL JOIN ankiety a RIGHT JOIN osoby os ON (a.id_agenta = os.id_osoby)
    GROUP BY os.id_osoby, os.email, os.nazwisko, os.imie;

-- średnie oceny ze wszystkich ankiet na każde pytanie
SELECT kod_typu_ankiety, nr_pytania, p.tresc, ROUND(AVG(o.ocena), 2) as srednia_ocena
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