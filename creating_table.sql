-- Active: 1783598456020@@127.0.0.1@5432@sensor_data
# I used "REAL" datatype because for sensor data usually in postgres we use "REAL" or DOUBLE PRECISION
# depends upon our needs
CREATE Table sensor_readings(
    reading_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    site_code VARCHAR(20),
    timestamp TIMESTAMPTZ,
    source_tag VARCHAR(20),
    solar_output_current REAL,
    total_load_current REAL,
    battery_total_current REAL,
    total_voltage REAL
);

