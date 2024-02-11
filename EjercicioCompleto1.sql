--1. Crear las tablas
CREATE TABLE MUNICIPIOS (
  provincia varchar(100),
  nombre varchar(100),
  codigo INT AUTO_INCREMENT PRIMARY KEY,
  TIF INT
);

CREATE TABLE VIVIENDAS (
  codigo INT AUTO_INCREMENT PRIMARY KEY,
  direccion varchar(255),
  codigoPostal varchar(5),
  m2 int NOT NULL
);

CREATE TABLE PERSONAS (
  cabeza BOOLEAN NOT NULL,
  DNI VARCHAR(9) PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  TLF INT(9),
  vivir INT,
  CHECK (DNI REGEXP '[0-9]+[A-Z]'),
  FOREIGN KEY (vivir) REFERENCES VIVIENDAS (codigo)
);

--2. Ahora añado una nueva columna a VIVIENDAS, propietario, que almacena el DNI de la persona a la que le pertenece cada vivienda. 
ALTER TABLE
  VIVIENDAS
ADD
  propietario VARCHAR(9) NOT NULL,
ADD
  FOREIGN KEY (propietario) REFERENCES PERSONAS (DNI);

--3.Inserts