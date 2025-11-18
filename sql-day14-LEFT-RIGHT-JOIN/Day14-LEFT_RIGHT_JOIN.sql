/*Day14-Solution
--Create a staff utilisation report showing all staff members (staff_id, staff_name, role, service) and the count of weeks they were present (from staff_schedule). 
Include staff members even if they have no schedule records. Order by weeks present descending.*/

SELECT s.staff_id, s.staff_name, s.role, s.service, 
SUM(coalesce(ss.present,0)) AS weeks_present FROM staff s 
LEFT JOIN staff_schedule ss 
USING (staff_id, staff_name, role, service) 
GROUP BY s.staff_id, s.staff_name, s.role, s.service
ORDER BY weeks_present DESC ;


--Practice Questions:
--1. Show all staff members and their schedule information (including those with no schedule entries).
SELECT st.staff_id, st.staff_name, st.role, st.service,sc.week, sc.present
FROM staff st
LEFT JOIN staff_schedule sc
ON st.staff_id = sc.staff_id;

--2. List all services from services_weekly and their corresponding staff (show services even if no staff assigned).
SELECT DISTINCT s.service, st.staff_id, st.staff_name,  st.role
FROM services_weekly s
LEFT JOIN staff st
ON s.service = st.service;

--3. Display all patients and their service's weekly statistics (if available).
SELECT p.patient_id, p.name, p.service, s.week, p.satisfaction
FROM patients p
left join services_weekly s
on p.service = s.service;