# CMPE343 – Ercan Airport Management Information System

A full RDBMS project for Ercan Airport (ECN), North Cyprus.  
Course: Database Management Systems and Programming I

## Database: MySQL 8.0+

## Quick Setup

```bash
# 1. Create database, all tables, views, triggers and stored procedures
mysql -u root -p < 01_DDL.sql

# 2. Insert sample data
mysql -u root -p < 02_DML.sql

# 3. Run all 15 management queries
mysql -u root -p airport_mgmt < 03_Queries.sql
```

## Files

| File | Description |
|------|-------------|
| `01_DDL.sql` | 14 tables, 3 views, 3 triggers, 3 stored procedures |
| `02_DML.sql` | Sample data (12 employees, 10 planes, 20 tests, 6 flights…) |
| `03_Queries.sql` | 15 statistical management queries |
| `04_Report.md` | Full project report |

## Schema Overview

**14 Tables:** Employee, Technician, Traffic_Controller, Airport_Staff,  
Airplane_Model, Technician_Expertise, Airplane, Hangar, Hangar_Stay,  
Test_Type, Testing_Event, Runway, Flight, Fuel_Record, Audit_Log

**3 Views:** vw_hangar_occupancy, vw_employee_roster, vw_airplane_health

**3 Triggers:** low score → maintenance status, date validation, audit log

**3 Stored Procedures:** test history, hangar check-in, hangar check-out
