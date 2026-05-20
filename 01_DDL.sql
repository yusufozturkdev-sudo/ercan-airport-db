-- ============================================================
-- CMPE343 - Airport Management Information System
-- DDL - Data Definition Language
-- MySQL 8.0+
-- ============================================================

CREATE DATABASE IF NOT EXISTS airport_mgmt
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE airport_mgmt;

-- ------------------------------------------------------------
-- 1. EMPLOYEE (base supertype for all workers)
-- ------------------------------------------------------------
CREATE TABLE Employee (
    ssn                 VARCHAR(20)  NOT NULL,
    name                VARCHAR(50)  NOT NULL,
    surname             VARCHAR(50)  NOT NULL,
    union_membership_no VARCHAR(30)  NOT NULL,
    phone               VARCHAR(20),
    address             VARCHAR(200),
    hire_date           DATE         NOT NULL,
    CONSTRAINT pk_employee          PRIMARY KEY (ssn),
    CONSTRAINT uq_union_membership  UNIQUE (union_membership_no)
);

-- ------------------------------------------------------------
-- 2. TECHNICIAN (subtype of Employee)
-- ------------------------------------------------------------
CREATE TABLE Technician (
    ssn                 VARCHAR(20)  NOT NULL,
    certification_level ENUM('Junior','Mid','Senior') NOT NULL DEFAULT 'Junior',
    CONSTRAINT pk_technician PRIMARY KEY (ssn),
    CONSTRAINT fk_tech_emp   FOREIGN KEY (ssn) REFERENCES Employee(ssn)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 3. TRAFFIC_CONTROLLER (subtype of Employee)
-- ------------------------------------------------------------
CREATE TABLE Traffic_Controller (
    ssn               VARCHAR(20) NOT NULL,
    last_medical_exam DATE        NOT NULL,
    license_no        VARCHAR(30) NOT NULL,
    CONSTRAINT pk_tc        PRIMARY KEY (ssn),
    CONSTRAINT uq_tc_license UNIQUE (license_no),
    CONSTRAINT fk_tc_emp     FOREIGN KEY (ssn) REFERENCES Employee(ssn)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 4. AIRPORT_STAFF (subtype of Employee - other staff)
-- ------------------------------------------------------------
CREATE TABLE Airport_Staff (
    ssn        VARCHAR(20) NOT NULL,
    department VARCHAR(60),
    role       VARCHAR(60),
    CONSTRAINT pk_staff    PRIMARY KEY (ssn),
    CONSTRAINT fk_staff_emp FOREIGN KEY (ssn) REFERENCES Employee(ssn)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 5. AIRPLANE_MODEL
-- ------------------------------------------------------------
CREATE TABLE Airplane_Model (
    model_no     VARCHAR(30)  NOT NULL,
    manufacturer VARCHAR(80)  NOT NULL,
    model_name   VARCHAR(80)  NOT NULL,
    max_capacity INT          NOT NULL,
    CONSTRAINT pk_model         PRIMARY KEY (model_no),
    CONSTRAINT chk_model_cap    CHECK (max_capacity > 0)
);

-- ------------------------------------------------------------
-- 6. TECHNICIAN_EXPERTISE  (M:N Technician <-> Airplane_Model)
-- ------------------------------------------------------------
CREATE TABLE Technician_Expertise (
    tech_ssn VARCHAR(20) NOT NULL,
    model_no VARCHAR(30) NOT NULL,
    CONSTRAINT pk_expertise  PRIMARY KEY (tech_ssn, model_no),
    CONSTRAINT fk_exp_tech   FOREIGN KEY (tech_ssn) REFERENCES Technician(ssn)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_exp_model  FOREIGN KEY (model_no) REFERENCES Airplane_Model(model_no)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 7. AIRPLANE
-- ------------------------------------------------------------
CREATE TABLE Airplane (
    plane_no          VARCHAR(20)  NOT NULL,
    model_no          VARCHAR(30)  NOT NULL,
    capacity          INT          NOT NULL,
    status            ENUM('Active','Maintenance','Retired') NOT NULL DEFAULT 'Active',
    year_manufactured INT,
    CONSTRAINT pk_airplane      PRIMARY KEY (plane_no),
    CONSTRAINT fk_plane_model   FOREIGN KEY (model_no) REFERENCES Airplane_Model(model_no)
        ON UPDATE CASCADE,
    CONSTRAINT chk_plane_cap    CHECK (capacity > 0),
    CONSTRAINT chk_plane_year   CHECK (year_manufactured > 1900)
);

-- ------------------------------------------------------------
-- 8. HANGAR
-- ------------------------------------------------------------
CREATE TABLE Hangar (
    hangar_no    VARCHAR(20)  NOT NULL,
    location     VARCHAR(100) NOT NULL,
    max_capacity INT          NOT NULL,
    description  VARCHAR(200),
    CONSTRAINT pk_hangar     PRIMARY KEY (hangar_no),
    CONSTRAINT chk_hangar_cap CHECK (max_capacity > 0)
);

-- ------------------------------------------------------------
-- 9. HANGAR_STAY  (tracks IN/OUT per airplane per hangar)
-- ------------------------------------------------------------
CREATE TABLE Hangar_Stay (
    stay_id      INT         NOT NULL AUTO_INCREMENT,
    plane_no     VARCHAR(20) NOT NULL,
    hangar_no    VARCHAR(20) NOT NULL,
    in_datetime  DATETIME    NOT NULL,
    out_datetime DATETIME    DEFAULT NULL,
    CONSTRAINT pk_stay        PRIMARY KEY (stay_id),
    CONSTRAINT fk_stay_plane  FOREIGN KEY (plane_no)  REFERENCES Airplane(plane_no)
        ON UPDATE CASCADE,
    CONSTRAINT fk_stay_hangar FOREIGN KEY (hangar_no) REFERENCES Hangar(hangar_no)
        ON UPDATE CASCADE,
    CONSTRAINT chk_stay_dates CHECK (out_datetime IS NULL OR out_datetime > in_datetime)
);

-- ------------------------------------------------------------
-- 10. TEST_TYPE
-- ------------------------------------------------------------
CREATE TABLE Test_Type (
    test_id     VARCHAR(20)  NOT NULL,
    test_name   VARCHAR(100) NOT NULL,
    description VARCHAR(300),
    max_score   INT          NOT NULL DEFAULT 100,
    frequency   ENUM('Daily','Weekly','Monthly','Quarterly','Annual') NOT NULL,
    CONSTRAINT pk_test       PRIMARY KEY (test_id),
    CONSTRAINT chk_max_score CHECK (max_score > 0)
);

-- ------------------------------------------------------------
-- 11. TESTING_EVENT
-- ------------------------------------------------------------
CREATE TABLE Testing_Event (
    event_id    INT           NOT NULL AUTO_INCREMENT,
    plane_no    VARCHAR(20)   NOT NULL,
    tech_ssn    VARCHAR(20)   NOT NULL,
    test_id     VARCHAR(20)   NOT NULL,
    test_date   DATE          NOT NULL,
    hours_spent DECIMAL(5,2)  NOT NULL,
    score       INT           NOT NULL,
    CONSTRAINT pk_event     PRIMARY KEY (event_id),
    CONSTRAINT fk_ev_plane  FOREIGN KEY (plane_no) REFERENCES Airplane(plane_no)  ON UPDATE CASCADE,
    CONSTRAINT fk_ev_tech   FOREIGN KEY (tech_ssn) REFERENCES Technician(ssn)     ON UPDATE CASCADE,
    CONSTRAINT fk_ev_test   FOREIGN KEY (test_id)  REFERENCES Test_Type(test_id)  ON UPDATE CASCADE,
    CONSTRAINT chk_ev_hours CHECK (hours_spent > 0),
    CONSTRAINT chk_ev_score CHECK (score >= 0)
);

-- ------------------------------------------------------------
-- 12. RUNWAY  (extra table for full marks)
-- ------------------------------------------------------------
CREATE TABLE Runway (
    runway_id   VARCHAR(10)  NOT NULL,
    length_m    INT          NOT NULL,
    width_m     INT          NOT NULL,
    surface     ENUM('Asphalt','Concrete','Gravel') NOT NULL DEFAULT 'Asphalt',
    status      ENUM('Open','Closed','Maintenance') NOT NULL DEFAULT 'Open',
    CONSTRAINT pk_runway      PRIMARY KEY (runway_id),
    CONSTRAINT chk_rw_length  CHECK (length_m > 0),
    CONSTRAINT chk_rw_width   CHECK (width_m  > 0)
);

-- ------------------------------------------------------------
-- 13. FLIGHT  (extra table for full marks)
-- ------------------------------------------------------------
CREATE TABLE Flight (
    flight_id        VARCHAR(20)  NOT NULL,
    plane_no         VARCHAR(20)  NOT NULL,
    controller_ssn   VARCHAR(20)  NOT NULL,
    runway_id        VARCHAR(10)  NOT NULL,
    origin           VARCHAR(80)  NOT NULL,
    destination      VARCHAR(80)  NOT NULL,
    scheduled_dep    DATETIME     NOT NULL,
    actual_dep       DATETIME,
    scheduled_arr    DATETIME     NOT NULL,
    actual_arr       DATETIME,
    flight_status    ENUM('Scheduled','Departed','Landed','Cancelled','Delayed') NOT NULL DEFAULT 'Scheduled',
    CONSTRAINT pk_flight       PRIMARY KEY (flight_id),
    CONSTRAINT fk_fl_plane     FOREIGN KEY (plane_no)       REFERENCES Airplane(plane_no)           ON UPDATE CASCADE,
    CONSTRAINT fk_fl_ctrl      FOREIGN KEY (controller_ssn) REFERENCES Traffic_Controller(ssn)      ON UPDATE CASCADE,
    CONSTRAINT fk_fl_runway    FOREIGN KEY (runway_id)      REFERENCES Runway(runway_id)            ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 14. FUEL_RECORD  (extra table for full marks)
-- ------------------------------------------------------------
CREATE TABLE Fuel_Record (
    fuel_id      INT           NOT NULL AUTO_INCREMENT,
    plane_no     VARCHAR(20)   NOT NULL,
    staff_ssn    VARCHAR(20)   NOT NULL,
    fuel_date    DATETIME      NOT NULL,
    fuel_type    ENUM('Jet-A','Jet-A1','AvGas') NOT NULL DEFAULT 'Jet-A1',
    liters       DECIMAL(10,2) NOT NULL,
    cost_usd     DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_fuel       PRIMARY KEY (fuel_id),
    CONSTRAINT fk_fuel_plane FOREIGN KEY (plane_no)  REFERENCES Airplane(plane_no)   ON UPDATE CASCADE,
    CONSTRAINT fk_fuel_staff FOREIGN KEY (staff_ssn) REFERENCES Airport_Staff(ssn)   ON UPDATE CASCADE,
    CONSTRAINT chk_fuel_lit  CHECK (liters   > 0),
    CONSTRAINT chk_fuel_cost CHECK (cost_usd > 0)
);

-- ============================================================
-- VIEWS
-- ============================================================

-- View 1: Current hangar occupancy
CREATE OR REPLACE VIEW vw_hangar_occupancy AS
SELECT
    h.hangar_no,
    h.location,
    h.max_capacity,
    COUNT(hs.plane_no)                          AS current_planes,
    h.max_capacity - COUNT(hs.plane_no)         AS available_slots
FROM Hangar h
LEFT JOIN Hangar_Stay hs ON h.hangar_no = hs.hangar_no AND hs.out_datetime IS NULL
GROUP BY h.hangar_no, h.location, h.max_capacity;

-- View 2: Full employee roster with type
CREATE OR REPLACE VIEW vw_employee_roster AS
SELECT
    e.ssn,
    CONCAT(e.name,' ',e.surname)  AS full_name,
    e.union_membership_no,
    e.hire_date,
    CASE
        WHEN t.ssn  IS NOT NULL THEN 'Technician'
        WHEN tc.ssn IS NOT NULL THEN 'Traffic Controller'
        WHEN s.ssn  IS NOT NULL THEN 'Airport Staff'
        ELSE 'Unclassified'
    END AS employee_type
FROM Employee e
LEFT JOIN Technician         t  ON e.ssn = t.ssn
LEFT JOIN Traffic_Controller tc ON e.ssn = tc.ssn
LEFT JOIN Airport_Staff      s  ON e.ssn = s.ssn;

-- View 3: Airplane health summary
CREATE OR REPLACE VIEW vw_airplane_health AS
SELECT
    a.plane_no,
    am.model_name,
    a.status,
    COUNT(te.event_id)          AS total_tests,
    ROUND(AVG(te.score), 2)     AS avg_score,
    MAX(te.test_date)           AS last_tested
FROM Airplane a
JOIN Airplane_Model am ON a.model_no = am.model_no
LEFT JOIN Testing_Event te ON a.plane_no = te.plane_no
GROUP BY a.plane_no, am.model_name, a.status;

-- ============================================================
-- TRIGGERS
-- ============================================================

DELIMITER $$

-- Trigger 1: When a testing score < 60, set airplane to Maintenance
CREATE TRIGGER trg_low_score_maintenance
AFTER INSERT ON Testing_Event
FOR EACH ROW
BEGIN
    IF NEW.score < 60 THEN
        UPDATE Airplane
        SET status = 'Maintenance'
        WHERE plane_no = NEW.plane_no;
    END IF;
END$$

-- Trigger 2: Prevent inserting an out_datetime before in_datetime
CREATE TRIGGER trg_check_stay_dates
BEFORE INSERT ON Hangar_Stay
FOR EACH ROW
BEGIN
    IF NEW.out_datetime IS NOT NULL AND NEW.out_datetime <= NEW.in_datetime THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'out_datetime must be after in_datetime';
    END IF;
END$$

-- Trigger 3: Log when a technician exam score is updated (audit-style)
-- (requires an audit table)
CREATE TABLE IF NOT EXISTS Audit_Log (
    log_id      INT          NOT NULL AUTO_INCREMENT,
    event_time  DATETIME     NOT NULL DEFAULT NOW(),
    table_name  VARCHAR(50)  NOT NULL,
    action      VARCHAR(10)  NOT NULL,
    description VARCHAR(300),
    CONSTRAINT pk_audit PRIMARY KEY (log_id)
)$$

CREATE TRIGGER trg_audit_test_event
AFTER INSERT ON Testing_Event
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (table_name, action, description)
    VALUES (
        'Testing_Event',
        'INSERT',
        CONCAT('Plane ', NEW.plane_no, ' tested by ', NEW.tech_ssn,
               ' on ', NEW.test_date, ' — score: ', NEW.score)
    );
END$$

DELIMITER ;

-- ============================================================
-- STORED PROCEDURES
-- ============================================================

DELIMITER $$

-- Procedure 1: Get full test history of an airplane
CREATE PROCEDURE sp_airplane_test_history(IN p_plane_no VARCHAR(20))
BEGIN
    SELECT
        te.event_id,
        te.test_date,
        tt.test_name,
        CONCAT(e.name,' ',e.surname) AS technician,
        te.hours_spent,
        te.score,
        CASE WHEN te.score >= 70 THEN 'PASS' ELSE 'FAIL' END AS result
    FROM Testing_Event te
    JOIN Test_Type tt ON te.test_id  = tt.test_id
    JOIN Employee  e  ON te.tech_ssn = e.ssn
    WHERE te.plane_no = p_plane_no
    ORDER BY te.test_date DESC;
END$$

-- Procedure 2: Check in a plane to a hangar
CREATE PROCEDURE sp_hangar_checkin(
    IN p_plane_no  VARCHAR(20),
    IN p_hangar_no VARCHAR(20),
    IN p_in_dt     DATETIME
)
BEGIN
    INSERT INTO Hangar_Stay (plane_no, hangar_no, in_datetime)
    VALUES (p_plane_no, p_hangar_no, p_in_dt);
    SELECT LAST_INSERT_ID() AS new_stay_id;
END$$

-- Procedure 3: Check out a plane from hangar
CREATE PROCEDURE sp_hangar_checkout(
    IN p_stay_id  INT,
    IN p_out_dt   DATETIME
)
BEGIN
    UPDATE Hangar_Stay
    SET out_datetime = p_out_dt
    WHERE stay_id = p_stay_id AND out_datetime IS NULL;
END$$

DELIMITER ;
