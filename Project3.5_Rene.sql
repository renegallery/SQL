# 1
SELECT Continent, count(1) AS Count
FROM country
WHERE GovernmentForm="Constitutional Monarchy" 
GROUP BY Continent;

# 2
SELECT DISTINCT city.Name, Continent, country.Population
FROM country INNER JOIN city ON country.Capital=city.ID
WHERE Code IN (
	SELECT CountryCode
    FROM countrylanguage
    WHERE Percentage>85);

# 3
SELECT total.Continent, total_pop, largest_city
FROM(
	SELECT Continent, SUM(country.Population) AS total_pop
	FROM country
	GROUP BY Continent) AS total
	JOIN(
	SELECT DISTINCT Continent, city.Name AS largest_city
	FROM country, city
	WHERE country.Code=city.CountryCode
    AND (country.Continent, city.Population) IN (
		SELECT Continent, MAX(city.Population)
		FROM country, city
        WHERE country.Code=city.CountryCode
		GROUP BY Continent)
	) AS largest
    ON total.Continent=largest.Continent;

# 4
SELECT country.Name AS Country, city.Name AS Capital
FROM country JOIN city ON country.Capital=city.ID
WHERE country.Code IN(
	SELECT CountryCode
    FROM countrylanguage
    WHERE Percentage>5
    GROUP BY CountryCode
    HAVING count(Language)>1);
    
# 5
SELECT AVG(LifeExpectancy)
FROM country
WHERE country.Code IN(
	SELECT CountryCode
    FROM countrylanguage
    WHERE Language="English"
    AND (CountryCode,Percentage) IN (
		SELECT CountryCode, MAX(Percentage)
        FROM countrylanguage
        GROUP BY CountryCode));

# 6 
SELECT DISTINCT city.Name
FROM country JOIN city ON country.Capital=city.ID,
    (SELECT Continent, AVG(LifeExpectancy) AS Avg_LE
    FROM country
    GROUP BY Continent) AS Continent
WHERE LifeExpectancy > Continent.Avg_LE
AND Continent.Continent=country.Continent;

