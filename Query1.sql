USE md_water_services;

SELECT DISTINCT type_of_water_source FROM water_source;

SELECT DISTINCT
    type_of_water_source
FROM
    water_source
LIMIT 5;

SELECT 
    *
FROM
    visits
WHERE
    time_in_queue > 500;
    
SELECT 
    *
FROM
    water_source
WHERE
    source_id IN ('AkKi00881224' , 'SoRu37635224',
        'SoRu36096224',
        'AkRu05234224',
        'HaZa21742224');
        
SELECT 
    *
FROM
    water_quality
WHERE
    subjective_quality_score = 10
AND visit_count >= 2;

SET SQL_SAFE_UPDATES = 0;

SELECT 
    *
FROM
    well_pollution
WHERE
 description like '%clean%'
	and biological > 0.01;
        
UPDATE well_pollution 
SET 
    description = 'Bacteria: Giardia Lamblia'
WHERE
    description = 'Clean Bacteria: Giardia Lamblia';

CREATE TABLE
md_water_services.well_pollution_copy
AS (
SELECT
*
FROM
md_water_services.well_pollution
);

UPDATE
well_pollution_copy
SET
description = 'Bacteria: E. coli'
WHERE
description = 'Clean Bacteria: E. coli';
UPDATE
well_pollution_copy
SET
description = 'Bacteria: Giardia Lamblia'
WHERE
description = 'Clean Bacteria: Giardia Lamblia';
UPDATE
well_pollution_copy
SET
results = 'Contaminated: Biological'
WHERE
biological > 0.01 AND results = 'Clean';

SELECT * FROM well_pollution_copy;

SELECT
*
FROM
well_pollution_copy
WHERE
description LIKE "Clean_%"
OR (results = "Clean" AND biological > 0.01);
    
 SELECT 
    *
FROM
    water_source
WHERE number_of_people_served > 3995;

SELECT *
FROM employee
WHERE position = 'Field Surveyor'
AND (phone_number LIKE '%86%' OR phone_number LIKE '%11%')
AND (
  SUBSTRING_INDEX(employee_name, ' ', -1) LIKE 'A%' 
  OR SUBSTRING_INDEX(employee_name, ' ', -1) LIKE 'M%'
);

SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;

SELECT * 
FROM well_pollution
WHERE description
IN ('Parasite: Cryptosporidium', 'biologically contaminated')
OR (results = 'Clean' AND biological > 0.01);

SELECT
*
FROM
    global_water_access;
