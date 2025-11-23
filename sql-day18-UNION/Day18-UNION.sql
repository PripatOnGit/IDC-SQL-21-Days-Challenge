/*Day18-Solution
Create a comprehensive personnel and patient list showing: 
identifier (patient_id or staff_id), full name, type ('Patient' or 'Staff'), 
and associated service. Include only those in 'surgery' or 'emergency' services.
Order by type, then service, then name.*/

SELECT ID, fullname, type, service
FROM(
	SELECT patient_id AS ID, name AS fullname,
	'Patient' AS type, service
FROM patients
WHERE service IN ('surgery','emergency')
UNION 
SELECT staff_id AS id, staff_name AS fullname,
'staff' AS type, service
FROM staff
WHERE service IN ('surgery','emergency'))
ORDER BY 3,4,2
;


--Practice Questions:
--1. Combine patient names and staff names into a single list.
SELECT name AS pat_staff_names FROM patients
UNION ALL
SELECT staff_name AS pat_staff_names FROM staff
ORDER BY 1;

--2. Create a union of high satisfaction patients (>90) and low satisfaction patients (<50).
SELECT name AS patient_name,satisfaction
FROM patients WHERE satisfaction >90
UNION
SELECT name AS patient_name, satisfaction
FROM patients WHERE satisfaction < 50
ORDER BY satisfaction DESC;

--3. List all unique names from both patients and staff tables.
SELECT name AS pat_staff_names FROM patients
UNION
SELECT staff_name AS pat_staff_names FROM staff
ORDER BY 1;
