-- ============================================================
-- CMPE343 - Airport Management Information System
-- DML - Data Manipulation Language (Sample Data)
-- ============================================================

USE airport_mgmt;

-- ------------------------------------------------------------
-- AIRPLANE_MODEL
-- ------------------------------------------------------------
INSERT INTO Airplane_Model (model_no, manufacturer, model_name, max_capacity) VALUES
('B737-800', 'Boeing',  'Boeing 737-800',          189),
('B777-300', 'Boeing',  'Boeing 777-300ER',         396),
('A320-NEO', 'Airbus',  'Airbus A320 Neo',          194),
('A380-800', 'Airbus',  'Airbus A380-800',          853),
('ATR72-600','ATR',     'ATR 72-600',                78),
('E190-E2',  'Embraer', 'Embraer 190 E2',           114),
('B787-9',   'Boeing',  'Boeing 787-9 Dreamliner',  296),
('A220-300', 'Airbus',  'Airbus A220-300',           160);

-- ------------------------------------------------------------
-- EMPLOYEE
-- ------------------------------------------------------------
INSERT INTO Employee (ssn, name, surname, union_membership_no, phone, address, hire_date) VALUES
('111-22-3001','Ali',    'Yılmaz',  'UNI-10011','05301112233','Nicosia, North Cyprus',   '2015-03-01'),
('111-22-3002','Mehmet', 'Kaya',    'UNI-10012','05302223344','Kyrenia, North Cyprus',   '2016-07-15'),
('111-22-3003','Fatma',  'Demir',   'UNI-10013','05303334455','Famagusta, North Cyprus', '2017-01-20'),
('111-22-3004','Ayşe',   'Çelik',   'UNI-10014','05304445566','Nicosia, North Cyprus',   '2018-05-10'),
('111-22-3005','Hasan',  'Arslan',  'UNI-10015','05305556677','Morphou, North Cyprus',   '2019-09-01'),
('111-22-3006','Zeynep', 'Koç',     'UNI-10016','05306667788','Nicosia, North Cyprus',   '2020-02-14'),
('111-22-3007','Murat',  'Şahin',   'UNI-10017','05307778899','Kyrenia, North Cyprus',   '2021-06-30'),
('111-22-3008','Elif',   'Yıldız',  'UNI-10018','05308889900','Nicosia, North Cyprus',   '2022-03-15'),
('111-22-3009','Osman',  'Güneş',   'UNI-10019','05309990011','Famagusta, North Cyprus', '2014-11-05'),
('111-22-3010','Hatice', 'Aydın',   'UNI-10020','05301230123','Nicosia, North Cyprus',   '2013-08-22'),
('111-22-3011','Kemal',  'Öztürk',  'UNI-10021','05302340234','Kyrenia, North Cyprus',   '2012-04-18'),
('111-22-3012','Selin',  'Erdoğan', 'UNI-10022','05303450345','Nicosia, North Cyprus',   '2023-01-09');

-- ------------------------------------------------------------
-- TECHNICIAN
-- ------------------------------------------------------------
INSERT INTO Technician (ssn, certification_level) VALUES
('111-22-3001','Senior'),
('111-22-3002','Mid'),
('111-22-3003','Senior'),
('111-22-3004','Junior'),
('111-22-3005','Mid');

-- ------------------------------------------------------------
-- TRAFFIC_CONTROLLER
-- ------------------------------------------------------------
INSERT INTO Traffic_Controller (ssn, last_medical_exam, license_no) VALUES
('111-22-3006','2024-11-15','TC-NCE-001'),
('111-22-3007','2025-03-22','TC-NCE-002'),
('111-22-3008','2024-09-10','TC-NCE-003');

-- ------------------------------------------------------------
-- AIRPORT_STAFF
-- ------------------------------------------------------------
INSERT INTO Airport_Staff (ssn, department, role) VALUES
('111-22-3009','Ground Services','Ground Crew Leader'),
('111-22-3010','Security',       'Security Officer'),
('111-22-3011','Administration', 'HR Specialist'),
('111-22-3012','Cargo',          'Cargo Handler');

-- ------------------------------------------------------------
-- TECHNICIAN_EXPERTISE
-- ------------------------------------------------------------
INSERT INTO Technician_Expertise (tech_ssn, model_no) VALUES
('111-22-3001','B737-800'),
('111-22-3001','B777-300'),
('111-22-3001','B787-9'),
('111-22-3002','A320-NEO'),
('111-22-3002','A380-800'),
('111-22-3003','B737-800'),
('111-22-3003','A320-NEO'),
('111-22-3003','ATR72-600'),
('111-22-3004','E190-E2'),
('111-22-3004','A220-300'),
('111-22-3005','B777-300'),
('111-22-3005','B787-9');

-- ------------------------------------------------------------
-- AIRPLANE
-- ------------------------------------------------------------
INSERT INTO Airplane (plane_no, model_no, capacity, status, year_manufactured) VALUES
('TC-NCE01','B737-800', 189,'Active',      2012),
('TC-NCE02','A320-NEO', 180,'Active',      2018),
('TC-NCE03','B777-300', 350,'Active',      2016),
('TC-NCE04','ATR72-600', 72,'Maintenance', 2010),
('TC-NCE05','B787-9',   280,'Active',      2020),
('TC-NCE06','A220-300', 145,'Active',      2022),
('TC-NCE07','E190-E2',  100,'Active',      2019),
('TC-NCE08','B737-800', 160,'Retired',     2005),
('TC-NCE09','A320-NEO', 194,'Maintenance', 2015),
('TC-NCE10','B777-300', 396,'Active',      2021);

-- ------------------------------------------------------------
-- HANGAR
-- ------------------------------------------------------------
INSERT INTO Hangar (hangar_no, location, max_capacity, description) VALUES
('H-01','North Terminal, Bay A', 5,'Primary maintenance hangar'),
('H-02','North Terminal, Bay B', 3,'Secondary storage hangar'),
('H-03','South Terminal, Bay C', 4,'Wide-body maintenance hangar'),
('H-04','Technical Zone, Bay D', 2,'Retired aircraft storage'),
('H-05','North Terminal, Bay E', 6,'General purpose hangar');

-- ------------------------------------------------------------
-- HANGAR_STAY
-- ------------------------------------------------------------
INSERT INTO Hangar_Stay (plane_no, hangar_no, in_datetime, out_datetime) VALUES
('TC-NCE01','H-01','2025-01-10 08:00:00','2025-01-15 17:00:00'),
('TC-NCE02','H-02','2025-02-05 09:30:00','2025-02-08 14:00:00'),
('TC-NCE03','H-03','2025-03-01 07:00:00','2025-03-20 18:00:00'),
('TC-NCE04','H-01','2025-04-01 06:00:00', NULL),
('TC-NCE05','H-05','2025-01-20 10:00:00','2025-01-25 16:00:00'),
('TC-NCE06','H-02','2025-05-10 08:00:00','2025-05-12 12:00:00'),
('TC-NCE07','H-05','2025-03-15 09:00:00','2025-03-18 11:00:00'),
('TC-NCE08','H-04','2024-11-01 08:00:00', NULL),
('TC-NCE09','H-01','2025-06-01 07:30:00', NULL),
('TC-NCE10','H-03','2025-04-10 06:00:00','2025-04-20 17:00:00'),
('TC-NCE01','H-05','2025-07-01 08:00:00','2025-07-05 15:00:00'),
('TC-NCE02','H-01','2025-08-01 07:00:00', NULL);

-- ------------------------------------------------------------
-- TEST_TYPE
-- ------------------------------------------------------------
INSERT INTO Test_Type (test_id, test_name, description, max_score, frequency) VALUES
('T001','Engine Performance Test',  'Full engine thrust and efficiency check',         100,'Monthly'),
('T002','Avionics Systems Check',   'Navigation and communication systems diagnostic', 100,'Quarterly'),
('T003','Hydraulic System Test',    'Landing gear and brake hydraulic pressure test',  100,'Monthly'),
('T004','Fuselage Integrity Scan',  'Ultrasonic scan for fuselage cracks',             100,'Annual'),
('T005','Landing Gear Inspection',  'Visual and mechanical check of landing gear',     100,'Weekly'),
('T006','Fuel System Inspection',   'Fuel tanks, lines and pumps inspection',          100,'Monthly'),
('T007','Emergency Equipment Check','Life vests, oxygen masks, slides verification',   100,'Monthly'),
('T008','Electrical Systems Test',  'Full electrical systems diagnostic',              100,'Quarterly');

-- ------------------------------------------------------------
-- TESTING_EVENT
-- (Trigger trg_low_score_maintenance fires on scores < 60)
-- ------------------------------------------------------------
INSERT INTO Testing_Event (plane_no, tech_ssn, test_id, test_date, hours_spent, score) VALUES
('TC-NCE01','111-22-3001','T001','2025-01-12', 3.5, 95),
('TC-NCE01','111-22-3003','T003','2025-01-13', 2.0, 88),
('TC-NCE02','111-22-3002','T002','2025-02-06', 4.0, 92),
('TC-NCE03','111-22-3001','T004','2025-03-05', 6.0, 78),
('TC-NCE03','111-22-3005','T001','2025-03-10', 3.5, 85),
('TC-NCE04','111-22-3003','T005','2025-04-02', 1.5, 60),
('TC-NCE04','111-22-3001','T003','2025-04-03', 2.5, 55),
('TC-NCE05','111-22-3005','T001','2025-01-22', 3.0, 98),
('TC-NCE06','111-22-3004','T006','2025-05-11', 2.0, 91),
('TC-NCE07','111-22-3004','T007','2025-03-16', 1.5, 87),
('TC-NCE08','111-22-3003','T004','2025-01-05', 5.0, 42),
('TC-NCE09','111-22-3002','T002','2025-06-02', 4.0, 73),
('TC-NCE10','111-22-3001','T001','2025-04-12', 3.5, 96),
('TC-NCE10','111-22-3005','T003','2025-04-14', 2.0, 90),
('TC-NCE01','111-22-3003','T006','2025-07-02', 2.5, 93),
('TC-NCE02','111-22-3002','T005','2025-08-02', 1.0, 89),
('TC-NCE05','111-22-3001','T008','2025-02-10', 4.5, 97),
('TC-NCE09','111-22-3003','T003','2025-06-05', 2.0, 68),
('TC-NCE03','111-22-3002','T007','2025-03-18', 1.5, 84),
('TC-NCE06','111-22-3005','T002','2025-05-20', 3.5, 95);

-- ------------------------------------------------------------
-- RUNWAY
-- ------------------------------------------------------------
INSERT INTO Runway (runway_id, length_m, width_m, surface, status) VALUES
('RWY-01', 2900, 45, 'Asphalt',  'Open'),
('RWY-02', 2900, 45, 'Asphalt',  'Open'),
('RWY-03', 1800, 30, 'Concrete', 'Maintenance');

-- ------------------------------------------------------------
-- FLIGHT
-- ------------------------------------------------------------
INSERT INTO Flight (flight_id, plane_no, controller_ssn, runway_id, origin, destination,
                    scheduled_dep, actual_dep, scheduled_arr, actual_arr, flight_status) VALUES
('ECN-001','TC-NCE01','111-22-3006','RWY-01','Ercan (ECN)','Istanbul (SAW)',
 '2025-05-01 06:00:00','2025-05-01 06:10:00','2025-05-01 07:30:00','2025-05-01 07:40:00','Landed'),
('ECN-002','TC-NCE02','111-22-3007','RWY-02','Ercan (ECN)','Ankara (ESB)',
 '2025-05-01 08:00:00','2025-05-01 08:05:00','2025-05-01 09:50:00','2025-05-01 09:55:00','Landed'),
('ECN-003','TC-NCE03','111-22-3006','RWY-01','Istanbul (SAW)','Ercan (ECN)',
 '2025-05-02 10:00:00','2025-05-02 10:20:00','2025-05-02 11:50:00','2025-05-02 12:05:00','Landed'),
('ECN-004','TC-NCE05','111-22-3008','RWY-02','Ercan (ECN)','London (LHR)',
 '2025-05-03 14:00:00','2025-05-03 14:00:00','2025-05-03 17:30:00','2025-05-03 17:28:00','Landed'),
('ECN-005','TC-NCE06','111-22-3007','RWY-01','Ercan (ECN)','Istanbul (SAW)',
 '2025-05-10 09:00:00', NULL,'2025-05-10 10:30:00', NULL,'Scheduled'),
('ECN-006','TC-NCE10','111-22-3006','RWY-02','Ercan (ECN)','Frankfurt (FRA)',
 '2025-05-12 15:00:00', NULL,'2025-05-12 18:00:00', NULL,'Cancelled');

-- ------------------------------------------------------------
-- FUEL_RECORD
-- ------------------------------------------------------------
INSERT INTO Fuel_Record (plane_no, staff_ssn, fuel_date, fuel_type, liters, cost_usd) VALUES
('TC-NCE01','111-22-3009','2025-04-30 05:00:00','Jet-A1', 15000.00, 18750.00),
('TC-NCE02','111-22-3009','2025-04-30 07:00:00','Jet-A1', 12000.00, 15000.00),
('TC-NCE03','111-22-3012','2025-05-01 09:00:00','Jet-A1', 28000.00, 35000.00),
('TC-NCE05','111-22-3009','2025-05-02 13:00:00','Jet-A',  24000.00, 31200.00),
('TC-NCE06','111-22-3012','2025-05-09 08:00:00','Jet-A1', 10000.00, 12500.00),
('TC-NCE10','111-22-3009','2025-05-11 14:00:00','Jet-A1', 32000.00, 40000.00);

-- ------------------------------------------------------------
-- DML: UPDATE examples
-- ------------------------------------------------------------
-- Update medical exam date for a traffic controller
UPDATE Traffic_Controller
SET last_medical_exam = '2025-05-01'
WHERE ssn = '111-22-3007';

-- Promote a technician
UPDATE Technician
SET certification_level = 'Senior'
WHERE ssn = '111-22-3002';

-- Mark a flight as delayed
UPDATE Flight
SET flight_status = 'Delayed'
WHERE flight_id = 'ECN-005';

-- ------------------------------------------------------------
-- DML: DELETE example (commented — preserves query data)
-- ------------------------------------------------------------
-- DELETE FROM Testing_Event WHERE event_id = 999;

