-- Find all details of the prize won by EUGENE O'NEILL
-- Escaping single quotes
-- You can't put a single quote in a quote string directly. 
-- You can use two single quotes within a quoted string.
SELECT *
FROM nobel
WHERE winner = 'EUGENE O''NEILL';

SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner; 

-- 14.
SELECT winner, subject
  FROM nobel
 WHERE yr=1984
 ORDER BY 
 CASE WHEN subject IN ('Physics','Chemistry') 
      THEN 1 
      ELSE 0 
      END,
      subject, winner;

SELECT yr
FROM nobel
WHERE subject = 'Medicine'