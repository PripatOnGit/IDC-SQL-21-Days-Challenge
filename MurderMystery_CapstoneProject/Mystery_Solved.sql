-- DROP TABLES if exist
DROP TABLE IF EXISTS employees, keycard_logs, calls, alibis, evidence;

-- Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    role VARCHAR(50)
);

INSERT INTO employees VALUES
(1, 'Alice Johnson', 'Engineering', 'Software Engineer'),
(2, 'Bob Smith', 'HR', 'HR Manager'),
(3, 'Clara Lee', 'Finance', 'Accountant'),
(4, 'David Kumar', 'Engineering', 'DevOps Engineer'),
(5, 'Eva Brown', 'Marketing', 'Marketing Lead'),
(6, 'Frank Li', 'Engineering', 'QA Engineer'),
(7, 'Grace Tan', 'Finance', 'CFO'),
(8, 'Henry Wu', 'Engineering', 'CTO'),
(9, 'Isla Patel', 'Support', 'Customer Support'),
(10, 'Jack Chen', 'HR', 'Recruiter');

-- Keycard Logs Table
CREATE TABLE keycard_logs (
    log_id INT PRIMARY KEY,
    employee_id INT,
    room VARCHAR(50),
    entry_time TIMESTAMP,
    exit_time TIMESTAMP
);

INSERT INTO keycard_logs VALUES
(1, 1, 'Office', '2025-10-15 08:00', '2025-10-15 12:00'),
(2, 2, 'HR Office', '2025-10-15 08:30', '2025-10-15 17:00'),
(3, 3, 'Finance Office', '2025-10-15 08:45', '2025-10-15 12:30'),
(4, 4, 'Server Room', '2025-10-15 08:50', '2025-10-15 09:10'),
(5, 5, 'Marketing Office', '2025-10-15 09:00', '2025-10-15 17:30'),
(6, 6, 'Office', '2025-10-15 08:30', '2025-10-15 12:30'),
(7, 7, 'Finance Office', '2025-10-15 08:00', '2025-10-15 18:00'),
(8, 8, 'Server Room', '2025-10-15 08:40', '2025-10-15 09:05'),
(9, 9, 'Support Office', '2025-10-15 08:30', '2025-10-15 16:30'),
(10, 10, 'HR Office', '2025-10-15 09:00', '2025-10-15 17:00'),
(11, 4, 'CEO Office', '2025-10-15 20:50', '2025-10-15 21:00'); -- killer

-- Calls Table
CREATE TABLE calls (
    call_id INT PRIMARY KEY,
    caller_id INT,
    receiver_id INT,
    call_time TIMESTAMP,
    duration_sec INT
);

INSERT INTO calls VALUES
(1, 4, 1, '2025-10-15 20:55', 45),
(2, 5, 1, '2025-10-15 19:30', 120),
(3, 3, 7, '2025-10-15 14:00', 60),
(4, 2, 10, '2025-10-15 16:30', 30),
(5, 4, 7, '2025-10-15 20:40', 90);

-- Alibis Table
CREATE TABLE alibis (
    alibi_id INT PRIMARY KEY,
    employee_id INT,
    claimed_location VARCHAR(50),
    claim_time TIMESTAMP
);

INSERT INTO alibis VALUES
(1, 1, 'Office', '2025-10-15 20:50'),
(2, 4, 'Server Room', '2025-10-15 20:50'), -- false alibi
(3, 5, 'Marketing Office', '2025-10-15 20:50'),
(4, 6, 'Office', '2025-10-15 20:50');

-- Evidence Table
CREATE TABLE evidence (
    evidence_id INT PRIMARY KEY,
    room VARCHAR(50),
    description VARCHAR(255),
    found_time TIMESTAMP
);

INSERT INTO evidence VALUES
(1, 'CEO Office', 'Fingerprint on desk', '2025-10-15 21:05'),
(2, 'CEO Office', 'Keycard swipe logs mismatch', '2025-10-15 21:10'),
(3, 'Server Room', 'Unusual access pattern', '2025-10-15 21:15');

---------------Murder Mystery Investigation----------

select * from employees;
select * from keycard_logs; 
select * from calls;
select * from alibis;
select * from evidence;

--1	Identify where and when the crime happened	WHERE, filtering
SELECT 
    room AS crime_scene,
    found_time AS time_discovered,
    description
FROM evidence
WHERE room = 'CEO Office'
ORDER BY found_time;

--2	Analyze who accessed critical areas at the time	JOIN, BETWEEN
SELECT e.employee_id, 
		e.name, 
        k.log_id,
        k.room,
        k.entry_time,
        k.exit_time
FROM employees e
JOIN keycard_logs k
ON e.employee_id = k.employee_id
WHERE room = 'CEO Office' AND entry_time BETWEEN '2025-10-15 20:30:00' AND '2025-10-15 21:10:00';

--3	Cross-check alibis with actual logs	JOIN, subqueries
SELECT a.*,
		k.log_id,
        k.room,
        k.entry_time,
        k.exit_time
FROM alibis a
LEFT JOIN keycard_logs k
ON a.employee_id = k.employee_id 
AND a.claim_time BETWEEN k.entry_time and k.exit_time
ORDER BY alibi_id;

--4	Investigate suspicious calls made around the time	JOIN, filtering
SELECT 
		c.caller_id,
        e1.name AS caller_name,
        c.receiver_id,
        e2.name AS receiver_name,
        c.call_time,
        c.duration_sec        
FROM employees e1
LEFT JOIN calls c
ON e1.employee_id = c.caller_id
LEFT JOIN employees e2
on e2.employee_id = c.receiver_id
WHERE c.call_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:00:00';

--5	Match evidence with movements and claims	JOIN, WHERE
SELECT e.*,
		k.employee_id,
        es.name,
        k.log_id,
        k.entry_time,
        k.exit_time,
        a.claim_time,
        a.claimed_location
FROM evidence e
LEFT JOIN keycard_logs k
ON e.room = k.room
LEFT JOIN employees es
ON k.employee_id = es.employee_id
LEFT JOIN alibis a
ON k.employee_id = a.employee_id
WHERE e.found_time BETWEEN k.entry_time and date_add(k.exit_time, interval '15 minute');

--6	Combine all findings to identify the killer	INTERSECT, multiple JOINs
-- Combine all findings to identify the killer
-- CASE SOLVED
-- Findings from keylogs
WITH cte_key AS (
SELECT  
	e.employee_id,
    e.name,
    log_id AS Match_Found_in
FROM employees e
LEFT JOIN keycard_logs k
ON e.employee_id = k.employee_id
WHERE k.room = 'CEO Office'
),
-- Findings from calls
cte_calls AS (
SELECT 
	e.employee_id,
    e.name,
    call_time AS Match_Found_in
FROM employees e 
LEFT JOIN calls c
ON e.employee_id = c.caller_id
WHERE c.call_time BETWEEN '2025-10-15 20:30:00' AND '2025-10-15 21:10:00'
),

-- Findings from alibis
cte_alibis AS (
SELECT 
	e.employee_id,
    e.name,
    alibi_id AS Match_Found_in
FROM employees e	
LEFT JOIN alibis a
ON e.employee_id = a.employee_id
LEFT JOIN keycard_logs k
ON a.employee_id = k.employee_id
WHERE a.claim_time BETWEEN '2025-10-15 20:30:00' AND '2025-10-15 21:10:00'
AND k.room <> a.claimed_location
),

-- Findings from evidence
cte_evidence AS (
SELECT  
	e.employee_id,
    e.name,
     log_id AS Match_Found_in
FROM employees e
LEFT JOIN keycard_logs k
ON e.employee_id = k.employee_id
LEFT JOIN evidence ec
ON k.room = ec.room
WHERE ec.found_time BETWEEN k.entry_time and date_add(k.exit_time, interval '15 minute')
)
SELECT name AS killer FROM cte_key
UNION
SELECT name AS killer FROM cte_calls
UNION
SELECT name AS killer FROM  cte_alibis
UNION
SELECT name AS killer FROM cte_evidence;   
