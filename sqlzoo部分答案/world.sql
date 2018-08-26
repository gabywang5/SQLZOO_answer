
SELECT name, population, area
FROM world
WHERE (area > 3000000 AND population <= 250000000)
OR (area <= 3000000 AND population > 250000000);

SELECT name, ROUND(gdp/population,-3)
FROM world
WHERE gdp >= 1000000000000;

SELECT name
   FROM world
WHERE name LIKE '%a%' 
      AND name LIKE '%e%' 
      AND name LIKE '%i%' 
      AND name LIKE '%o%' 
      AND name LIKE '%u%'
      AND name NOT LIKE '% %';

SELECT name
FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Russia');

SELECT name 
FROM world
WHERE continent = 'Europe' 
AND gdp/population > 
(SELECT gdp/population FROM world WHERE name = 'United Kingdom');

SELECT name, continent FROM world
WHERE continent IN 
    (SELECT continent FROM world
     WHERE name IN ('Argentina', 'Australia')
     )
ORDER BY name;

SELECT name, population FROM world
WHERE population > 
(SELECT population FROM world WHERE name = 'Canada') 
AND population < 
(SELECT population FROM world WHERE name = 'Poland');

SELECT name, CONCAT((ROUND(100 * population/
              (SELECT population FROM world 
                WHERE name = 'Germany'))),'%')
FROM world
WHERE continent = 'Europe';

SELECT name FROM world
WHERE gdp > ALL(SELECT gdp 
             FROM world 
             WHERE gdp > 0 
             AND continent = 'Europe');

SELECT continent, name, area FROM world AS X
WHERE area >= ALL(SELECT area FROM world AS Y
                  WHERE Y.continent = X.continent
                  AND area > 0);

SELECT continent, name FROM world AS X
WHERE name <= ALL(SELECT name FROM world AS Y
                  WHERE Y.continent = X.continent);

SELECT y.name, y.continent, y.population
FROM world AS y
JOIN
(SELECT continent,max(population)
FROM world
GROUP BY continent
HAVING max(population) <= 25000000) AS x
ON y.continent = x.continent

SELECT continent, MIN(population)
FROM world
GROUP BY continent

SELECT name, continent
FROM world x
WHERE population > 
    ALL(SELECT population*3 FROM world y 
        WHERE x.continent = y.continent 
        AND population > 0 AND y.name != x.name)

-- Select the code that shows the name, region and population of the smallest country in each region
SELECT name, region, population FROM bbc AS X
WHERE population <= ALL(SELECT population FROM bbc AS Y
                        WHERE Y.region = X.region
                        AND population > 0);

SELECT name, region, population FROM bbc AS X
WHERE 50000 < ALL(SELECT population FROM bbc AS Y
                  WHERE X.region = Y.region
                  AND Y.population > 0);



