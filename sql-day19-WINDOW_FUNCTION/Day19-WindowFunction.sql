/*Day19-Solution
For each service, rank the weeks by patient satisfaction score (highest first). 
Show service, week, patient_satisfaction, patients_admitted, and the rank. Include only the top 3 weeks per service.*/

SELECT * 
FROM ( SELECT 
 service, 
 week, 
 patient_satisfaction, 
 patients_admitted,
 RANK() OVER (PARTITION BY service ORDER BY patient_satisfaction DESC) AS sat_rank FROM services_weekly ) ranked 
WHERE sat_rank <= 3;