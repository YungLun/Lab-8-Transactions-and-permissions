
--Validate device registration in IoT.Device.

INSERT INTO IoT.Device (SerialNumber, DeviceType, FirmwareVersion)
VALUES ('TEST-123', 'SmartBike', '1.0');

SELECT * FROM IoT.Device;

EXEC IoT.IngestTelemetry
    @DeviceID = 1,
    @Speed = 20.5,
    @Cadence = 75,
    @Temperature = 35.2,
    @BatteryLevel = 85,
    @Latitude = 43.651070,
    @Longitude = -79.347015;


--Insert telemetry record into IoT.Telemetry.
SELECT TOP 5 * FROM IoT.Telemetry ORDER BY TelemetryID DESC;


--DeviceHealth
SELECT TOP 5 * FROM IoT.DeviceHealth ORDER BY HealthID DESC;


--TelemetryAudit
SELECT TOP 5 * FROM IoT.TelemetryAudit ORDER BY AuditID DESC;


--Task 3: Failure Scenario Demonstration
--Tast:Invalid DeviceID
EXEC IoT.IngestTelemetry
    @DeviceID = 999999,   -- Invalid DeviceID
    @Speed = 15,
    @Cadence = 60,
    @Temperature = 30,
    @BatteryLevel = 80,
    @Latitude = 40.1,
    @Longitude = -70.5;

SELECT TOP 5 * FROM IoT.TelemetryErrorLog ORDER BY ErrorID DESC;



--Tast:BatteryLevel > 100
EXEC IoT.IngestTelemetry
    @DeviceID = 1,
    @Speed = 18,
    @Cadence = 70,
    @Temperature = 25,
    @BatteryLevel = 150,   -- BatteryLevel > 100
    @Latitude = 40.1,
    @Longitude = -70.5;

SELECT TOP 5 * FROM IoT.TelemetryErrorLog ORDER BY ErrorID DESC;



--Tast:GPS NULL
EXEC IoT.IngestTelemetry
    @DeviceID = 1,
    @Speed = 10,
    @Cadence = 50,
    @Temperature = 22,
    @BatteryLevel = 55,
    @Latitude = NULL,    -- GPS NULL
    @Longitude = NULL;

SELECT TOP 5 * FROM IoT.TelemetryErrorLog ORDER BY ErrorID DESC;

