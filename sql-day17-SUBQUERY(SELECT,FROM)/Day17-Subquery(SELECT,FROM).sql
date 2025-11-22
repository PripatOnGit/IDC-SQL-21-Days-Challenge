/* Day17-Solution
Create a report showing each service with: service name, total patients admitted, the difference between their total admissions 
and the average admissions across all services, and a rank indicator ('Above Average', 'Average', 'Below Average'). 
Order by total patients admitted descending.*/

SELECT s.service, s.total_admitted,
		CASE
		WHEN s.total_admitted > overall.avg_admitted THEN 'Above Average'
     	WHEN s.total_admitted =  overall.avg_admitted THEN 'Average'
     	ELSE 'Below Average'
     	END AS rank_indicator
FROM 
	(SELECT service, SUM(patients_admitted) AS total_admitted
     FROM services_weekly
     GROUP BY service) AS s
CROSS JOIN 
	(SELECT ROUND(AVG(patients_admitted)) AS avg_admitted
	 FROM services_weekly) AS overall
ORDER BY s.total_admitted DESC;


--Practice Questions:
-- 1. Show each patient with their service's average satisfaction as an additional column.
SELECT p.patient_id, p.service, p.satisfaction,
   		(SELECT ROUND(AVG(p2.satisfaction),2)
		FROM patients p2
		WHERE p2.service = p.service) AS avg_satisfaction
FROM patients p;

-- 2. Create a derived table of service statistics and query from it.
SELECT                                                              
    p.service,
    p.total_patients,
    p.avg_satisfaction
FROM(
      SELECT service,
             COUNT(patient_id) AS total_patients,
             ROUND(AVG(satisfaction),2) AS avg_satisfaction
       FROM patients
       GROUP BY service
	) AS p;   

-- 3. Display staff with their service's total patient count as a calculated field.
SELECT s.staff_id, s.staff_name, s.service,
		(SELECT COUNT(patient_id)
      	 FROM patients p
      	 WHERE p.service = s.service
       	)AS total_patients_service
FROM staff s;