-- Creación de la base de datos
DROP DATABASE IF EXISTS migration_data;
CREATE DATABASE migration_data;
USE migration_data;

-- Tabla de dimensión de tiempo
CREATE TABLE Dim_Time (
    time_key INT AUTO_INCREMENT PRIMARY KEY,
    yearr_month DATE NOT NULL UNIQUE,
    month INT NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    CONSTRAINT chk_quarter CHECK (quarter BETWEEN 1 AND 4)
) ENGINE=InnoDB;

-- Tabla de dimensión de país
CREATE TABLE Dim_Country (
    country_key INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    CONSTRAINT unq_country UNIQUE (country_name, region)
) ENGINE=InnoDB;

-- Tabla de dimensión de visa
CREATE TABLE Dim_Visa (
    visa_key INT AUTO_INCREMENT PRIMARY KEY,
    visa_type VARCHAR(50) NOT NULL,
    visa_category VARCHAR(50) NOT NULL,
    CONSTRAINT unq_visa_type UNIQUE (visa_type, visa_category)
) ENGINE=InnoDB;

-- Tabla de dimensión de pasajero
CREATE TABLE Dim_Passenger (
    passenger_key INT AUTO_INCREMENT PRIMARY KEY,
    passenger_type VARCHAR(50) NOT NULL,
    direction VARCHAR(20) NOT NULL,
    citizenship VARCHAR(20) NOT NULL,
    CONSTRAINT unq_passenger UNIQUE (passenger_type, direction, citizenship)
) ENGINE=InnoDB;

-- Tabla de hechos de migración
CREATE TABLE Fact_Migration (
    migration_key INT AUTO_INCREMENT PRIMARY KEY,
    time_key INT NOT NULL,
    country_key INT NOT NULL,
    visa_key INT NOT NULL,
    passenger_key INT NOT NULL,
    estimate INT NOT NULL,
    standard_error INT,
    month_of_release VARCHAR(10),
    status VARCHAR(20),
    FOREIGN KEY (time_key) REFERENCES Dim_Time(time_key) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (country_key) REFERENCES Dim_Country(country_key) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (visa_key) REFERENCES Dim_Visa(visa_key) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (passenger_key) REFERENCES Dim_Passenger(passenger_key) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_estimate CHECK (estimate >= 0),
    CONSTRAINT chk_standard_error CHECK (standard_error >= 0 OR standard_error IS NULL)
) ENGINE=InnoDB;

-- Índices para mejorar el rendimiento de consultas
CREATE INDEX idx_fact_migration_time ON Fact_Migration(time_key);
CREATE INDEX idx_fact_migration_country ON Fact_Migration(country_key);
CREATE INDEX idx_fact_migration_visa ON Fact_Migration(visa_key);
CREATE INDEX idx_fact_migration_passenger ON Fact_Migration(passenger_key);