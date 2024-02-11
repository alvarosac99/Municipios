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
INSERT INTO
  MUNICIPIOS (provincia, nombre, TIF)
VALUES
  ('Madrid', 'Madrid', 28001),
  ('Barcelona', 'Barcelona', 08001),
  ('Valencia', 'Valencia', 46001),
  ('Sevilla', 'Sevilla', 41001),
  ('Alicante', 'Alicante', 03001),
  ('Bilbao', 'Bilbao', 48001),
  ('Málaga', 'Málaga', 29001),
  ('Murcia', 'Murcia', 30001),
  ('Zaragoza', 'Zaragoza', 50001),
  ('Palma de Mallorca', 'Palma de Mallorca', 07001);

INSERT INTO
  VIVIENDAS (direccion, codigoPostal, m2, propietario)
VALUES
  ('Calle Mayor 1', '28001', 100, '12345678A'),
  (
    'Avenida Diagonal 100',
    '08001',
    120,
    '87654321B'
  ),
  ('Calle Valencia 20', '46001', 80, '23456789C'),
  ('Calle Triana 5', '41001', 150, '34567890D'),
  ('Calle Postiguet 15', '03001', 90, '45678901E'),
  ('Gran Vía 25', '48001', 110, '56789012F'),
  ('Paseo del Parque 10', '29001', 130, '67890123G'),
  ('Calle Mayor 2', '30001', 95, '78901234H'),
  ('Avenida Goya 30', '50001', 140, '89012345I'),
  ('Calle Sindicato 3', '07001', 75, '90123456J');

-- Datos para la tabla PERSONAS
INSERT INTO
  PERSONAS (cabeza, DNI, nombre, TLF, vivir)
VALUES
  (
    TRUE,
    '12345678A',
    'Juan Perez',
    123456789,
    1
  ),
  (
    FALSE,
    '87654321B',
    'Ana García',
    987654321,
    2
  ),
  (
    TRUE,
    '23456789C',
    'Pedro Martínez',
    654987321,
    3
  ),
  (
    TRUE,
    '34567890D',
    'María López',
    789654123,
    4
  ),
  (
    FALSE,
    '45678901E',
    'Luis Rodríguez',
    321654987,
    5
  ),
  (
    TRUE,
    '56789012F',
    'Carlos Sánchez',
    654123987,
    6
  ),
  (
    FALSE,
    '67890123G',
    'Laura Fernández',
    987321654,
    7
  ),
  (
    TRUE,
    '78901234H',
    'Sofía García',
    321789654,
    8
  ),
  (
    TRUE,
    '89012345I',
    'Javier Martín',
    987321789,
    9
  ),
  (
    FALSE,
    '90123456J',
    'Elena Pérez',
    654987123,
    10
  );