--Day9-Solution--
--Calculate the average length of stay (in days) for each service, showing only services where the average stay is more than 7 days. Also show the count of patients and order by average stay descending.
SELECT service, ROUND(AVG(departure_date - arrival_date), 2) AS stay,
		COUNT(*) AS total_patients
FROM patients
GROUP BY service
HAVING AVG(departure_date - arrival_date) > 7
ORDER BY stay DESC;

--Practice Questions:
--1. Extract the year from all patient arrival dates.
SELECT EXTRACT(YEAR FROM arrival_date) AS year_of_patients_arrival
FROM patients;

--2. Calculate the length of stay for each patient (departure_date - arrival_date).
SELECT patient_id, (departure_date - arrival_date) AS stay
FROM patients;

--3. Find all patients who arrived in a specific month.
SELECT patient_id, EXTRACT(MONTH FROM arrival_date) AS month_of_arrival
FROM patients;