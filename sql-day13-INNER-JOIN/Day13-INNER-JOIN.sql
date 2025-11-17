/*Day13-Solution
Create a comprehensive report showing patient_id, patient name, age, service, and the total number of staff members available in their service. 
Only include patients from services that have more than 5 staff members. Order by number of staff descending, then by patient name.
*/
SELECT
    p.patient_id,
    p.name AS patient_name,
    p.age,
    p.service,
    sc.staff_count
FROM patients p
INNER JOIN (
    SELECT 
        service,
        COUNT(DISTINCT staff_id) AS staff_count
    FROM staff
    GROUP BY service
    HAVING COUNT(DISTINCT staff_id) > 5
) sc
ON p.service = sc.service
ORDER BY
    sc.staff_count DESC,
    p.name ASC;

--Practice Questions:
--1. Join patients and staff based on their common service field (show patient and staff who work in same service).
SELECT p.patient_id, p.name, s.staff_id, s.staff_name, p.service
FROM patients p
INNER JOIN staff s
ON p.service = s.service;

--2. Join services_weekly with staff to show weekly service data with staff information.
SELECT sw.week, sw.service, st.staff_id, st.staff_name
FROM services_weekly sw
INNER JOIN staff st
ON sw.service = st.service;

--3. Create a report showing patient information along with staff assigned to their service.
SELECT p.*, st.staff_id, st.staff_name
FROM patients p
INNER JOIN staff st
ON p.service = st.service;

