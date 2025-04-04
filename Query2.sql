USE md_water_services;

SELECT 
    CONCAT(LOWER(REPLACE(employee_name, ' ', '.')),
            '@ndogowater.gov') AS new_email
FROM
    employee;
    
UPDATE employee 
SET email = CONCAT(LOWER(REPLACE(employee_name, ' ', '.')),
            '@ndogowater.gov');
            
SELECT 
    (TRIM(phone_number)) AS new_phone_number
FROM
    employee;
    
 UPDATE employee 
SET 
    phone_number = (TRIM(phone_number));

SELECT town_name, COUNT(*) AS num_employee
FROM employee
GROUP BY town_name;

SELECT * FROM visits;

SELECT 
    assigned_employee_id, SUM(visit_count) AS number_of_visits
FROM
    visits
GROUP BY assigned_employee_id
ORDER BY number_of_visits DESC
LIMIT 3;

SELECT 
    employee_name, email, phone_number
FROM
    employee
WHERE
    assigned_employee_id IN (1, 30, 34);
    
SELECT * FROM location;

SELECT town_name, COUNT(town_name) AS records_per_town
FROM location
GROUP BY town_name
ORDER BY records_per_town DESC;

SELECT province_name, COUNT(province_name) AS records_per_province
FROM location
GROUP BY province_name
ORDER BY records_per_province DESC;

SELECT province_name, town_name, COUNT(town_name) AS records_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name, records_per_town DESC;

SELECT COUNT(location_type), location_type
FROM location
GROUP BY location_type;
SELECT ROUND(23740 / (15910 + 23740) * 100);

SELECT * FROM water_source;

SELECT SUM(number_of_people_served) AS 	total_no_of_people_surveyed
FROM water_source;

SELECT type_of_water_source, COUNT(type_of_water_source) AS number_of_sources
FROM water_source
GROUP BY type_of_water_source;

SELECT type_of_water_source, ROUND(AVG(number_of_people_served)) AS avg_people_per_source
FROM water_source
GROUP BY type_of_water_source
ORDER BY avg_people_per_source DESC;

SELECT type_of_water_source, ROUND(SUM(number_of_people_served)) AS population_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY population_served DESC;

SELECT type_of_water_source, ROUND(SUM(number_of_people_served)*100/27628140) AS pct_people_per_source
FROM water_source
GROUP BY type_of_water_source
ORDER BY pct_people_per_source DESC;

SELECT 
    type_of_water_source, SUM(number_of_people_served),
RANK() OVER(ORDER BY  SUM(number_of_people_served)DESC) AS rank_by_population
FROM
    water_source
GROUP BY type_of_water_source;

SELECT 
    type_of_water_source, SUM(number_of_people_served),
RANK() OVER(ORDER BY  SUM(number_of_people_served)DESC) AS rank_by_population
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY type_of_water_source;

SELECT source_id,
    type_of_water_source, SUM(number_of_people_served),
RANK() OVER(ORDER BY SUM(number_of_people_served)DESC) AS rank_by_population
FROM water_source
WHERE type_of_water_source != "tap_in_home"
GROUP BY type_of_water_source, source_id;

SELECT* FROM visits;

SELECT DATEDIFF(MAX(time_of_record), MIN(time_of_record))
FROM visits;

SELECT AVG(NULLIF(time_in_queue,0))
FROM visits;

SELECT DAYNAME(time_of_record) AS day_of_the_week,
ROUND(AVG(NULLIF(time_in_queue,0))) AS average_time_in_queue
FROM visits
GROUP BY day_of_the_week;

SELECT 
   TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    ROUND(AVG(NULLIF(time_in_queue, 0))) AS average_time_in_queue
FROM
    visits
GROUP BY hour_of_day
ORDER BY hour_of_day, average_time_in_queue DESC;

SELECT
TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
ELSE NULL
END
),0) AS Sunday,
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
ELSE NULL
END
),0) AS Monday,
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
ELSE NULL
END
),0) AS Tuesday,
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
ELSE NULL
END
),0) AS Wednesday,
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
ELSE NULL
END
),0) AS Thursday,
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
ELSE NULL
END
),0) AS Friday,
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
ELSE NULL
END
),0) AS Saturday
FROM
visits
WHERE
time_in_queue != 0
GROUP BY
hour_of_day
ORDER BY
hour_of_day;



SELECT CONCAT(day(time_of_record), " ", monthname(time_of_record), " ", year(time_of_record)) FROM visits;

SELECT  * FROM global_water_access;

SELECT name,
wat_bas_r - LAG(wat_bas_r) OVER (PARTITION BY name ORDER BY year) AS arc
FROM 
global_water_access
ORDER BY
name;

SELECT 
    location_id,
    time_in_queue,
    AVG(time_in_queue) OVER (PARTITION BY location_id ORDER BY visit_count) AS total_avg_queue_time
FROM 
    visits
WHERE 
visit_count > 1 -- Only shared taps were visited > 1
ORDER BY 
    location_id, time_of_record;
    
SELECT address, TRIM(address) 
FROM employee
WHERE employee_name = 'Farai Nia';

SELECT * FROM employee; 

SELECT province_name, town_name, COUNT(town_name) AS no_of_employee
FROM employee
GROUP BY province_name, town_name;
