/*
Aufgaben: Mondial Datenbank
1. Alle Ländern mit Haupstadt Größer als 5'000'000 Einwohner
2. Alle Ländern mit Hauptstadt mit Anfangbuchstaben 'B' oder 'C' oder 'D'
3. Alle Städte in Österreich (in der Schweiz)
4. Anzahl Städte pro Land (Länder sind alphabetisch sortiert)
5. Alle Nachbarländern von Österreich (von der Schweiz) -- siehe borders Tabelle
6. Alle Ländern die Nachbarland von Österreich sind, aber nicht von der Schweiz
7. Top 10 Ländern mit den meisten Nachbarländern
8. Top 10 dichtesten bewohntes Land
9. Top 10 dichtesten bewohnten Bundesland in Deutschland -- siehe province Tabelle
10. Top 10 Ländern mit dem meisten Bundesländer
*/
USE Mondial;

-- 1. Alle Ländern mit Haupstadt Größer als 5'000'000 Einwohner
SELECT country.Name AS country, country.capital AS capital, city.Population AS CapitalPopulation 
FROM country
JOIN city ON country.Capital = city.name
WHERE city.Population >= 5000000
ORDER BY CapitalPopulation DESC;

-- 2. Alle Ländern mit Hauptstadt mit Anfangbuchstaben 'B' oder 'C' oder 'D'
SELECT Name AS Country, Capital
FROM country
WHERE capital LIKE 'B%' OR capital LIKE 'C%' OR capital LIKE 'D%'
ORDER BY capital ASC;

-- 3. Alle Städte in Österreich
SELECT city.Name AS City, country.Name AS Country
FROM city
JOIN country on country.Code = city.country
WHERE Country = 'A'; 

-- 4. Anzahl Städte pro Land (Länder sind alphabetisch sortiert)
SELECT country.name AS country, count(city.name) AS NumberOfCities FROM city
JOIN country on country.Code = city.country
GROUP BY country.name
ORDER BY NumberOfCities DESC;

-- 5. Alle Nachbarländern von Österreich (von der Schweiz) -- siehe borders Tabelle

SELECT country.name FROM borders
JOIN country ON borders.country2 = country.code
WHERE country1 = 'A';


-- Lukas Ansatz
SELECT *
FROM (
(SELECT Country1, Country2 FROM borders)
UNION (
SELECT Country2, Country1 FROM borders)
) AS combined 
WHERE Country1 = 'A'
ORDER BY Country1;


-- 6. Alle Ländern die Nachbarland von Österreich sind, aber nicht von der Schweiz
select Country.Name
FROM (
    SELECT Country1 c FROM borders WHERE Country2 = 'A'
    UNION
    SELECT Country2 c FROM borders WHERE Country1 = 'A'
) A
JOIN Country ON Code = a.c
LEFT JOIN
(
    SELECT Country1 c FROM borders WHERE Country2 = 'CH'
    UNION
    SELECT Country2 c FROM borders WHERE Country1 = 'CH'
    UNION
    SELECT 'CH' c
) B on a.c = b.c
WHERE b.c IS NULL;

-- alternativ
SELECT Country.Name
FROM (
    SELECT Country1 c FROM borders WHERE Country2 = 'A'
    UNION
    SELECT Country2 c FROM borders WHERE Country1 = 'A'
) A
JOIN Country ON Code = a.c
WHERE c NOT IN 
(
    SELECT Country1 c FROM borders WHERE Country2 = 'CH'
    UNION
    SELECT Country2 c FROM borders WHERE Country1 = 'CH'
    UNION
    SELECT 'CH' c
);


-- 7. Top 10 Ländern mit den meisten Nachbarländern

SELECT country c, SUM(neighbours) AS n FROM
((SELECT country1 AS country, count(country2) AS neighbours FROM borders
GROUP BY country)
UNION ALL
(SELECT country2 AS country, count(country1) AS neighbours FROM borders
GROUP BY country)) AS sum
GROUP BY c
ORDER BY n DESC
LIMIT 10
;


-- Variante Gyula:
SELECT country AS c, count(neighbour) AS n FROM
(
SELECT country1 AS country, country2 AS neighbour FROM borders
UNION
SELECT country2 AS country, country1 AS neighbour FROM borders
) AS A
GROUP BY c
ORDER BY n DESC;



-- 8. Top 10 dichtesten bewohntes Land
SELECT Name, ROUND((Population/area),0) AS Density  FROM country
ORDER BY Density DESC
LIMIT 10;

-- 9. Top 10 dichtesten bewohnten Bundesland in Deutschland -- siehe province Tabelle
SELECT Name, ROUND((Population/area),0) AS Density  FROM province
WHERE Country = 'D'
ORDER BY Density DESC
LIMIT 10;

-- 10. Top 10 Ländern mit dem meisten Bundesländer
SELECT country.name, COUNT(province.name) FROM province, country
WHERE province.country = country.code
GROUP BY country.name
ORDER BY COUNT(province.Name) DESC
LIMIT 10;

-- Irene: Länder geordnet nach dem längsten Fluss (Land der Quelle)
SELECT river.name AS River, country.name AS Country FROM river
JOIN geo_source ON geo_source.river = river.name
JOIN country ON  country.code = geo_source.country
ORDER BY length DESC
LIMIT 10;

-- Bokhee: Asiatisches land mit der niedrigsten Bevölkerungsdichte
SELECT Name, ROUND(Population/Area,2) AS Density FROM country
JOIN encompasses ON encompasses.country = country.code
WHERE encompasses.Continent = 'Asia'
ORDER BY Density ASC
LIMIT 5;


--  Sabrina: Top 10 Sprachen in Europa
SELECT Lang, SUM(NativeSpeakers) AS NS FROM (
	SELECT language.Name AS Lang, ROUND(Country.Population*language.Percentage/100,0) AS NativeSpeakers FROM language
	JOIN Country ON Country.code = language.Country
	JOIN encompasses ON encompasses.Country = language.Country
	WHERE encompasses.Continent = 'Europe'
    ) AS A
GROUP BY Lang
ORDER BY NS DESC
LIMIT 10;




/*
Aufgaben 2:
1. Durch welche Ländern fließt der Rhein?
2. Welche Ländern liegen am Bodensee?
3. Durch welche Ländern fließt der Rhein, die NICHT am Bodensee liegen?
4. Welche Sprachen sind offizielle Sprachen in Europa die keine Sprache sind in anderen Kontinenten?
5. Wie viel Ländern verwenden mindensten 2 ofiziellen Sprachen?
6. Wie viele Ländern in Europa verwenden ausschließlich 1 Sprache?
7. Erstelle eine Abfrage die als Ergebnis "Schönes Wochenenede!" wünscht
*/

-- 1. Durch welche Ländern fließt der Rhein?
SELECT Country.name  AS c
FROM geo_river 
JOIN country ON country.code = geo_river.country
WHERE River = 'Rhein'
GROUP BY Country;

-- 2. Welche Ländern liegen am Bodensee?
SELECT Country.name AS c FROM geo_lake
JOIN country ON country.code = geo_lake.country
WHERE Lake = 'Bodensee'
GROUP BY Country;

-- 3. Durch welche Ländern fließt der Rhein, die NICHT am Bodensee liegen
SELECT DISTINCT Country.name FROM geo_river
JOIN country ON country.code = geo_river.country
WHERE River = 'Rhein' AND geo_river.Country NOT IN(
SELECT DISTINCT geo_lake.Country FROM geo_lake
WHERE Lake = 'Bodensee'
)
;

-- 4. Welche Sprachen sind offizielle Sprachen in Europa die keine Sprache sind in anderen Kontinenten?
SELECT DISTINCT language.name FROM language
JOIN encompasses ON encompasses.country = language.Country
WHERE encompasses.Continent = 'Europe' AND language.name NOT IN(
	SELECT DISTINCT language.name FROM language
	JOIN encompasses ON encompasses.country = language.Country
	WHERE encompasses.Continent <> 'Europe'
)
;

-- 5. Wie viel Ländern verwenden mindensten 2 ofiziellen Sprachen?
SELECT count(*) AS Countries FROM (
	SELECT Country, count(*) AS cnt FROM Language
	GROUP BY Country
) AS C 
WHERE C.cnt >= 2 
;

-- 6. Wie viele Ländern in Europa verwenden ausschließlich 1 Sprache?
SELECT *  FROM (
	SELECT language.Country AS c, count(*) AS cnt FROM language
	JOIN encompasses ON encompasses.country = language.country
	WHERE encompasses.Continent = 'Europe'
	GROUP BY c
) AS A
WHERE cnt = 1;


-- 7. Erstelle eine Abfrage die als Ergebnis "Schönes Wochenenede!" wünscht
SELECT 'Schönes Wochenenede!' AS c;


-- Hauptstädte auf Insel
SELECT * FROM Country
JOIN locatedOn ON LocatedOn.City = Country.Capital AND LocatedOn.country = Country.Code;

-- Hauptstädte nicht am Gewässer



SELECT * FROM Mondial.borders
WHERE Country1 = 'D';