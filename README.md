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
IoT.IngestTelemetry

Functions included:

- Device validation  
- Sensor data validation  
- Insert telemetry  
- Update LastHeartbeat  
- Insert DeviceHealth  
- Generate alerts  
- Write to TelemetryAudit  
- Error handling and rollback  

---

### **03_Concurrency_Tests.sql**
Includes:

- Session A (locks & updates)  
- Session B (reads under different isolation levels)  
- Snapshot isolation setup  

Tests for:

- Dirty reads  
- Blocking  
- Snapshot reads  
- Serializable behavior  

---

### **04_Roles_and_Permissions.sql**
Implements five roles according to IoT security requirements:

| Role | Purpose |
|------|---------|
| **IoTDeviceAgent** | Registers/updates devices |
| **TelemetryIngestionService** | Writes telemetry & health records |
| **IoTAnalyst** | Read-only analytics |
| **IoTFieldTechnician** | Writes maintenance logs |
| **SecurityComplianceOfficer** | Read-only compliance monitoring |

Permissions follow the **least privilege** principle.

---

### **05_Role_Test_Scenarios.sql**
Tests each role:

- Allowed operations return success  
- Disallowed operations return permission denied  
- Matches the business-case security model  

---

### **06_Task2Task3_Error_Tests.sql**
Includes:

- Successful ingestion test  
- Three required failure scenarios:
  - Invalid DeviceID  
  - Battery > 100  
  - GPS NULL  

The stored procedure correctly rolls back and logs to TelemetryErrorLog.

---

##  Concurrency Notes

Using two SQL sessions:

- **READ UNCOMMITTED** → dirty reads  
- **READ COMMITTED** → prevents dirty reads, causes blocking  
- **SNAPSHOT** → no blocking, reads versioned rows  
- **SERIALIZABLE** → strictest, highest blocking  

---

##  Role-Based Access Summary

| Role | Allowed | Denied |
|------|---------|--------|
| IoTDeviceAgent | INSERT/UPDATE Device | Telemetry, DeviceOwner |
| TelemetryIngestionService | INSERT Telemetry/Health | SELECT customer tables |
| IoTAnalyst | SELECT Telemetry/Health | All DML + DeviceOwner |
| IoTFieldTechnician | INSERT MaintenanceLog | SELECT DeviceOwner, Telemetry |
| SecurityComplianceOfficer | SELECT Device, Owner, Telemetry | All writes |

---

##  How to Run

1. Restore **AdventureWorks2019**  
2. Run the scripts in this order:  

01_Schema_and_Tables.sql
02_Transaction_Logic.sql
03_Concurrency_Tests.sql
04_Roles_and_Permissions.sql

3. Create logins  
4. Run **05_Role_Test_Scenarios.sql** to verify permissions  
5. Run **06_Task2Task3_Error_Tests.sql** to verify error handling  

---

##  Conclusion

This lab helped me understand how SQL Server handles:

- Transactions & rollback  
- Error handling in stored procedures  
- Locking and isolation levels  
- Designing least-privilege RBAC roles  
- Building a realistic data ingestion pipeline for IoT telemetry  

It was challenging but very practical.

---


