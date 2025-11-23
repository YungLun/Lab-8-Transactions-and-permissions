BEGIN TRANSACTION;

UPDATE IoT.Device
SET Status = 'UpdatingBySessionA'
WHERE DeviceID = 1;

COMMIT TRANSACTION;

BEGIN TRANSACTION;

UPDATE IoT.Device
SET Status = 'Locked'
WHERE DeviceID = 1;


--READ UNCOMMITTED
BEGIN TRANSACTION;

UPDATE IoT.Telemetry
SET Speed = Speed + 100   
WHERE TelemetryID = 1;


--SERIALIZABLE
BEGIN TRANSACTION;
INSERT INTO IoT.Telemetry (DeviceID, Speed, Cadence, Temperature, BatteryLevel, GPSLatitude, GPSLongitude)
VALUES (1, 1, 1, 1, 1, 1, 1);


