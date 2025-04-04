USE md_water_services;
/* We start the query by joining specific columns in location to visit*/
SELECT
    loc.Province_name,
    loc.Town_name,
    v. Visit_count,
    v. Location_id
FROM
    Location as loc
JOIN
    visits as v
ON
    loc.location_id = v.location_id;
    
/* We then proceed to JOIN water quality table to the data set*/
SELECT
    loc.Province_name,
    loc.Town_name,
    v. Visit_count,
    v. Location_id,
    ws.type_of_water_source,
    ws.Number_of_people_served
FROM
    Location as loc
JOIN
    visits as v
ON
    loc.location_id = v.location_id
JOIN 
    water_source as ws
ON
   v.source_id = ws.source_id;
   
 /* CHECK 'AkHa00103' */  
SELECT
loc.Province_name,
    loc.Town_name,
    v. Visit_count,
    v. Location_id,
    ws.type_of_water_source,
    ws.Number_of_people_served
FROM
    Location as loc
JOIN
    visits as v
ON
    loc.location_id = v.location_id
JOIN 
    water_source as ws
ON
   v.source_id = ws.source_id
WHERE v.location_id = 'AkHa00103';

SELECT
loc.Province_name,
    loc.Town_name,
    v. Visit_count,
    v. Location_id,
    ws.type_of_water_source,
    ws.Number_of_people_served
FROM
    Location as loc
JOIN
    visits as v
ON
    loc.location_id = v.location_id
JOIN 
    water_source as ws
ON
   v.source_id = ws.source_id
WHERE v.visit_count = 1;

/*we now proceed to remove location_id and visit_count columns as they are not important to us now and replace with location_type and time_in_queue */

SELECT
    loc.Province_name,
    loc.Town_name,
    v.time_in_queue,
    loc.location_type,
    ws.type_of_water_source,
    ws.Number_of_people_served
FROM
    Location as loc
JOIN
    visits as v
ON
    loc.location_id = v.location_id
JOIN 
    water_source as ws
ON
   v.source_id = ws.source_id
WHERE 
v.visit_count = 1;

SELECT
water_source.type_of_water_source,
location.town_name,
location.province_name,
location.location_type,
water_source.number_of_people_served,
visits.time_in_queue,
well_pollution.results
FROM
visits
LEFT JOIN
well_pollution
ON well_pollution.source_id = visits.source_id
INNER JOIN
location
ON location.location_id = visits.location_id
INNER JOIN
water_source
ON water_source.source_id = visits.source_id
WHERE
visits.visit_count = 1;

CREATE VIEW combined_analysis_table AS
SELECT
water_source.type_of_water_source AS source_type,
location.town_name,
location.province_name,
location.location_type,
water_source.number_of_people_served AS people_served,
visits.time_in_queue,
well_pollution.results
FROM
visits
LEFT JOIN
well_pollution
ON well_pollution.source_id = visits.source_id
INNER JOIN
location
ON location.location_id = visits.location_id
INNER JOIN
water_source
ON water_source.source_id = visits.source_id
WHERE
visits.visit_count = 1;

WITH province_totals AS (-- This CTE calculates the population of each province
SELECT
province_name,
SUM(people_served) AS total_ppl_serv
FROM
combined_analysis_table
GROUP BY
province_name
)
SELECT
ct.province_name,
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table ct
JOIN
province_totals pt ON ct.province_name = pt.province_name
GROUP BY
ct.province_name
ORDER BY
ct.province_name;

WITH province_totals AS 
(SELECT
province_name,
SUM(people_served) AS total_ppl_serv
FROM
combined_analysis_table
GROUP BY
province_name
)
SELECT
*
FROM
province_totals;
DROP TABLE IF EXISTS town_aggregated_water_access;
CREATE TEMPORARY TABLE town_aggregated_water_access
WITH town_totals AS (
SELECT province_name, town_name, SUM(people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name,town_name
)
SELECT
ct.province_name,
ct.town_name,
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table ct
JOIN 
town_totals tt ON ct.province_name = tt.province_name AND ct.town_name = tt.town_name
GROUP BY 
ct.province_name,
ct.town_name
ORDER BY
ct.town_name;

SELECT 
    *
FROM
    town_aggregated_water_access as agg
ORDER BY
    agg.province_name;

SELECT
    province_name,
    town_name,
    ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) *100,0) AS Pct_broken_taps
FROM
    town_aggregated_water_access;

CREATE TABLE Project_progress (
Project_id SERIAL PRIMARY KEY,
source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
Address VARCHAR(50),
Town VARCHAR(30),
Province VARCHAR(30),
Source_type VARCHAR(50),
Improvement VARCHAR(50),
Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
Date_of_completion DATE,
Comments TEXT
);

SELECT 
    location.address,
    location.town_name,
    location.province_name,
    water_source.source_id,
    water_source.type_of_water_source,
    well_pollution.results
FROM
    water_source
        LEFT JOIN
    well_pollution_copy AS well_pollution ON water_source.source_id = well_pollution.source_id
        INNER JOIN
    visits ON water_source.source_id = visits.source_id
        INNER JOIN
    location ON location.location_id = visits.location_id
WHERE
    visits.visit_count = 1
        AND (well_pollution.results != 'Clean'
        OR water_source.type_of_water_source IN ('river' , 'tap_in_home_broken')
        OR (water_source.type_of_water_source = 'shared_tap'
        AND visits.time_in_queue >= 30));
        
/* this query joins the location, visits, and well_pollution tables to the water_source table. Since well_pollution only has data for wells, we have
to join those records to the water_source table with a LEFT JOIN and we used visits to link the various id's together.*/

SELECT
    location.address,
    location.town_name,
    location.province_name,
    water_source.source_id,
    water_source.type_of_water_source,
    well_pollution.results,
    visits.time_in_queue,
CASE 
        WHEN water_source.type_of_water_source = 'River' THEN 'Drill well'
        WHEN well_pollution.results = 'Contaminated: Biological' THEN 'Install UV filter'
        WHEN well_pollution.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        WHEN water_source.type_of_water_source = 'shared_tap' AND visits.time_in_queue >= 30 THEN CONCAT('Install ', FLOOR(visits.time_in_queue / 30), ' taps nearby')
        ELSE NULL
    END AS Improvement
FROM
    water_source
LEFT JOIN
    well_pollution_copy as well_pollution
    ON water_source.source_id = well_pollution.source_id
INNER JOIN
    visits
    ON water_source.source_id = visits.source_id
INNER JOIN
    location
    ON location.location_id = visits.location_id
WHERE
    visits.visit_count = 1
    AND (
        (water_source.type_of_water_source = 'shared_tap' AND visits.time_in_queue >= 30)
        OR (water_source.type_of_water_source = 'well' AND well_pollution.results != 'Clean')
        OR water_source.type_of_water_source IN ('tap_in_home_broken', 'River')
    );
    
/* this query joins the location, visits, and well_pollution tables to the water_source table. Since well_pollution only has data for wells, we have
to join those records to the water_source table with a LEFT JOIN and we used visits to link the various id's together.*/

INSERT INTO Project_progress (address, town, province, source_id, source_type, Improvement)
SELECT
    location.address,
    location.town_name,
    location.province_name,
    water_source.source_id,
    water_source.type_of_water_source,
CASE 
        WHEN water_source.type_of_water_source = 'River' THEN 'Drill well'
        WHEN well_pollution.results = 'Contaminated: Biological' THEN 'Install UV filter'
        WHEN well_pollution.results = 'Contaminated: Chemical'THEN 'Install RO filter'
        WHEN water_source.type_of_water_source = 'shared_tap' AND visits.time_in_queue >= 30 THEN CONCAT('Install ', FLOOR(visits.time_in_queue / 30), ' taps nearby')
        WHEN water_source.type_of_water_source = 'tap_in_home_broken' THEN 'Diagnose local infrastructure'
        ELSE NULL
    END AS Improvement
FROM
    water_source
LEFT JOIN
    well_pollution_copy as well_pollution
    ON water_source.source_id = well_pollution.source_id
INNER JOIN
    visits
    ON water_source.source_id = visits.source_id
INNER JOIN
    location
    ON location.location_id = visits.location_id
WHERE
    visits.visit_count = 1
    AND (
        (water_source.type_of_water_source = 'shared_tap' AND visits.time_in_queue >= 30)
        OR (water_source.type_of_water_source = 'well' AND well_pollution.results != 'Clean')
        OR water_source.type_of_water_source IN ('tap_in_home_broken', 'River')
    );
SELECT * FROM project_progress;

WITH town_totals AS (
    SELECT province_name, town_name, SUM(people_served) AS total_ppl_serv
    FROM combined_analysis_table
    GROUP BY province_name, town_name
),
town_access AS (
    SELECT
        ct.province_name,
        ct.town_name,
        ROUND((SUM(CASE WHEN source_type = 'river'
            THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
        ROUND((SUM(CASE WHEN source_type = 'shared_tap'
            THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
        ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
            THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
        ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
            THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
        ROUND((SUM(CASE WHEN source_type = 'well'
            THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well,
        ROUND((SUM(CASE WHEN source_type IN ('tap_in_home', 'tap_in_home_broken')
            THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS total_home_tap
    FROM
        combined_analysis_table ct
    JOIN 
        town_totals tt ON ct.province_name = tt.province_name AND ct.town_name = tt.town_name
    GROUP BY 
        ct.province_name,
        ct.town_name
    ORDER BY
        ct.town_name
),
filtered_towns AS (
    SELECT province_name, town_name
    FROM town_access
    WHERE total_home_tap < 50
)
SELECT province_name
FROM filtered_towns
GROUP BY province_name
HAVING COUNT(town_name) = (
    SELECT COUNT(town_name)
    FROM town_access ta
    WHERE ta.province_name = filtered_towns.province_name
);

SELECT
project_progress.Project_id, 
project_progress.Town, 
project_progress.Province, 
project_progress.Source_type, 
project_progress.Improvement,
Water_source.number_of_people_served,
RANK() OVER(PARTITION BY Province ORDER BY number_of_people_served)
FROM  project_progress 
JOIN water_source 
ON water_source.source_id = project_progress.source_id
WHERE Improvement = "Drill Well"
ORDER BY Province DESC, number_of_people_served;
