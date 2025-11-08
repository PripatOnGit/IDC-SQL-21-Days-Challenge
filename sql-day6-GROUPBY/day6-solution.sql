--Practice Questions:
/*Day6-Solution
For each hospital service, calculate the total number of patients admitted, total patients refused, and the admission rate (percentage of requests that were admitted). 
Order by admission rate descending.
*/
SELECT service, SUM(patients_admitted) AS total_patients_admitted,
		SUM(patients_refused) AS total_patients_refused,
		ROUND((CAST(SUM(patients_admitted) AS FLOAT) / SUM(patients_request) * 100)::NUMERIC, 2) AS admission_rate
FROM services_weekly
GROUP BY service
ORDER BY admission_rate DESC;

--1. Count the number of patients by each service.
SELECT service, COUNT(*) AS total_patients
FROM patients
GROUP BY service;

--2. Calculate the average age of patients grouped by service.
SELECT service, ROUND(AVG(age),2) AS avg_age
FROM patients
GROUP BY service;

--3. Find the total number of staff members per role.
SELECT role, COUNT(*) AS total_staff
FROM staff
GROUP BY role;