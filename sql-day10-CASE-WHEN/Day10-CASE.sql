/*Day10-Solution
Create a service performance report showing service name, total patients admitted, and a performance category based on the following: 'Excellent' if avg satisfaction >= 85, 'Good' if >= 75, 
'Fair' if >= 65, otherwise 'Needs Improvement'. 
Order by average satisfaction descending.*/

SELECT service, SUM(patients_admitted) AS total_admitted_patients,
		CASE
			WHEN ROUND(AVG(patient_satisfaction)::NUMERIC)>=85 THEN 'Excellent'
			WHEN ROUND(AVG(patient_satisfaction)::NUMERIC)>=75 THEN 'Good'
			WHEN ROUND(AVG(patient_satisfaction)::NUMERIC)>=65 THEN 'Fair'
			ELSE 'Needs Improvement'
		END AS performance_category
FROM services_weekly
GROUP BY service
ORDER BY AVG(patient_satisfaction) DESC;

--Practice Questions:
--1. Categorise patients as 'High', 'Medium', or 'Low' satisfaction based on their scores.
SELECT patient_id, name,
		CASE 
			WHEN satisfaction < 70 THEN 'LOW'
			WHEN satisfaction >=70 AND satisfaction <= 85 THEN 'Medium'
			WHEN satisfaction >=86 AND satisfaction <= 100 THEN 'High'
		END AS category
FROM patients;

--2. Label staff roles as 'Medical' or 'Support' based on role type.
SELECT staff_id, staff_name,
	CASE 
		WHEN role IN ('nurse', 'nursing_assistance') THEN 'Support'
		WHEN role = 'doctor' THEN 'Medical'
	END AS role
FROM staff;
	 
--3. Create age groups for patients (0-18, 19-40, 41-65, 65+).
SELECT patient_id, name,
		CASE 
			WHEN age BETWEEN 0 AND 18 THEN 'Pediatric'
			WHEN age BETWEEN 19 AND 40 THEN 'Young'
			WHEN age BETWEEN 41 AND 65 THEN 'Adult'
			WHEN age>65 THEN 'Senior'
		END AS age_group
FROM patients;