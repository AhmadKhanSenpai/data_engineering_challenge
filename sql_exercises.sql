-- Active: 1784660427354@@127.0.0.1@5432@sensor_data
-- Active: 1784660427354@@127.0.0.1@5432@sensor_data


-- Exercise 1) 
-- Return all columns.
-- Only show rows where site_code = TEST-01
SELECT
    *
FROM sensor_readings
WHERE 
    site_code = 'TEST-01'


-- Exercise 2)
-- Return only: 
-- timestamp
-- source_tag
-- total_voltage
SELECT
    timestamp,
    source_tag,
    total_voltage
FROM sensor_readings


-- Exercise 3
-- Show only rows where
-- source_tag contains DG
-- Don't worry about case sensitivity yet.
SELECT
    *
FROM sensor_readings
WHERE
    source_tag LIKE '%DG%'


-- Exercise 4
-- Show rows where
-- source_tag contains Solar

SELECT
    *
FROM sensor_readings
WHERE source_tag LIKE '%Solar%'


-- Exercise 5
SELECT
    *
FROM sensor_readings
WHERE total_voltage > 50


-- Exercise 6
-- Show rows where
-- total_voltage >= 50
-- AND
-- source_tag contains DG

SELECT
    *
FROM sensor_readings
WHERE
    total_voltage >= 50
    AND
    source_tag ILIKE '%dg%'


-- Exercise 7
-- Show rows where
-- source_tag contains DG
-- OR
-- source_tag contains Battery
SELECT
    *
FROM sensor_readings
WHERE
    source_tag ILIKE '%dg%'
    OR
    source_tag ILIKE '%battery%'


-- Exercise 8
-- Now combine both.
-- Return rows where
-- site_code = TEST-01
-- AND
-- (
-- source_tag contains DG
-- OR
-- source_tag contains Battery
-- )
-- This is where parentheses become important.

SELECT
    *
FROM sensor_readings
WHERE
    site_code = 'TEST-01'
    AND
    (source_tag ILIKE '%dg%'
    OR
    source_tag ILIKE '%battery%')


-- Exercise 9
-- Find all rows where
-- battery_total_current
-- is negative

SELECT
    *
FROM sensor_readings
WHERE
    battery_total_current < 0


-- Exercise 10
-- This one resembles your future task.
-- Return
-- timestamp
-- source_tag
-- total_voltage
-- Only where
-- source_tag contains Solar
-- AND
-- total_voltage > 50

SELECT
    timestamp,
    source_tag,
    total_voltage
from sensor_readings
WHERE 
    source_tag LIKE '%Solar%'
    AND
    total_voltage > 50


-- Exercise 11
-- Create a new column called voltage_status.
-- Rules:
-- If total_voltage >= 50 → 'OK'
-- Otherwise → 'LOW'

SELECT
    CASE 
        WHEN total_voltage >= 50 THEN 'OK' 
        ELSE 'LOW'  
    END as voltage_status
FROM sensor_readings


-- Exercise 12
-- Create a new column called current_type.
-- Rules:
-- If battery_total_current < 0 → 'Discharging'
-- Otherwise → 'Charging'

SELECT
    CASE 
        WHEN battery_total_current < 0 THEN 'Discharging'  
        ELSE 'Charging'   
    END as current_type
FROM sensor_readings


-- Exercise 13
-- Create a new column called source_category.
-- Rules:
-- If source_tag contains 'Solar' → 'Solar Enabled'
-- Otherwise → 'No Solar'

SELECT
    CASE 
        WHEN source_tag ILIKE '%solar%' THEN 'Solar Enabled' 
        ELSE 'No Solar'  
    END as source_category
from sensor_readings


-- Exercise 14 (closer to your task)
-- Create a new column called active_source.
-- Rules:
-- If source_tag contains DG → 'DG'
-- If source_tag contains Battery → 'Battery'
-- If source_tag contains Solar → 'Solar'
-- Otherwise → 'Other'

SELECT
    CASE 
        WHEN source_tag ILIKE '%dg%' THEN 'DG'
        WHEN source_tag ILIKE '%battery%' THEN 'Battery'
        WHEN source_tag ILIKE '%solar%' THEN 'Solar'
        ELSE 'Other'
    END as active_source
FROM sensor_readings


-- Exercise 15
-- Return the total number of DG readings.
-- Output:
-- dg_readings

SELECT
    SUM(CASE 
        WHEN source_tag ILIKE '%dg%' THEN 1  
        ELSE 0 
    END) as dg_readings
FROM sensor_readings


-- Exercise 16
-- Return:
-- dg_readings
-- battery_readings
-- solar_readings
-- in one query.
-- Hint:
-- You need three separate conditional aggregations.

SELECT
    SUM(CASE 
        WHEN source_tag ILIKE '%dg%' THEN 1 
        ELSE 0 
    END) as dg_readings,
    
    SUM(
        CASE 
            WHEN source_tag ILIKE '%solar%' THEN 1 
            ELSE 0  
        END
    ) as solar_readings,
    
    SUM(
        CASE 
            WHEN source_tag ILIKE '%battery%' THEN 1 
            ELSE 0  
        END
    ) as battery_readings

FROM sensor_readings


-- Exercise 17
-- For each site_code, return:
-- site_code
-- negative_battery_readings
-- where:
-- battery_total_current < 0

SELECT
site_code,
    SUM(
        CASE 
        WHEN battery_total_current < 0 THEN 1  
        ELSE 0  
    END) as negative_battery_readings
FROM sensor_readings
GROUP BY 1


-- Exercise 18 (closer to your task)
-- For each site_code, calculate:
-- dg_run_hours
-- Formula:
-- (number of DG readings × 3) / 60

SELECT
site_code,
    Round( SUM(CASE 
        WHEN source_tag ILIKE '%dg%' THEN 1 
        ELSE 0  
    END) * (3.0/60.0), 2) as dg_run_hours
from sensor_readings
GROUP BY site_code


# How to Group according to time
SELECT
    date_trunc('hour', timestamp) as hourly_window,
    source_tag,
    COUNT(*)
FROM sensor_readings
GROUP BY source_tag, hourly_window
ORDER BY hourly_window


# lets calculate run hours
SELECT
    date_trunc('hour', timestamp) as hourly_window,
    source_tag,
    Round(SUM(
        CASE 
            WHEN source_tag ILIKE '%dg%' THEN 1 
            ELSE 0  
        END
    ) * (3.0 / 60.0), 2) as dg_run_hours,

    Round(SUM(
        CASE 
            WHEN source_tag ILIKE '%solar%' THEN 1 
            ELSE 0  
        END
    ) * (3.0 / 60.0), 2) as solar_run_hours,

    Round(SUM(
        CASE 
            WHEN source_tag ILIKE '%battery%' THEN 1 
            ELSE 0  
        END
    ) * (3.0 / 60.0), 2) as battery_run_hours

FROM sensor_readings
GROUP BY source_tag, hourly_window
ORDER BY hourly_window
