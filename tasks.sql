-- Active: 1784660427354@@127.0.0.1@5432@sensor_data

-- Tasks
SELECT
    site_code,
    date_trunc('hour', timestamp) as hourly_window,
    source_tag,
    COUNT(CASE
        WHEN source_tag ILIKE '%dg%'
        THEN 1
        END
    )
FROM sensor_readings
GROUP BY 1,2,3


SELECT
    *
FROM sensor_readings