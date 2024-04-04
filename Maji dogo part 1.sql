-- THIS IS TO SHOW ALL THE TABLES IN THE DATABSE
SHOW TABLES;

-- THIS TO PREVIEV THE FIRST FIVE COLUMNS IN EACH TABLE. JUST SWITCH THE TABLE NAME IN THE FROM STATEMENT.
SELECT *
FROM data_dictionary
LIMIT 5;

-- SHOWS THE VARIOUS WATER TYPES OUR DATA IS ABOUT
SELECT distinct type_of_water_source
FROM water_source
LIMIT 5 ;

-- SHOWS OCCASSIONS WHERE PEOPLE QUEUE FOR WATER MORE THAN 8 HOURS OR 500 MINS
SELECT *
FROM visits
WHERE time_in_queue > 500 ;

-- COMBINED FEW OF SOME WATER SOURCES WITH EITHER LONGER OR SHORT QUEUE TIME
SELECT *
FROM water_source
WHERE source_id IN ('SoRu36096224', 'SoRu37635224', 'AkKi00881224','AkRu05234224','HaZa21742224');

-- SHOWING THE SOURCES THAT HAVE THE LONG QUEUE TIMES. 
SELECT 
water_source.type_of_water_source,
water_source.number_of_people_served,
visits.time_in_queue
FROM water_source
JOIN visits ON visits.source_id = water_source.source_id
WHERE time_in_queue >500 ;

-- SHOWING SOURCES WITH SHORTER QUEUE TIME
SELECT 
water_source.type_of_water_source,
water_source.number_of_people_served,
visits.time_in_queue
FROM water_source
JOIN visits ON visits.source_id = water_source.source_id
WHERE time_in_queue <10 ;

  
  -- CHECKING WELLS column
  SELECT *
  FROM well_pollution
  LIMIT 5 ;

SELECT *
FROM well_pollution
WHERE results = "clean"  and biological > 0.01;

-- cases where a well was mistakenly noted as being clean
SELECT *
FROM well_pollution
WHERE description LIKE 'clean_%' and results = "Clean";

-- we make a copy of the well pollution table before editing it to make sure our query is right
CREATE TABLE
md_water_services.well_pollution_copy
AS (
SELECT
*
FROM
md_water_services.well_pollution
);


-- I run this query to edit the copy of the pollution table and correct instances where a well was mistakenly determined as clean
SET SQL_SAFE_UPDATES = 0;

UPDATE
well_pollution_copy
SET
description = 'Bacteria
:
E
. coli'

WHERE
description = 'Clean Bacteria
:
E
. coli';

SET SQL_SAFE_UPDATES = 0;
UPDATE
well_pollution_copy
SET
description = 'Bacteria

: Giardia Lamblia'

WHERE
description = 'Clean Bacteria

: Giardia Lamblia';

SET SQL_SAFE_UPDATES = 0;
UPDATE
well_pollution_copy
SET
results = 'Contaminated

: Biological'

WHERE
biological > 0.01 AND results = 'Clean';

-- rerun the query we used to check for situations where a well as mistakenly declared as clean to see if our code worked
SELECT *
FROM well_pollution_copy
WHERE description LIKE 'clean_%' and results = "Clean";

-- (more cheks) We can then check if our errors are fixed using a SELECT query on the well_pollution_copy table
SELECT
*
FROM
well_pollution_copy
WHERE
description LIKE "Clean_%"
OR (results = "Clean" AND biological > 0.01);

-- running the query now in the well pollution table after confirming it workes well
SET SQL_SAFE_UPDATES = 0;
UPDATE
well_pollution
SET
description = 'Bacteria: E. coli'
WHERE
description = 'Clean Bacteria: E. coli';

SET SQL_SAFE_UPDATES = 0;
UPDATE
well_pollution
SET
description = 'Bacteria: Giardia Lamblia'
WHERE
description = 'Clean Bacteria: Giardia Lamblia';

SET SQL_SAFE_UPDATES = 0;
UPDATE
well_pollution
SET
results = 'Contaminated: Biological'
WHERE
biological > 0.01 AND results = 'Clean';

-- deletes the well_pollution_copy we made
DROP TABLE
md_water_services.well_pollution_copy;