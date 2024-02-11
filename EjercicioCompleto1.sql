--1. Crear las tablas
CREATE TABLE
    MUNICIPIOS (provincia varchar(100), nombre varchar(100), codigo INT AUTO_INCREMENT PRIMARY KEY, TIF INT);

CREATE TABLE
    VIVIENDAS (
        codigo INT AUTO_INCREMENT PRIMARY KEY,
        direccion varchar(255),
        codigoPostal varchar(5),
        m2 int NOT NULL
    );

CREATE TABLE
    PERSONAS (
        cabeza BOOLEAN NOT NULL,
        DNI VARCHAR(9) PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        TLF INT (9),
        vivir INT,
        CHECK (DNI REGEXP '[0-9]+[A-Z]'),
        FOREIGN KEY (vivir) REFERENCES VIVIENDAS (codigo)
    );

--2. Ahora añado una nueva columna a VIVIENDAS, propietario, que almacena el DNI de la persona a la que le pertenece cada vivienda. 
ALTER TABLE VIVIENDAS ADD propietario VARCHAR(9),
ADD FOREIGN KEY (propietario) REFERENCES PERSONAS (DNI);

--3.Inserts 
-- Municipios
INSERT INTO
    MUNICIPIOS (provincia, nombre, TIF)
VALUES
    ('Madrid', 'Alcorcón', 28022),
    ('Barcelona', 'Sabadell', 08206),
    ('Valencia', 'Torrent', 46900),
    ('Sevilla', 'Dos Hermanas', 41700),
    ('Alicante', 'Elche', 03202),
    ('Málaga', 'Marbella', 29600),
    ('Zaragoza', 'Zaragoza', 50001),
    ('Murcia', 'Murcia', 30001),
    ('Palma', 'Palma de Mallorca', 07001),
    ('Las Palmas', 'Las Palmas de Gran Canaria', 35001);

-- 1. Inserto viviendas sin propietario
INSERT INTO
    VIVIENDAS (direccion, codigoPostal, m2, propietario)
VALUES
    ('Calle Mayor 123', '28001', 100, NULL),
    ('Avenida Libertad 45', '08210', 120, NULL),
    ('Plaza España 8', '46950', 80, NULL),
    ('Calle Real 67', '41720', 150, NULL),
    ('Paseo Marítimo 22', '03201', 200, NULL),
    ('Calle Gran Vía 5', '29610', 90, NULL),
    ('Avenida del Pilar 33', '50010', 110, NULL),
    ('Calle Alameda 11', '30005', 95, NULL),
    ('Calle Soller 2', '07002', 75, NULL),
    ('Calle Triana 14', '35002', 85, NULL);

-- 2. Insertar personas asociadas a las viviendas
INSERT INTO
    PERSONAS (cabeza, DNI, nombre, TLF, vivir)
VALUES
    (TRUE, '12345678A', 'Juan Pérez', 666777888, 1),
    (FALSE, '23456789B', 'María López', 666888999, 2),
    (TRUE, '34567890C', 'Carlos Martínez', 666999000, 3),
    (FALSE, '45678901D', 'Ana García', 666000111, 4),
    (TRUE, '56789012E', 'Laura Rodríguez', 666111222, 5),
    (FALSE, '67890123F', 'Pedro Sánchez', 666222333, 6),
    (TRUE, '78901234G', 'Sara Ramírez', 666333444, 7),
    (FALSE, '89012345H', 'Pablo Ruiz', 666444555, 8),
    (TRUE, '90123456I', 'Carmen Gómez', 666555666, 9),
    (FALSE, '01234567J', 'Javier Martín', 666666777, 10);

-- 3. Actualizo las filas de VIVIENDAS, ahora con propietarios
UPDATE VIVIENDAS
SET
    propietario = (
        CASE codigo
            WHEN 1 THEN '12345678A'
            WHEN 2 THEN '23456789B'
            WHEN 3 THEN '34567890C'
            WHEN 4 THEN '45678901D'
            WHEN 5 THEN '56789012E'
            WHEN 6 THEN '67890123F'
            WHEN 7 THEN '78901234G'
            WHEN 8 THEN '89012345H'
            WHEN 9 THEN '90123456I'
            WHEN 10 THEN '01234567J'
        END
    )
WHERE
    codigo IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

--4. CONSULTAS
-- Nombre y teléfono de los habitantes de Luarca.
