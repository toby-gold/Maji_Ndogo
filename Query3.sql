DROP TABLE IF EXISTS `auditor_report`;

CREATE TABLE `auditor_report` (
`location_id` VARCHAR(32),
`type_of_water_source` VARCHAR(64),
`true_water_source_score` int DEFAULT NULL,
`statements` VARCHAR(255)
);
SELECT * FROM auditor_report;
SELECT 
    location_id, true_water_source_score
FROM
    auditor_report;
    
SELECT
	a.location_id AS Audit_location,
	a.true_water_source_score,
	v.record_id,
	v.location_id AS visit_location
FROM
	auditor_report a
 join
	visits v
on a.location_id = v.location_id;
  
SELECT
	a.location_id AS Audit_location,
	a.true_water_source_score,
	v.record_id,
	v.location_id AS visit_location,
    subjective_quality_score
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id; 
    
SELECT
	a.location_id AS Location_id,
	v.record_id,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id;
    
SELECT
	a.location_id AS Location_id,
	v.record_id,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id
WHERE
	 wq.subjective_quality_score = a.true_water_source_score;
     
SELECT
	a.location_id AS Location_id,
	v.record_id,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id
WHERE
	 wq.subjective_quality_score = a.true_water_source_score
and 
	v.visit_count=1;
    
    /* To retrieve the incorrect records by adding one character in the last query "!"*/
SELECT
	a.location_id AS Location_id,
	v.record_id,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id
WHERE
	 wq.subjective_quality_score != a.true_water_source_score
and 
	v.visit_count=1;
    
SELECT
	a.location_id AS Location_id,
	v.record_id,
    a.type_of_water_source as auditors_source,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score,
    ws.type_of_water_source as survey_source
    
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id
JOIN
	water_source ws
on 
	ws.source_id = v.source_id
WHERE
	 wq.subjective_quality_score != a.true_water_source_score
and 
	v.visit_count=1;
    
-- let's add the survey statement
SELECT
	a.location_id AS Location_id,
	v.record_id,
    a.type_of_water_source as auditors_source,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score,
    a.statements
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id

WHERE
	 wq.subjective_quality_score != a.true_water_source_score
and 
	v.visit_count=1;
     
SELECT
	a.location_id AS Location_id,
	v.record_id,
    e.employee_name,
    a.type_of_water_source as auditors_source,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score,
    a.statements,
    v.assigned_employee_id
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id
join
	employee e
on 
	e.assigned_employee_id = v.assigned_employee_id
WHERE
	 wq.subjective_quality_score != a.true_water_source_score
and 
	v.visit_count=1;
    
WITH Incorrect_records AS 
(SELECT
	a.location_id AS Location_id,
	v.record_id,
    e.employee_name,
    a.type_of_water_source as auditors_source,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score,
    a.statements,
    v.assigned_employee_id
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id
join
	employee e
on 
	e.assigned_employee_id = v.assigned_employee_id
WHERE
	 wq.subjective_quality_score != a.true_water_source_score
and 
	v.visit_count=1)
SELECT * FROM Incorrect_records;
    
   WITH Incorrect_records AS 
(SELECT
	a.location_id AS Location_id,
	v.record_id,
    e.employee_name,
    a.type_of_water_source as auditors_source,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score,
    a.statements,
    v.assigned_employee_id
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id
join
	employee e
on 
	e.assigned_employee_id = v.assigned_employee_id
WHERE
	 wq.subjective_quality_score != a.true_water_source_score
and 
	v.visit_count=1)
SELECT DISTINCT(employee_name) 
FROM Incorrect_records; 

WITH Incorrect_records as
( SELECT
	a.location_id AS Location_id,
	v.record_id,
    e.employee_name,
    a.type_of_water_source as auditors_source,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score,
    a.statements,
    v.assigned_employee_id
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id
join
	employee e
on 
	e.assigned_employee_id = v.assigned_employee_id
WHERE
	 wq.subjective_quality_score != a.true_water_source_score
and 
	v.visit_count=1)
select
    employee_name, 
	count(EMPLOYEE_NAME) as number_of_mistakes
from
	incorrect_records
    group by employee_name;
    
 WITH error_count as
( SELECT
	a.location_id AS Location_id,
	v.record_id,
    e.employee_name,
    a.type_of_water_source as auditors_source,
	a.true_water_source_score as audit_score,
    wq.subjective_quality_score as employee_score,
    a.statements,
    v.assigned_employee_id
FROM
	auditor_report a
join
	visits v
on a.location_id = v.location_id
join
	water_quality wq
on
	v.record_id = wq.record_id
join
	employee e
on 
	e.assigned_employee_id = v.assigned_employee_id
WHERE
	 wq.subjective_quality_score != a.true_water_source_score
and 
	v.visit_count=1)
SELECT
    AVG(mistake_count) AS Avg_number_of_pple_per_empl
FROM (
    SELECT
        employee_name,
        COUNT(employee_name) AS mistake_count
    FROM error_count
    GROUP BY employee_name
) as Subquery;

CREATE VIEW Incorrect_records AS (
SELECT
a.location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
a.statements AS statements
FROM
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality AS wq
ON v.record_id = wq.record_id
JOIN
employee e
ON e.assigned_employee_id = v.assigned_employee_id
WHERE
v.visit_count =1
AND a.true_water_source_score != wq.subjective_quality_score);
  SELECT * FROM Incorrect_records;  
    
CREATE VIEW error_count AS ( 
SELECT
employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM
Incorrect_records
GROUP BY
employee_name);
SELECT * FROM error_count;

WITH Incorrect_records AS (
SELECT
a.location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
a.statements AS statements
FROM
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality AS wq
ON v.record_id = wq.record_id
JOIN
employee e
ON e.assigned_employee_id = v.assigned_employee_id
WHERE
v.visit_count =1
AND a.true_water_source_score != wq.subjective_quality_score),

error_count
as (SELECT count(employee_name) as number_of_mistakes,
		employee_name
        from incorrect_records
        group by employee_name),
 
 Avg_error_count_per_employee as
 (
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count),
    
suspect_list 
as
    (select employee_name,
		number_of_mistakes
	from error_count
where
	number_of_mistakes >(
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count))
    
    select
		employee_name,
        location_id,
        statements
	from incorrect_records
    where
		employee_name in (SELECT employee_name FROM suspect_list) 
        and statements  like "%cash%";
        
WITH Incorrect_records AS (
SELECT
a.location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
a.statements AS statements
FROM
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality AS wq
ON v.record_id = wq.record_id
JOIN
employee e
ON e.assigned_employee_id = v.assigned_employee_id
WHERE
v.visit_count =1
AND a.true_water_source_score != wq.subjective_quality_score),

error_count
as (SELECT count(employee_name) as number_of_mistakes,
		employee_name
        from incorrect_records
        group by employee_name),
 
 Avg_error_count_per_employee as
 (
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count),
    
suspect_list 
as
    (select employee_name,
		number_of_mistakes
	from error_count
where
	number_of_mistakes >(
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count))
    
    select
		employee_name,
        location_id,
        statements
	from incorrect_records
    where
		employee_name not in (SELECT employee_name FROM suspect_list) 
        and statements  like '%cash%';

WITH Incorrect_records AS (
SELECT
a.location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
a.statements AS statements
FROM
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality AS wq
ON v.record_id = wq.record_id
JOIN
employee e
ON e.assigned_employee_id = v.assigned_employee_id
WHERE
v.visit_count =1
AND a.true_water_source_score != wq.subjective_quality_score),

error_count
as (SELECT count(employee_name) as number_of_mistakes,
		employee_name
        from incorrect_records
        group by employee_name),
 
 Avg_error_count_per_employee as
 (
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count),
    
suspect_list 
as
    (select employee_name,
		number_of_mistakes
	from error_count
where
	number_of_mistakes >(
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count))
    
    select
		employee_name,
        location_id,
        statements
	from incorrect_records
    where
		employee_name in (SELECT employee_name FROM suspect_list);

select * from well_pollution;
select * from auditor_report;
select * from visits;

WITH Incorrect_records AS (
SELECT
a.location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
a.statements AS statements
FROM
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality AS wq
ON v.record_id = wq.record_id
JOIN
employee e
ON e.assigned_employee_id = v.assigned_employee_id
WHERE
v.visit_count =1
AND a.true_water_source_score != wq.subjective_quality_score),

error_count
as (SELECT count(employee_name) as number_of_mistakes,
		employee_name
        from incorrect_records
        group by employee_name),
 
 Avg_error_count_per_employee as
 (
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count)
    select employee_name,
		number_of_mistakes
	from error_count
where
	number_of_mistakes <=(
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count);
    
WITH Incorrect_records AS (
SELECT
a.location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
a.statements AS statements
FROM
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality AS wq
ON v.record_id = wq.record_id
JOIN
employee e
ON e.assigned_employee_id = v.assigned_employee_id
WHERE
v.visit_count =1
AND a.true_water_source_score != wq.subjective_quality_score),

error_count
as (SELECT count(employee_name) as number_of_mistakes,
		employee_name
        from incorrect_records
        group by employee_name),
 
 Avg_error_count_per_employee as
 (
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count),
    
suspect_list 
as
    (select employee_name,
		number_of_mistakes
	from error_count
where
	number_of_mistakes >(
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count))
    
    select
		employee_name,
        location_id,
        statements
	from incorrect_records
    where
		employee_name in (SELECT employee_name FROM suspect_list) 
        and statements  like "%cash%";

/* Check if there are any employees in the Incorrect_records table with statements mentioning "cash" that are not in our suspect list. This should
be as simple as adding one word*/

WITH Incorrect_records AS (
SELECT
a.location_id,
v.record_id,
e.employee_name,
a.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
a.statements AS statements
FROM
auditor_report a
JOIN
visits v
ON a.location_id = v.location_id
JOIN
water_quality AS wq
ON v.record_id = wq.record_id
JOIN
employee e
ON e.assigned_employee_id = v.assigned_employee_id
WHERE
v.visit_count =1
AND a.true_water_source_score != wq.subjective_quality_score),

error_count
as (SELECT count(employee_name) as number_of_mistakes,
		employee_name
        from incorrect_records
        group by employee_name),
 
 Avg_error_count_per_employee as
 (
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count),
    
suspect_list 
as
    (select employee_name,
		number_of_mistakes
	from error_count
where
	number_of_mistakes >(
select
	avg(number_of_mistakes) as Avg_error_count_per_employee
FROM 
	error_count))
    
    select
		employee_name,
        location_id,
        statements
	from incorrect_records
    where
		employee_name in (SELECT employee_name FROM suspect_list)
        and statements  like '%cash%';
        
SELECT
auditorRep.location_id,
visitsTbl.record_id,
auditorRep.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
wq.subjective_quality_score - auditorRep.true_water_source_score  AS score_diff
FROM auditor_report AS auditorRep
JOIN visits AS visitsTbl
ON auditorRep.location_id = visitsTbl.location_id
JOIN water_quality AS wq
ON visitsTbl.record_id = wq.record_id
WHERE (wq.subjective_quality_score - auditorRep.true_water_source_score) > 9;
