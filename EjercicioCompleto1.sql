--1. Crear las tablas
CREATE TABLE MUNICIPIOS(
    provincia varchar(100),
    nombre varchar(100),
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    TIF INT
);
CREATE TABLE VIVIENDA(
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    direccion varchar(255),
    codigoPostal varchar(5),
    m2 int NOT NULL
);
CREATE TABLE PERSONA (
    cabeza BOOLEAN NOT NULL,
    DNI VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    TLF INT(9),
    vivir INT,
    CHECK (DNI REGEXP '[0-9]+[A-Z]'),
    FOREIGN KEY (vivir) REFERENCES VIVIENDA(codigo)
);
ALTER TABLE VIVIENDA
ADD propietario VARCHAR(9),
    ADD FOREIGN KEY (propietario) REFERENCES PERSONA(DNI);