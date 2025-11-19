/*Day15-Create a comprehensive service analysis report for week 20 showing:
service name, total patients admitted that week, total patients refused, 
average patient satisfaction, count of staff assigned to service, 
and count of staff present that week. Order by patients admitted descending.*/

with p as(
select week,service,sum(patients_admitted)total_patients_admitted,
sum(patients_refused)total_patients_refused,
round(avg(patient_satisfaction),2)average_patient_satisfaction
from services_weekly   
where week=20
group by week,service
),
s as (
select week,service,count(staff_id)num_of_staff_assigned,
sum(present)staff_present_days
from  staff_schedule
where week=20
group by week,service
) 
select p.service,total_patients_admitted,
total_patients_refused,
average_patient_satisfaction,
num_of_staff_assigned,
staff_present_days
from p  left join  s on p.service=s.service and p.week=s.week
order by total_patients_admitted desc;


--### Practice Questions:

--1. Join patients, staff, and staff_schedule to show patient service and staff availability.
select *
from patients p left join staff s on p.service=s.service
left join staff_schedule sh on s.staff_id=sh.staff_id;

--2. Combine services_weekly with staff and staff_schedule for comprehensive service analysis.
select *
from staff s left join services_weekly sw on s.service=sw.service
left join staff_schedule sh on s.staff_id=sh.staff_id;
--3. Create a multi-table report showing patient admissions with staff information.
select *
from patients p left join staff s on p.service=s.service
left join services_weekly sw on s.service=sw.service;