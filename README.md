IoT Operations Platform – SQL Server Lab 8
Transactional Integrity, Concurrency Control, and RBAC in SQL Server
AdventureWorks2019 – IoT Schema
##  Overview
This project is part of Lab 8 from my SQL Server class.
The goal was to design and implement the backend database components for an IoT platform used by AdventureWorks. The system needs to ingest telemetry from thousands of devices, ensure reliable transactions, handle concurrency, and enforce strict role-based access control.
The lab is divided into 6 major tasks:
Schema & table creation
Transaction logic through a stored procedure
Failure scenario testing
Concurrency tests
Role & permission design
Permission validation with real logins
All SQL scripts for each task are included in this repository.
##  Files in This Repository
01_Schema_and_Tables.sql
Creates the full IoT schema, including:
IoT.Device
IoT.Telemetry
IoT.DeviceHealth
IoT.Alert
IoT.TelemetryErrorLog
IoT.TelemetryAudit
IoT.MaintenanceLog
IoT.DeviceOwner
This is the foundation of the IoT database.
02_Transaction_Logic.sql
Contains the stored procedure:
IoT.IngestTelemetry
This procedure handles:
Device validation
Sensor data checks
Inserting telemetry
Updating LastHeartbeat
Creating DeviceHealth
Generating alerts
Writing audit logs
Error handling + rollback
All steps run inside a single transaction to guarantee atomicity.
03_Concurrency_Tests.sql
Contains Session A & Session B scripts used to test:
Blocking
Dirty reads
Snapshot reads
Serializable isolation
Effects of simultaneous writes on the same device
Also includes enabling snapshot isolation.
04_Roles_and_Permissions.sql
Implements 5 custom roles:
Role	Purpose
IoTDeviceAgent	Can register/update devices
TelemetryIngestionService	Inserts telemetry & device health
IoTAnalyst	Read-only analytical access
IoTFieldTechnician	Writes maintenance logs
SecurityComplianceOfficer	Read-only compliance monitoring
Permissions follow the least privilege principle.
05_Role_Test_Scenarios.sql
Tests each role’s permissions:
INSERT / UPDATE / SELECT tests
Expected success or denial messages
Matches all security requirements of the business case
This script was executed using separate SQL logins for each role.
06_Task2Task3_Error_Tests.sql
Shows successful ingestion plus 3 required error scenarios:
Invalid DeviceID
Battery > 100
GPS NULL
Each failure rolls back correctly and writes into TelemetryErrorLog.
##  Concurrency Notes
Using two SQL sessions, I confirmed:
READ UNCOMMITTED → dirty reads
READ COMMITTED → prevents dirty reads but causes blocking
SNAPSHOT → no blocking and reads older committed rows
SERIALIZABLE → strictest, highest blocking
This matched expected SQL Server behavior.
##  Role-Based Access Control Summary
Role	Allowed	Denied
IoTDeviceAgent	INSERT/UPDATE Device	Telemetry, DeviceOwner
TelemetryIngestionService	INSERT Telemetry/Health	SELECT customer tables
IoTAnalyst	SELECT Telemetry/Health	All writes
IoTFieldTechnician	INSERT MaintenanceLog	SELECT DeviceOwner
SecurityComplianceOfficer	SELECT Device, DeviceOwner, Telemetry	All writes
All permission tests produced correct results.
##  How to Run
Restore AdventureWorks2019
Run the scripts in this order:
01_Schema_and_Tables.sql  
02_Transaction_Logic.sql  
03_Concurrency_Tests.sql  
04_Roles_and_Permissions.sql  
Create logins in SQL Server
Use 05_Role_Test_Scenarios.sql to validate permissions
Use 06_Task2Task3_Error_Tests.sql to check error handling
##  Conclusion
This project helped me understand how SQL Server handles:
Transaction management
Error handling and rollback
Concurrency and isolation levels
Role-based security design
Realistic IoT data ingestion
It was a challenging lab but also one of the most practical ones in the course.
