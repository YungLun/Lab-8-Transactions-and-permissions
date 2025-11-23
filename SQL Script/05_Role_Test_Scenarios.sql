USE AdventureWorks2019;
GO


--IoTDeviceAgent
--update IoT.Device
UPDATE IoT.Device
SET Status = 'Active'
WHERE DeviceID = 1;


--insert
INSERT INTO IoT.Telemetry (DeviceID, Timestamp, Speed, Cadence, Temperature, BatteryLevel, GPSLatitude, GPSLongitude)
VALUES (1, SYSDATETIME(), 10, 80, 25, 90, 40.7128, -74.0060);


--main account insert
USE AdventureWorks2019;
GO

INSERT INTO IoT.Device (SerialNumber, DeviceType, FirmwareVersion, Status)
VALUES ('SN0001', 'SmartBike', '1.0', 'Active');

SELECT * FROM IoT.Device;

--TelemetryIngestionService
--INSERT Telemetry
USE AdventureWorks2019;
GO

INSERT INTO IoT.Telemetry (DeviceID, Timestamp, Speed, Cadence, Temperature, BatteryLevel, GPSLatitude, GPSLongitude)
VALUES (1, SYSDATETIME(), 12, 85, 23, 88, 40.7128, -74.0060);


--test:SELECT DeviceOwner
SELECT * FROM IoT.DeviceOwner;

--test: UPDATE IoT.Device
UPDATE IoT.Device
SET Status = 'Inactive'
WHERE DeviceID = 1;



--IoTAnalyst
--test: SELECT IoT.Telemetry
USE AdventureWorks2019;
GO
SELECT TOP 10 * FROM IoT.Telemetry;


--test: SELECT IoT.DeviceHealth
SELECT TOP 10 * FROM IoT.DeviceHealth;


--test: INSERT Telemetry
INSERT INTO IoT.Telemetry (DeviceID, Timestamp, Speed, Cadence, Temperature, BatteryLevel, GPSLatitude, GPSLongitude)
VALUES (1, SYSDATETIME(), 10, 80, 25, 90, 40.7128, -74.0060);

--test: SELECT DeviceOwner
SELECT * FROM IoT.DeviceOwner;



--IoTFieldTechnician
--INSERT MaintenanceLog
USE AdventureWorks2019;
GO

INSERT INTO IoT.MaintenanceLog (DeviceID, TechnicianName, Notes)
VALUES (1, 'Tech John', 'Performed routine inspection.');


--UPDATE MaintenanceLog
UPDATE IoT.MaintenanceLog
SET Notes = 'Updated notes by technician.'
WHERE LogID = 1;

--SELECT DeviceOwner
SELECT * FROM IoT.DeviceOwner;


--INSERT Telemetry
INSERT INTO IoT.Telemetry (DeviceID, Timestamp, Speed)
VALUES (1, SYSDATETIME(), 20);



--SecurityComplianceOfficer
USE AdventureWorks2019;
GO

-- SELECT Device
SELECT TOP 10 * FROM IoT.Device;

-- SELECT DeviceOwner
SELECT TOP 10 * FROM IoT.DeviceOwner;

-- SELECT Telemetry
SELECT TOP 10 * FROM IoT.Telemetry;

-- INSERT
INSERT INTO IoT.Device (SerialNumber, DeviceType, FirmwareVersion, Status)
VALUES ('TEST01', 'SmartBike', '1.0', 'Active');

--UPDATE
UPDATE IoT.Device
SET Status = 'Inactive'
WHERE DeviceID = 1;

--DELETE 
DELETE FROM IoT.Telemetry WHERE TelemetryID = 1;
