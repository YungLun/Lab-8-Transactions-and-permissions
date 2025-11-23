#  IoT Operations Platform – SQL Server Lab 8  
Transactional Integrity, Concurrency Control, and RBAC in SQL Server  
AdventureWorks2019 – IoT Schema

---

##  Overview

This project is part of Lab 8 from my SQL Server course.  
The objective was to design and implement database components for an IoT backend system.  
The system must support reliable telemetry ingestion, handle concurrent operations,  
and enforce security using role-based permissions.

The lab contains 6 tasks:

1. Schema & table creation  
2. Transaction logic (stored procedure)  
3. Failure scenario testing  
4. Concurrency tests  
5. Role & permission design  
6. Permission validation

---

##  Files in This Repository

### **01_Schema_and_Tables.sql**
Creates the full IoT schema:

- IoT.Device  
- IoT.Telemetry  
- IoT.DeviceHealth  
- IoT.Alert  
- IoT.TelemetryErrorLog  
- IoT.TelemetryAudit  
- IoT.MaintenanceLog  
- IoT.DeviceOwner  

---

### **02_Transaction_Logic.sql**
Contains stored procedure:

