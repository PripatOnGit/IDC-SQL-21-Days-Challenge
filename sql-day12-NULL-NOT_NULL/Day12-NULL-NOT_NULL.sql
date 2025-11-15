/*Day12-Solution
Analyze the event impact by comparing weeks with events vs weeks without events. Show: event status ('With Event' or 'No Event'), count of weeks, 
average patient satisfaction, and average staff morale. Order by average patient satisfaction descending.*/

SELECT
	CASE 
		WHEN event IS NOT NULL AND event<>'none' THEN 'With Event'
		ELSE 'No Event'
	END AS event_status,
	COUNT(*),	
	ROUND(AVG(patient_satisfaction),2) AS avg_satisfaction_rate,
	ROUND(AVG(staff_morale),2) AS avg_morale
FROM services_weekly
GROUP BY event_status
ORDER BY avg_satisfaction_rate DESC;



--Practice Questions:
--1. Find all weeks in services_weekly where no special event occurred.
SELECT week
FROM services_weekly
WHERE event IS NULL OR event='none'
GROUP BY week
ORDER BY week;

--2. Count how many records have null or empty event values.
SELECT COUNT(*)
FROM services_weekly
WHERE event IS NULL OR event='none';

--3. List all services that had at least one week with a special event.
SELECT DISTINCT service
FROM services_weekly
WHERE event IS NOT NULL 
  AND event <> 'none';