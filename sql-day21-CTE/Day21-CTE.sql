/*Day21-Solution
Create a comprehensive hospital performance dashboard using CTEs. 
Calculate: 1) Service-level metrics (total admissions, refusals, avg satisfaction), 
2) Staff metrics per service (total staff, avg weeks present), 
3) Patient demographics per service (avg age, count). 
Then combine all three CTEs to create a final report showing service name, all calculated metrics, and an overall performance score (weighted average of admission rate 
and satisfaction). Order by performance score descending.*/

WITH serv_metrics AS(
	SELECT service,sum(patients_admitted)total_patients_admitted,
		SUM(patients_refused)total_patients_refused,
		ROUND(AVG(patient_satisfaction),2) AS avg_patient_satisfaction,
		ROUND(100.0 * SUM(patients_admitted) /
          (SUM(patients_admitted + patients_refused)), 2) AS admission_rate
	FROM services_weekly
	GROUP BY service
	),
patient_data AS(
	SELECT service, COUNT(patient_id)total_patients,
	ROUND(AVG(age),2) AS avg_patient_age
	FROM patients
	GROUP BY service
	),
staff_data AS (
	SELECT service, COUNT(staff_id)total_staff,
	ROUND(AVG(CASE WHEN present=1 THEN week ELSE 0 END), 3) AS avg_staff_present
	FROM staff_schedule
	GROUP BY service
	)
SELECT sr.service, total_patients_admitted, total_patients_refused,
	avg_patient_satisfaction, total_patients, avg_patient_age,
	total_staff,avg_staff_present, admission_rate,
	ROUND(((0.7 * avg_patient_satisfaction) + (0.3*admission_rate)),2) AS performance_score		  
FROM serv_metrics sr, staff_data s, patient_data p
WHERE sr.service = s.service AND s.service=p.service
ORDER BY 10 DESC;


--### Practice Questions:
--1. Create a CTE to calculate service statistics, then query from it.
WITH ser_stat AS(
	SELECT service,SUM(patients_admitted) AS total_patients_admitted,
		SUM(patients_refused) AS total_patients_refused,
		ROUND(AVG(patient_satisfaction),2) AS avg_patient_satisfaction
	FROM services_weekly
	GROUP BY service
	)
SELECT service, total_patients_admitted, total_patients_refused, avg_patient_satisfaction
FROM ser_stat;

--2. Use multiple CTEs to break down a complex query into logical steps.
WITH avg_tot AS(
	SELECT ROUND(AVG(overall_total_patients_admitted)) AS overall_avg_patients_admitted
	FROM (
		SELECT 
		sum(patients_admitted) AS overall_total_patients_admitted
		FROM services_weekly
		GROUP BY service) AS tot
		)
SELECT service, total_patients_admitted, (total_patients_admitted - overall_avg_patients_admitted) AS Difference_in_admissions, overall_avg_patients_admitted,
	(CASE WHEN total_patients_admitted > overall_avg_patients_admitted THEN 'Above Average'
		WHEN total_patients_admitted = overall_avg_patients_admitted THEN 'Average'
		ELSE 'Below Average'
	END) AS rank_indicator
FROM(
	SELECT service, SUM(patients_admitted) AS total_patients_admitted, MAX(overall_avg_patients_admitted) AS overall_avg_patients_admitted
	FROM avg_tot, services_weekly
	GROUP BY 1
	) AS t
ORDER BY 2 DESC;


--3. Build a CTE for staff utilization and join it with patient data.
WITH patient_data AS(
	SELECT patient_id, name, service
	FROM patients
	),
staff_data AS(
SELECT staff_name, service
FROM staff
)
SELECT patient_id, name AS patient_name, staff_name AS staff_assigned, s.service
FROM patient_data p LEFT JOIN staff_data s ON p.service=s.service;
