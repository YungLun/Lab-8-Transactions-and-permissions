UPDATE IoT.Device
SET Status = 'UpdatingBySessionB'
WHERE DeviceID = 1;


EXEC IoT.IngestTelemetry
    @DeviceID = 1,
    @Speed = 10,
    @Cadence = 50,
    @Temperature = 25,
    @BatteryLevel = 80,
    @Latitude = 45.1,
    @Longitude = -70.5;


--READ UNCOMMITTED_Dirty Read
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT * FROM IoT.Telemetry WHERE TelemetryID = 1;

--READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT * FROM IoT.Telemetry WHERE TelemetryID = 1;



--SNAPSHOT
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
SELECT * FROM IoT.Telemetry WHERE TelemetryID = 1;


--SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT * FROM IoT.Telemetry WHERE DeviceID = 1;

