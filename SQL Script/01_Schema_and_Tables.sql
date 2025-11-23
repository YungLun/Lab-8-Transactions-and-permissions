USE AdventureWorks2019;
GO


CREATE SCHEMA IoT AUTHORIZATION dbo;
GO

CREATE TABLE IoT.Device (
    DeviceID            INT IDENTITY(1,1)      NOT NULL PRIMARY KEY,
    SerialNumber        NVARCHAR(50)          NOT NULL UNIQUE,
    DeviceType          NVARCHAR(50)          NOT NULL,
    FirmwareVersion     NVARCHAR(20)          NULL,
    RegistrationDate    DATETIME2(0)          NOT NULL DEFAULT SYSUTCDATETIME(),
    LastHeartbeat       DATETIME2(0)          NULL,
    Status              NVARCHAR(20)          NOT NULL DEFAULT N'Active'
);
GO


CREATE TABLE IoT.Telemetry (
    TelemetryID     BIGINT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
    DeviceID        INT                   NOT NULL,
    [Timestamp]     DATETIME2(0)          NOT NULL DEFAULT SYSUTCDATETIME(),
    Speed           DECIMAL(6,2)          NULL,
    Cadence         INT                   NULL,
    Temperature     DECIMAL(5,2)          NULL,
    BatteryLevel    DECIMAL(5,2)          NULL,
    GPSLatitude     DECIMAL(9,6)          NULL,
    GPSLongitude    DECIMAL(9,6)          NULL,
    CONSTRAINT FK_Telemetry_Device
        FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
);
GO


CREATE TABLE IoT.DeviceHealth (
    HealthID            BIGINT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
    DeviceID            INT                   NOT NULL,
    [Timestamp]         DATETIME2(0)          NOT NULL DEFAULT SYSUTCDATETIME(),
    IsHealthy           BIT                   NOT NULL,
    TemperatureStatus   NVARCHAR(20)          NOT NULL,
    BatteryStatus       NVARCHAR(20)          NOT NULL,
    VibrationStatus     NVARCHAR(20)          NOT NULL,
    CONSTRAINT FK_DeviceHealth_Device
        FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
);
GO


CREATE TABLE IoT.Alert (
    AlertID       BIGINT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
    DeviceID      INT                   NOT NULL,
    [Timestamp]   DATETIME2(0)          NOT NULL DEFAULT SYSUTCDATETIME(),
    AlertType     NVARCHAR(50)          NOT NULL,
    Severity      NVARCHAR(10)          NOT NULL,
    [Description] NVARCHAR(4000)        NULL,
    CONSTRAINT FK_Alert_Device
        FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
);
GO



CREATE TABLE IoT.TelemetryErrorLog (
    ErrorID       BIGINT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
    DeviceID      INT                   NULL,
    [Timestamp]   DATETIME2(0)          NOT NULL DEFAULT SYSUTCDATETIME(),
    ErrorMessage  NVARCHAR(4000)        NOT NULL,
    ErrorStep     NVARCHAR(100)         NULL,
    RawPayload    NVARCHAR(MAX)         NULL
);
GO



CREATE TABLE IoT.TelemetryAudit (
    AuditID            BIGINT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
    DeviceID           INT                   NOT NULL,
    [Timestamp]        DATETIME2(0)          NOT NULL DEFAULT SYSUTCDATETIME(),
    ProcessingDuration INT                   NULL,   -- 毫秒數（之後在 SP 算）
    RecordsInserted    INT                   NOT NULL,
    [Status]           NVARCHAR(20)          NOT NULL,
    CONSTRAINT FK_TelemetryAudit_Device
        FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
);
GO

