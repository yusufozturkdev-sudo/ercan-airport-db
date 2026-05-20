-- ============================================================
-- CMPE343 - Airport Management Information System
-- 15 Statistical / Management Queries
-- ============================================================

USE airport_mgmt;

-- -------------------------------------------------------
-- Q1: All airplanes with model info and current status
--     Technique: INNER JOIN
-- -------------------------------------------------------
SELECT
    a.plane_no,
    am.manufacturer,
    am.model_name,
    a.capacity,
    a.status,
    a.year_manufactured,
    (2026 - a.year_manufactured) AS age_years
FROM Airplane a
JOIN Airplane_Model am ON a.model_no = am.model_no
ORDER BY a.status, am.manufacturer;

-- -------------------------------------------------------
-- Q2: Test count and score statistics per airplane
--     Technique: LEFT JOIN, GROUP BY, aggregate functions
-- -------------------------------------------------------
SELECT
    a.plane_no,
    am.model_name,
    COUNT(te.event_id)       AS total_tests,
    ROUND(AVG(te.score), 2)  AS avg_score,
    MIN(te.score)            AS min_score,
    MAX(te.score)            AS max_score,
    ROUND(SUM(te.hours_spent), 1) AS total_hours_spent
FROM Airplane a
JOIN Airplane_Model am   ON a.model_no  = am.model_no
LEFT JOIN Testing_Event te ON a.plane_no = te.plane_no
GROUP BY a.plane_no, am.model_name
ORDER BY total_tests DESC;

-- -------------------------------------------------------
-- Q3: Technicians expert in 2 or more airplane models
--     Technique: GROUP BY, HAVING
-- -------------------------------------------------------
SELECT
    e.ssn,
    CONCAT(e.name, ' ', e.surname) AS technician_name,
    t.certification_level,
    COUNT(exp.model_no)             AS num_models_expert
FROM Technician t
JOIN Employee e             ON t.ssn      = e.ssn
JOIN Technician_Expertise exp ON t.ssn    = exp.tech_ssn
GROUP BY e.ssn, e.name, e.surname, t.certification_level
HAVING COUNT(exp.model_no) >= 2
ORDER BY num_models_expert DESC;

-- -------------------------------------------------------
-- Q4: Traffic controllers with overdue medical exam (> 1 year)
--     Technique: DATE_SUB, DATEDIFF, JOIN
-- -------------------------------------------------------
SELECT
    e.ssn,
    CONCAT(e.name, ' ', e.surname)         AS controller_name,
    tc.license_no,
    DATE_FORMAT(tc.last_medical_exam, '%d-%m-%Y') AS last_exam,
    DATEDIFF(CURDATE(), tc.last_medical_exam)     AS days_overdue
FROM Traffic_Controller tc
JOIN Employee e ON tc.ssn = e.ssn
WHERE tc.last_medical_exam < DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY days_overdue DESC;

-- -------------------------------------------------------
-- Q5: Current hangar occupancy with available slots
--     Technique: LEFT JOIN, IS NULL, GROUP BY
-- -------------------------------------------------------
SELECT
    h.hangar_no,
    h.location,
    h.max_capacity,
    COUNT(hs.plane_no)                       AS current_planes,
    (h.max_capacity - COUNT(hs.plane_no))    AS available_slots,
    ROUND(COUNT(hs.plane_no) / h.max_capacity * 100, 1) AS occupancy_pct
FROM Hangar h
LEFT JOIN Hangar_Stay hs
    ON h.hangar_no = hs.hangar_no AND hs.out_datetime IS NULL
GROUP BY h.hangar_no, h.location, h.max_capacity
ORDER BY occupancy_pct DESC;

-- -------------------------------------------------------
-- Q6: Pass/fail rate per test type
--     Technique: GROUP BY, CASE WHEN, aggregate
-- -------------------------------------------------------
SELECT
    tt.test_id,
    tt.test_name,
    tt.frequency,
    COUNT(te.event_id)                                     AS times_conducted,
    ROUND(AVG(te.score), 2)                                AS avg_score,
    ROUND(AVG(te.hours_spent), 2)                          AS avg_hours,
    SUM(CASE WHEN te.score >= 70 THEN 1 ELSE 0 END)        AS passed,
    SUM(CASE WHEN te.score <  70 THEN 1 ELSE 0 END)        AS failed
FROM Test_Type tt
LEFT JOIN Testing_Event te ON tt.test_id = te.test_id
GROUP BY tt.test_id, tt.test_name, tt.frequency
ORDER BY avg_score DESC;

-- -------------------------------------------------------
-- Q7: Top 5 most productive technicians by hours worked
--     Technique: GROUP BY, SUM, ORDER BY, LIMIT
-- -------------------------------------------------------
SELECT
    e.ssn,
    CONCAT(e.name, ' ', e.surname)   AS technician_name,
    t.certification_level,
    COUNT(te.event_id)               AS tests_performed,
    ROUND(SUM(te.hours_spent), 2)    AS total_hours,
    ROUND(AVG(te.score), 2)          AS avg_score_given
FROM Technician t
JOIN Employee e          ON t.ssn      = e.ssn
LEFT JOIN Testing_Event te ON t.ssn   = te.tech_ssn
GROUP BY e.ssn, e.name, e.surname, t.certification_level
ORDER BY total_hours DESC
LIMIT 5;

-- -------------------------------------------------------
-- Q8: Airplanes that have NEVER been tested
--     Technique: NOT IN subquery
-- -------------------------------------------------------
SELECT
    a.plane_no,
    am.model_name,
    am.manufacturer,
    a.status,
    a.year_manufactured
FROM Airplane a
JOIN Airplane_Model am ON a.model_no = am.model_no
WHERE a.plane_no NOT IN (
    SELECT DISTINCT plane_no FROM Testing_Event
)
ORDER BY a.plane_no;

-- -------------------------------------------------------
-- Q9: Monthly test activity summary
--     Technique: DATE_FORMAT, GROUP BY year-month
-- -------------------------------------------------------
SELECT
    DATE_FORMAT(te.test_date, '%Y-%m')   AS year_month,
    COUNT(te.event_id)                   AS tests_conducted,
    COUNT(DISTINCT te.plane_no)          AS distinct_planes,
    COUNT(DISTINCT te.tech_ssn)          AS distinct_technicians,
    ROUND(AVG(te.score), 2)              AS avg_score,
    ROUND(SUM(te.hours_spent), 1)        AS total_hours
FROM Testing_Event te
GROUP BY DATE_FORMAT(te.test_date, '%Y-%m')
ORDER BY year_month;

-- -------------------------------------------------------
-- Q10: Airplanes scoring below the overall average
--      Technique: Subquery in HAVING clause
-- -------------------------------------------------------
SELECT
    a.plane_no,
    am.model_name,
    ROUND(AVG(te.score), 2) AS plane_avg_score,
    COUNT(te.event_id)      AS test_count
FROM Airplane a
JOIN Airplane_Model am  ON a.model_no  = am.model_no
JOIN Testing_Event te   ON a.plane_no  = te.plane_no
GROUP BY a.plane_no, am.model_name
HAVING AVG(te.score) < (SELECT AVG(score) FROM Testing_Event)
ORDER BY plane_avg_score ASC;

-- -------------------------------------------------------
-- Q11: Full hangar stay history with duration in days
--      Technique: DATEDIFF, COALESCE, DATE_FORMAT, CASE
-- -------------------------------------------------------
SELECT
    hs.stay_id,
    hs.plane_no,
    am.model_name,
    h.hangar_no,
    h.location,
    DATE_FORMAT(hs.in_datetime,  '%d-%m-%Y %H:%i') AS checked_in,
    DATE_FORMAT(hs.out_datetime, '%d-%m-%Y %H:%i') AS checked_out,
    DATEDIFF(
        COALESCE(hs.out_datetime, NOW()),
        hs.in_datetime
    )                                               AS days_stayed,
    CASE WHEN hs.out_datetime IS NULL
         THEN 'Currently parked'
         ELSE 'Departed' END                        AS stay_status
FROM Hangar_Stay hs
JOIN Hangar h        ON hs.hangar_no = h.hangar_no
JOIN Airplane a      ON hs.plane_no  = a.plane_no
JOIN Airplane_Model am ON a.model_no = am.model_no
ORDER BY hs.plane_no, hs.in_datetime;

-- -------------------------------------------------------
-- Q12: Employee directory showing role type via subtype detection
--      Technique: CASE, multiple LEFT JOINs, COALESCE
-- -------------------------------------------------------
SELECT
    e.ssn,
    CONCAT(e.name, ' ', e.surname)  AS full_name,
    e.union_membership_no,
    DATE_FORMAT(e.hire_date, '%d-%m-%Y') AS hire_date,
    CASE
        WHEN t.ssn  IS NOT NULL THEN 'Technician'
        WHEN tc.ssn IS NOT NULL THEN 'Traffic Controller'
        WHEN s.ssn  IS NOT NULL THEN 'Airport Staff'
        ELSE 'Unclassified'
    END                             AS employee_type,
    COALESCE(
        t.certification_level,
        CONCAT('Exam: ', DATE_FORMAT(tc.last_medical_exam, '%d-%m-%Y')),
        s.department,
        '-'
    )                               AS extra_info
FROM Employee e
LEFT JOIN Technician         t  ON e.ssn = t.ssn
LEFT JOIN Traffic_Controller tc ON e.ssn = tc.ssn
LEFT JOIN Airport_Staff      s  ON e.ssn = s.ssn
ORDER BY employee_type, e.surname;

-- -------------------------------------------------------
-- Q13: Tests performed by technicians NOT expert
--      in that airplane's model (audit query)
--      Technique: NOT EXISTS correlated subquery
-- -------------------------------------------------------
SELECT
    te.event_id,
    te.plane_no,
    a.model_no,
    CONCAT(e.name, ' ', e.surname) AS technician,
    te.test_date,
    te.score,
    '⚠ Not certified for this model' AS warning
FROM Testing_Event te
JOIN Airplane a  ON te.plane_no  = a.plane_no
JOIN Employee e  ON te.tech_ssn  = e.ssn
WHERE NOT EXISTS (
    SELECT 1
    FROM Technician_Expertise exp
    WHERE exp.tech_ssn = te.tech_ssn
      AND exp.model_no = a.model_no
)
ORDER BY te.test_date;

-- -------------------------------------------------------
-- Q14: Top 3 hangars by total plane-days stored
--      Technique: SUM(DATEDIFF), COALESCE, GROUP BY, LIMIT
-- -------------------------------------------------------
SELECT
    h.hangar_no,
    h.location,
    COUNT(hs.stay_id)                           AS total_stays,
    SUM(DATEDIFF(
        COALESCE(hs.out_datetime, NOW()),
        hs.in_datetime
    ))                                           AS total_plane_days,
    ROUND(AVG(DATEDIFF(
        COALESCE(hs.out_datetime, NOW()),
        hs.in_datetime
    )), 1)                                       AS avg_days_per_stay
FROM Hangar h
JOIN Hangar_Stay hs ON h.hangar_no = hs.hangar_no
GROUP BY h.hangar_no, h.location
ORDER BY total_plane_days DESC
LIMIT 3;

-- -------------------------------------------------------
-- Q15: Comprehensive airplane health & fuel cost report
--      Technique: derived subquery (FROM subquery), COALESCE, CASE, JOIN
-- -------------------------------------------------------
SELECT
    a.plane_no,
    am.model_name,
    am.manufacturer,
    a.status,
    (2026 - a.year_manufactured)                      AS age_years,
    COALESCE(ts.total_tests, 0)                       AS total_tests,
    COALESCE(ts.avg_score,   0)                       AS avg_test_score,
    COALESCE(ts.last_test, 'Never tested')            AS last_test_date,
    COALESCE(fs.total_fuel_liters, 0)                 AS total_fuel_liters,
    COALESCE(fs.total_fuel_cost,   0)                 AS total_fuel_cost_usd,
    CASE
        WHEN ts.avg_score >= 90 THEN 'Excellent'
        WHEN ts.avg_score >= 75 THEN 'Good'
        WHEN ts.avg_score >= 60 THEN 'Fair'
        WHEN ts.avg_score IS NULL THEN 'No test data'
        ELSE 'Poor — needs attention'
    END AS health_status
FROM Airplane a
JOIN Airplane_Model am ON a.model_no = am.model_no
LEFT JOIN (
    SELECT
        plane_no,
        COUNT(*)                                AS total_tests,
        ROUND(AVG(score), 2)                    AS avg_score,
        DATE_FORMAT(MAX(test_date), '%d-%m-%Y') AS last_test
    FROM Testing_Event
    GROUP BY plane_no
) ts ON a.plane_no = ts.plane_no
LEFT JOIN (
    SELECT
        plane_no,
        ROUND(SUM(liters), 2)    AS total_fuel_liters,
        ROUND(SUM(cost_usd), 2)  AS total_fuel_cost
    FROM Fuel_Record
    GROUP BY plane_no
) fs ON a.plane_no = fs.plane_no
ORDER BY COALESCE(ts.avg_score, -1) DESC;

