USE AdventureWorks2019;
GO

CREATE OR ALTER PROCEDURE IoT.IngestTelemetry
(
    @DeviceID INT,
    @Speed DECIMAL(6,2),
    @Cadence INT,
    @Temperature DECIMAL(5,2),
    @BatteryLevel DECIMAL(5,2),
    @Latitude DECIMAL(9,6),
    @Longitude DECIMAL(9,6)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Record processing start time for audit
    DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
    DECLARE @RecordsInserted INT = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        ---------------------------------------------------------
        -- Step 1: Validate that the Device exists
        ---------------------------------------------------------
        IF NOT EXISTS (SELECT 1 FROM IoT.Device WHERE DeviceID = @DeviceID)
        BEGIN
            THROW 50001, 'DeviceID does not exist.', 1;
        END

        ---------------------------------------------------------
        -- Step 2: Data validation (Temperature, Battery, Coordinates)
        ---------------------------------------------------------
        IF @Temperature < -50 OR @Temperature > 150
            THROW 50002, 'Temperature out of sensor range.', 1;

        IF @BatteryLevel < 0 OR @BatteryLevel > 100
            THROW 50003, 'Invalid battery level.', 1;

        IF @Latitude IS NULL OR @Longitude IS NULL
            THROW 50004, 'GPS coordinates cannot be NULL.', 1;

        ---------------------------------------------------------
        -- Step 3: Insert raw telemetry data
        ---------------------------------------------------------
        INSERT INTO IoT.Telemetry
        (
            DeviceID, Speed, Cadence, Temperature, BatteryLevel,
            GPSLatitude, GPSLongitude
        )
        VALUES
        (
            @DeviceID, @Speed, @Cadence, @Temperature, @BatteryLevel,
            @Latitude, @Longitude
        );

        SET @RecordsInserted += 1;

        ---------------------------------------------------------
        -- Step 4: Update device LastHeartbeat timestamp
        ---------------------------------------------------------
        UPDATE IoT.Device
        SET LastHeartbeat = SYSUTCDATETIME()
        WHERE DeviceID = @DeviceID;

        ---------------------------------------------------------
        -- Step 5: Calculate DeviceHealth (Temp/Battery status)
        ---------------------------------------------------------
        DECLARE @TempStatus NVARCHAR(20), @BattStatus NVARCHAR(20);

        SET @TempStatus =
            CASE 
                WHEN @Temperature > 100 THEN 'High'
                WHEN @Temperature < -10 THEN 'Low'
                ELSE 'Normal'
            END;

        SET @BattStatus =
            CASE 
                WHEN @BatteryLevel < 20 THEN 'Low'
                ELSE 'Normal'
            END;

        INSERT INTO IoT.DeviceHealth
        (
            DeviceID, IsHealthy, TemperatureStatus, BatteryStatus, VibrationStatus
        )
        VALUES
        (
            @DeviceID,
            CASE WHEN @TempStatus = 'Normal' AND @BattStatus = 'Normal' THEN 1 ELSE 0 END,
            @TempStatus, @BattStatus, 'Normal'
        );

        SET @RecordsInserted += 1;

        ---------------------------------------------------------
        -- Step 6: Generate alerts based on conditions
        ---------------------------------------------------------

        -- Low battery alert
        IF @BatteryLevel < 20
        BEGIN
            INSERT INTO IoT.Alert
            (DeviceID, AlertType, Severity, Description)
            VALUES
            (@DeviceID, 'Low Battery', 'Medium', 'Battery below 20%');
            SET @RecordsInserted += 1;
        END

        -- High temperature alert
        IF @Temperature > 100
        BEGIN
            INSERT INTO IoT.Alert
            (DeviceID, AlertType, Severity, Description)
            VALUES
            (@DeviceID, 'High Temperature', 'High', 'Temperature exceeded safe limit');
            SET @RecordsInserted += 1;
        END

        -- Invalid coordinates alert
        IF ABS(@Latitude) > 90 OR ABS(@Longitude) > 180
        BEGIN
            INSERT INTO IoT.Alert
            (DeviceID, AlertType, Severity, Description)
            VALUES
            (@DeviceID, 'Invalid Coordinates', 'Low', 'Lat/Lon beyond valid range');
            SET @RecordsInserted += 1;
        END

        ---------------------------------------------------------
        -- Step 7: Insert success record into TelemetryAudit
        ---------------------------------------------------------
        INSERT INTO IoT.TelemetryAudit
        (DeviceID, ProcessingDuration, RecordsInserted, Status)
        VALUES
        (
            @DeviceID,
            DATEDIFF(MILLISECOND, @StartTime, SYSUTCDATETIME()),
            @RecordsInserted,
            'Success'
        );

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        -- Roll back the transaction
        ROLLBACK TRANSACTION;

        ---------------------------------------------------------
        -- Log error details into TelemetryErrorLog
        ---------------------------------------------------------
        INSERT INTO IoT.TelemetryErrorLog
        (DeviceID, ErrorMessage, ErrorStep, RawPayload)
        VALUES
        (
            @DeviceID,
            ERROR_MESSAGE(),
            'Telemetry Ingestion',
            CONCAT('Speed=', @Speed, ', Temp=', @Temperature, ', Battery=', @BatteryLevel)
        );

        -- Re-throw error to SSMS
        THROW;
    END CATCH
END;
GO
