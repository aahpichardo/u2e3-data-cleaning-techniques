-- Tablas de dimensiones
CREATE TABLE Dim_Time (
    time_key INT PRIMARY KEY,
    year_month DATE,
    month INT,
    year INT,
    quarter INT
);

CREATE TABLE Dim_Country (
    country_key INT PRIMARY KEY,
    country_name VARCHAR(100),
    region VARCHAR(50)
);

CREATE TABLE Dim_Visa (
    visa_key INT PRIMARY KEY,
    visa_type VARCHAR(50),
    visa_category VARCHAR(50)
);

CREATE TABLE Dim_Passenger (
    passenger_key INT PRIMARY KEY,
    passenger_type VARCHAR(50),
    direction VARCHAR(20),
    citizenship VARCHAR(20)
);

-- Tabla de hechos
CREATE TABLE Fact_Migration (
    migration_key INT PRIMARY KEY,
    time_key INT,
    country_key INT,
    visa_key INT,
    passenger_key INT,
    estimate INT,
    standard_error INT,
    month_of_release VARCHAR(10),
    status VARCHAR(20),
    FOREIGN KEY (time_key) REFERENCES Dim_Time(time_key),
    FOREIGN KEY (country_key) REFERENCES Dim_Country(country_key),
    FOREIGN KEY (visa_key) REFERENCES Dim_Visa(visa_key),
    FOREIGN KEY (passenger_key) REFERENCES Dim_Passenger(passenger_key)
);

-- Índices para mejorar el rendimiento de consultas
CREATE INDEX idx_fact_migration_time ON Fact_Migration(time_key);
CREATE INDEX idx_fact_migration_country ON Fact_Migration(country_key);
CREATE INDEX idx_fact_migration_visa ON Fact_Migration(visa_key);