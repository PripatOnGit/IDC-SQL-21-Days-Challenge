/**Day20- Solution
Create a trend analysis showing for each service and week: 
week number, patients_admitted, running total of patients admitted (cumulative),
3-week moving average of patient satisfaction (current week and 2 prior weeks), 
and the difference between current week admissions and the service average. 
Filter for weeks 10-20 only.
*/
SELECT service,week,patients_admitted,
SUM(patients_admitted) OVER(PARTITION BY service ORDER BY week)cumultive_patients_admitted,
 ROUND(AVG(patient_satisfaction) OVER (
        PARTITION BY service
        ORDER BY week
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3week,
		ROUND((patients_admitted - AVG(patients_admitted) OVER (PARTITION BY service)
		),2)diff_curr_admisn
		FROM services_weekly
		WHERE week BETWEEN 10 AND 20
		ORDER BY service,week;


--Practice Questions:
--1.Calculate running total of patients admitted by week for each service.
SELECT service,week,
SUM(patients_admitted) OVER(PARTITION BY service ORDER BY week)total_patients_admitted
FROM services_weekly;

--2.Find the moving average of patient satisfaction over 4-week periods.
SELECT week,
 ROUND(AVG(patient_satisfaction) OVER (
        PARTITION BY service
        ORDER BY week
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), 2) AS moving_avg_4week
FROM services_weekly
ORDER BY week;

--3. Show cumulative patient refusals by week across all services.
SELECT service,week,
SUM(patients_refused) OVER(PARTITION BY service ORDER BY week)total_patients_refused
FROM services_weekly
ORDER BY 3,2,1;




