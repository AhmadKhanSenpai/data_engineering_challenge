-- Active: 1784660427354@@127.0.0.1@5432@sensor_data

WITH sources(source) as
(
    VALUES
    ('DG'),
    ('Solar'),
    ('Battery')
),

agg_table as(

    SELECT
    reading_id,
    site_code,
    timestamp,
    s.source,
    solar_output_current,
    total_load_current,
    battery_total_current,
    total_voltage
    FROM sensor_readings sr
    JOIN sources s
    ON sr.source_tag ILIKE '%' || s.source || '%'
)

SELECT
    site_code,
    DATE_TRUNC('hour', timestamp) AS hour_window,
    source,
    AVG(
        CASE 
            WHEN source ILIKE 'dg' THEN total_load_current * total_voltage / 1000
            WHEN source ILIKE 'solar' THEN solar_output_current * total_voltage / 1000
            WHEN source ILIKE 'battery' THEN battery_total_current * total_voltage / 1000
        END
    ) as kw,

    ROUND(COUNT(*) * (3.0 / 60.0), 2) as run_hour
FROM agg_table
GROUP BY
    site_code,
    DATE_TRUNC('hour', timestamp),
    source;
