-- ============================
-- Server-level LOGINS
-- ============================

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'IoTDeviceAgentLogin')
    CREATE LOGIN IoTDeviceAgentLogin WITH PASSWORD = 'P@ssword123!';
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'TelemetryIngestionLogin')
    CREATE LOGIN TelemetryIngestionLogin WITH PASSWORD = 'P@ssword123!';
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'IoTAnalystLogin')
    CREATE LOGIN IoTAnalystLogin WITH PASSWORD = 'P@ssword123!';
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'IoTFieldTechLogin')
    CREATE LOGIN IoTFieldTechLogin WITH PASSWORD = 'P@ssword123!';
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'SecurityComplianceLogin')
    CREATE LOGIN SecurityComplianceLogin WITH PASSWORD = 'P@ssword123!';
GO


USE AdventureWorks2019;
GO
-- MaintenanceLog
IF OBJECT_ID('IoT.MaintenanceLog', 'U') IS NULL
BEGIN
    CREATE TABLE IoT.MaintenanceLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        DeviceID INT NOT NULL,
        TechnicianName NVARCHAR(100) NOT NULL,
        MaintenanceDate DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
        Notes NVARCHAR(2000) NULL,
        CONSTRAINT FK_MaintenanceLog_Device FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
    );
END
GO

-- DeviceOwner
IF OBJECT_ID('IoT.DeviceOwner', 'U') IS NULL
BEGIN
    CREATE TABLE IoT.DeviceOwner (
        OwnerID INT IDENTITY(1,1) PRIMARY KEY,
        DeviceID INT NOT NULL,
        OwnerName NVARCHAR(100),
        SensitiveInfo NVARCHAR(100),
        CONSTRAINT FK_DeviceOwner_Device FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
    );
END
GO


-- ============================
-- IoTDeviceAgent
-- ============================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'IoTDeviceAgentUser')
    CREATE USER IoTDeviceAgentUser FOR LOGIN IoTDeviceAgentLogin;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'IoTDeviceAgent')
    CREATE ROLE IoTDeviceAgent;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members drm
    JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
    JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
    WHERE r.name = 'IoTDeviceAgent' AND m.name = 'IoTDeviceAgentUser'
)
    ALTER ROLE IoTDeviceAgent ADD MEMBER IoTDeviceAgentUser;
GO

GRANT CONNECT TO IoTDeviceAgentUser;
GO


-- ============================
-- TelemetryIngestionService
-- ============================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'TelemetryIngestionUser')
    CREATE USER TelemetryIngestionUser FOR LOGIN TelemetryIngestionLogin;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'TelemetryIngestionService')
    CREATE ROLE TelemetryIngestionService;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members drm
    JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
    JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
    WHERE r.name = 'TelemetryIngestionService' AND m.name = 'TelemetryIngestionUser'
)
    ALTER ROLE TelemetryIngestionService ADD MEMBER TelemetryIngestionUser;
GO

GRANT CONNECT TO TelemetryIngestionUser;
GO


-- ============================
-- IoTAnalyst
-- ============================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'IoTAnalystUser')
    CREATE USER IoTAnalystUser FOR LOGIN IoTAnalystLogin;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'IoTAnalyst')
    CREATE ROLE IoTAnalyst;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members drm
    JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
    JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
    WHERE r.name = 'IoTAnalyst' AND m.name = 'IoTAnalystUser'
)
    ALTER ROLE IoTAnalyst ADD MEMBER IoTAnalystUser;
GO

GRANT CONNECT TO IoTAnalystUser;
GO


-- ============================
-- IoTFieldTechnician
-- ============================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'IoTFieldTechUser')
    CREATE USER IoTFieldTechUser FOR LOGIN IoTFieldTechLogin;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'IoTFieldTechnician')
    CREATE ROLE IoTFieldTechnician;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members drm
    JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
    JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
    WHERE r.name = 'IoTFieldTechnician' AND m.name = 'IoTFieldTechUser'
)
    ALTER ROLE IoTFieldTechnician ADD MEMBER IoTFieldTechUser;
GO

GRANT CONNECT TO IoTFieldTechUser;
GO


-- ============================
-- SecurityComplianceOfficer
-- ============================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'SecurityComplianceUser')
    CREATE USER SecurityComplianceUser FOR LOGIN SecurityComplianceLogin;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'SecurityComplianceOfficer')
    CREATE ROLE SecurityComplianceOfficer;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members drm
    JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
    JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
    WHERE r.name = 'SecurityComplianceOfficer' AND m.name = 'SecurityComplianceUser'
)
    ALTER ROLE SecurityComplianceOfficer ADD MEMBER SecurityComplianceUser;
GO

GRANT CONNECT TO SecurityComplianceUser;
GO





--GRANT / DENY
--IoTDeviceAgent
-- ¥i¥H insert / update IoT.Device
GRANT SELECT ON IoT.Device TO IoTDeviceAgent; 
GRANT INSERT, UPDATE ON IoT.Device TO IoTDeviceAgent;

-- Telemetry
DENY INSERT, UPDATE, DELETE ON IoT.Telemetry TO IoTDeviceAgent;

-- DeviceOwner
DENY SELECT ON IoT.DeviceOwner TO IoTDeviceAgent;
GO


--TelemetryIngestionService
GRANT INSERT ON IoT.Telemetry TO TelemetryIngestionService;
GRANT INSERT ON IoT.DeviceHealth TO TelemetryIngestionService;

-- LastHeartbeat
GRANT UPDATE ON IoT.Device (LastHeartbeat) TO TelemetryIngestionService;


-- DENY UPDATE ON IoT.Device (SerialNumber, DeviceType, FirmwareVersion, Status) TO TelemetryIngestionService;

DENY SELECT ON IoT.DeviceOwner TO TelemetryIngestionService;
GO


--IoTAnalyst
GRANT SELECT ON IoT.Telemetry TO IoTAnalyst;
GRANT SELECT ON IoT.DeviceHealth TO IoTAnalyst;

DENY INSERT, UPDATE, DELETE ON IoT.Telemetry TO IoTAnalyst;
DENY INSERT, UPDATE, DELETE ON IoT.DeviceHealth TO IoTAnalyst;
DENY INSERT, UPDATE, DELETE ON IoT.Device TO IoTAnalyst;
DENY INSERT, UPDATE, DELETE ON IoT.Alert TO IoTAnalyst;
DENY INSERT, UPDATE, DELETE ON IoT.TelemetryAudit TO IoTAnalyst;
DENY INSERT, UPDATE, DELETE ON IoT.TelemetryErrorLog TO IoTAnalyst;
DENY INSERT, UPDATE, DELETE ON IoT.MaintenanceLog TO IoTAnalyst;
DENY INSERT, UPDATE, DELETE ON IoT.DeviceOwner TO IoTAnalyst;


DENY SELECT ON IoT.DeviceOwner TO IoTAnalyst;
GO


--IoTFieldTechnician
GRANT INSERT, UPDATE ON IoT.MaintenanceLog TO IoTFieldTechnician;

--DeviceOwner¡]customer mapping¡^
DENY SELECT ON IoT.DeviceOwner TO IoTFieldTechnician;
GO


--SecurityComplianceOfficer
-- read only¡GDevice / DeviceOwner / Telemetry
GRANT SELECT ON IoT.Device TO SecurityComplianceOfficer;
GRANT SELECT ON IoT.DeviceOwner TO SecurityComplianceOfficer;
GRANT SELECT ON IoT.Telemetry TO SecurityComplianceOfficer;

-- can't motify IoT table
DENY INSERT, UPDATE, DELETE ON IoT.Device TO SecurityComplianceOfficer;
DENY INSERT, UPDATE, DELETE ON IoT.DeviceOwner TO SecurityComplianceOfficer;
DENY INSERT, UPDATE, DELETE ON IoT.Telemetry TO SecurityComplianceOfficer;
DENY INSERT, UPDATE, DELETE ON IoT.DeviceHealth TO SecurityComplianceOfficer;
DENY INSERT, UPDATE, DELETE ON IoT.Alert TO SecurityComplianceOfficer;
DENY INSERT, UPDATE, DELETE ON IoT.MaintenanceLog TO SecurityComplianceOfficer;
DENY INSERT, UPDATE, DELETE ON IoT.TelemetryAudit TO SecurityComplianceOfficer;
DENY INSERT, UPDATE, DELETE ON IoT.TelemetryErrorLog TO SecurityComplianceOfficer;
GO
