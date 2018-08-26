-- More JOIN 

-- List the films where the yr is 1962 [Show id, title]
SELECT id,title
FROM movie
WHERE yr = 1962;

-- When was Citizen Kane released?
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

-- What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name = 'Glenn Close';

-- What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca';

-- Obtain the cast list for 'Casablanca'.
-- what is a cast list?
-- The cast list is the names of the actors who were in the movie.
-- Use movieid=11768, (or whatever value you got from the previous question)
SELECT name
FROM casting JOIN actor ON actorid=id
WHERE movieid = 11768;

-- Obtain the cast list for the film 'Alien'
SELECT name FROM actor
WHERE id IN
(SELECT actorid
FROM casting JOIN movie ON movieid=id
WHERE title = 'Alien');

-- List the films in which 'Harrison Ford' has appeared
SELECT title
FROM casting JOIN movie ON movieid=id
WHERE actorid = (
SELECT id FROM actor WHERE name = 'Harrison Ford'
);

-- List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT title FROM movie
WHERE id IN 
(SELECT movieid 
FROM casting JOIN actor ON actorid = id
WHERE name = 'Harrison Ford' AND ord != 1);

-- List the films together with the leading star for all 1962 films.
SELECT title, name 
FROM movie AS M JOIN casting AS C ON M.id = C.movieid JOIN actor AS A ON C.actorid = A.id
WHERE yr = 1962 AND ord = 1;

-- 11.Busy years for John Travolta
-- Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
-- solution1
SELECT yr, COUNT(title)
FROM movie AS M JOIN casting AS C ON M.id = C.movieid JOIN actor AS A ON C.actorid = A.id
WHERE name = 'John Travolta'
GROUP BY yr
HAVING COUNT(title) > 2;

-- solution2
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t
)
-- 12.Lead actor in Julie Andrews movies
-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
-- solution1
SELECT title, name
FROM movie AS M JOIN casting AS C ON M.id = C.movieid JOIN actor AS A ON C.actorid = A.id
WHERE M.id IN 
(SELECT movieid
FROM movie AS M JOIN casting AS C ON M.id = C.movieid JOIN actor AS A ON C.actorid = A.id
WHERE name = 'Julie Andrews')
AND ord = 1;

-- solution2
SELECT title, name
FROM movie AS M JOIN casting AS C ON M.id = C.movieid JOIN actor AS A ON C.actorid = A.id
WHERE M.id IN 
(SELECT movieid FROM casting
WHERE actorid IN (
  SELECT id FROM actor
  WHERE name='Julie Andrews'))
AND ord = 1;
-- 待解决的问题：子查询跟JOIN哪个性能更优？

-- 13.Actors with 30 leading roles
-- Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
SELECT name FROM actor
WHERE id IN
(SELECT actorid
FROM casting
WHERE ord = 1
GROUP BY actorid
HAVING COUNT(*) >= 30)
ORDER BY name;

-- 14.List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(*)
FROM movie JOIN casting ON movieid = id
WHERE yr=1978
GROUP BY title
ORDER BY COUNT(*) DESC,title;

-- 以15题为例，讲解复杂查询如何理清思路
-- find the 'Art Garfunkel' id
SELECT id FROM actor WHERE name = 'Art Garfunkel'
-- find movie that 'Art Garfunkel' in
SELECT movieid FROM casting
WHERE actorid = (SELECT id FROM actor WHERE name = 'Art Garfunkel')
-- find id work with 
SELECT actorid FROM casting
WHERE movieid IN
(SELECT movieid FROM casting
WHERE actorid = (SELECT id FROM actor WHERE name = 'Art Garfunkel') )

-- 15.List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT name FROM actor
WHERE id IN 
(SELECT actorid FROM casting
WHERE movieid IN
(SELECT movieid FROM casting
WHERE actorid = (SELECT id FROM actor WHERE name = 'Art Garfunkel') ))
AND name != 'Art Garfunkel';

