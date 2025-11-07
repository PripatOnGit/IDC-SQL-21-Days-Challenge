--Day5-Solution
--Calculate the total number of patients admitted, total patients refused, and the average patient satisfaction across all services and weeks. 
--Round the average satisfaction to 2 decimal places
SELECT COUNT(patients_admitted) AS total_patients_admitted, 
	COUNT(patients_refused) AS total_patients_refused, 
	ROUND(AVG(patient_satisfaction),2) AS avg_patient_satisfaction
FROM services_weekly;


--Practice questions
--1. Count the total number of patients in the hospital.
SELECT COUNT(*)
FROM patients;

--2. Calculate the average satisfaction score of all patients.
SELECT ROUND(AVG(satisfaction),2)
FROM patients;

--3. Find the minimum and maximum age of patients.
SELECT MIN(age), MAX(age)
FROM patients;