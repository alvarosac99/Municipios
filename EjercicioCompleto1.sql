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
        empadronada INT,
        CHECK (DNI REGEXP '[0-9]+[A-Z]'),
        FOREIGN KEY (vivir) REFERENCES VIVIENDAS (codigo),
        FOREIGN KEY (empadronada) REFERENCES MUNICIPIOS (codigo)
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
    PERSONAS (cabeza, DNI, nombre, TLF, vivir, empadronada)
VALUES
    (TRUE, '12345678A', 'Juan Pérez', 666777888, 1, 1),
    (FALSE, '23456789B', 'María López', 666888999, 2, 2),
    (TRUE, '34567890C', 'Carlos Martínez', 666999000, 3, 3),
    (FALSE, '45678901D', 'Ana García', 666000111, 4, 4),
    (TRUE, '56789012E', 'Laura Rodríguez', 666111222, 5, 5),
    (FALSE, '67890123F', 'Pedro Sánchez', 666222333, 6, 6),
    (TRUE, '78901234G', 'Sara Ramírez', 666333444, 7, 7),
    (FALSE, '89012345H', 'Pablo Ruiz', 666444555, 8, 8),
    (TRUE, '90123456I', 'Carmen Gómez', 666555666, 9, 9),
    (FALSE, '01234567J', 'Javier Martín', 666666777, 10, 10);

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
-- 0. Nombre y teléfono de los habitantes de Luarca.
SELECT
    nombre,
    TLF
FROM
    PERSONAS
WHERE
    empadronada = (
        SELECT
            codigo
        FROM
            MUNICIPIOS
        WHERE
            nombre = 'Luarca'
    );

-- 1. Nombre y teléfono de los habitantes del municipio de Valdés.
SELECT
    nombre,
    TLF
FROM
    PERSONAS
WHERE
    empadronada = (
        SELECT
            codigo
        FROM
            MUNICIPIOS
        WHERE
            nombre = 'Valdés'
    );

-- 2. Dirección y metros cuadrados de las viviendas del municipio de Navia.
SELECT
    V.direccion,
    V.m2
FROM
    VIVIENDAS V
    JOIN MUNICIPIOS M ON V.codigo = M.codigo
WHERE
    M.nombre = 'Navia';

-- 3. Nombre y teléfono de aquellas personas que poseen una vivienda en Navia.
SELECT
    P.nombre,
    P.TLF
FROM
    PERSONAS P
    JOIN VIVIENDAS V ON P.vivir = V.codigo
    JOIN MUNICIPIOS M ON V.codigo = M.codigo
WHERE
    M.nombre = 'Navia';

-- 4. De todas las viviendas del municipio de Avilés, su dirección, localidad y nombre del propietario.
SELECT
    V.direccion,
    M.nombre AS localidad,
    P.nombre AS propietario,
    P.TLF
FROM
    VIVIENDAS V
    JOIN MUNICIPIOS M ON V.codigo = M.codigo
    JOIN PERSONAS P ON V.propietario = P.DNI
WHERE
    M.nombre = 'Avilés';

-- 5. Nombre, dirección y teléfono de todos los cabeza de familia empadronados en el municipio de Tineo.
SELECT
    P.nombre,
    V.direccion,
    P.TLF
FROM
    PERSONAS P
    JOIN VIVIENDAS V ON P.vivir = V.codigo
WHERE
    P.cabeza = TRUE
    AND P.empadronada = (
        SELECT
            codigo
        FROM
            MUNICIPIOS
        WHERE
            nombre = 'Tineo'
    );

-- 6. Dirección completa de todas las viviendas del municipio de Oviedo y nombre y teléfono de su propietario para todas aquellas que superan los 150 m2.
SELECT
    V.direccion,
    P.nombre AS propietario,
    P.TLF
FROM
    VIVIENDAS V
    JOIN PERSONAS P ON V.propietario = P.DNI
    JOIN MUNICIPIOS M ON V.codigo = M.codigo
WHERE
    M.nombre = 'Oviedo'
    AND V.m2 > 150;

-- 7. Nombre de todos los municipios de Asturias en los que la superficie media de sus viviendas supera los 70 m2.
SELECT
    M.nombre
FROM
    MUNICIPIOS M
    JOIN VIVIENDAS V ON M.codigo = V.codigo
GROUP BY
    M.nombre
HAVING
    AVG(V.m2) > 70;

-- 8. Nombre de cada municipio de Asturias y cantidad de viviendas en cada uno de ellos que supera los 300 m2
SELECT
    M.nombre,
    COUNT(*) AS cantidad_viviendas
FROM
    VIVIENDAS V
    JOIN MUNICIPIOS M ON M.codigo = V.codigo
WHERE
    V.m2 > 300
GROUP BY
    M.nombre;

-- 9. Número total de cabezas de familia empadronados en el municipio de Proaza.
SELECT
    COUNT(*) AS total_cabezas_familia
FROM
    PERSONAS
WHERE
    cabeza = TRUE
    AND empadronada = (
        SELECT
            codigo
        FROM
            MUNICIPIOS
        WHERE
            nombre = 'Proaza'
    );

-- 10. Número total de municipios en cada provincia junto con el nombre de la misma.
SELECT
    provincia,
    COUNT(*) AS total_municipios
FROM
    MUNICIPIOS
GROUP BY
    provincia;

-- 11. Cantidad total de personas a cargo de cada cabeza de familia de las localidades de Asturias cuyo nombre empieza o termina por la letra ‘s’.
SELECT
    P.nombre,
    COUNT(*) AS total_personas_cargo
FROM
    PERSONAS P
    JOIN VIVIENDAS V ON P.vivir = V.codigo
    JOIN MUNICIPIOS M ON V.codigo = M.codigo
WHERE
    (
        M.nombre LIKE 's%'
        OR M.nombre LIKE '%s'
    )
    AND P.cabeza = TRUE
GROUP BY
    P.nombre;

-- 12. Media de personas a cargo de un cabeza de familia en cada municipio de la provincia de Asturias.
--:c
-- 13. Tamaño medio en metros cuadrados de las viviendas de cada municipio de la provincia de Asturias.
SELECT
    M.nombre,
    AVG(V.m2) AS media_metros_cuadrados
FROM
    MUNICIPIOS M
    JOIN VIVIENDAS V ON M.codigo = V.codigo
GROUP BY
    M.nombre;

-- 14. Nombre, dirección y teléfono del cabeza de familia responsable de la persona con el D.N.I.  11.421.124.
SELECT
    P.nombre,
    V.direccion,
    P.TLF
FROM
    PERSONAS P
    JOIN VIVIENDAS V ON P.vivir = V.codigo
WHERE
    P.DNI = '11421124F';

--lo cambio solo para que tenga sentido
-- 15. Nombre y número de viviendas que posee cada cabeza de familia empadronado en un municipio de Asturias.
SELECT
    P.nombre,
    COUNT(*) AS numero_viviendas
FROM
    PERSONAS P
    JOIN VIVIENDAS V ON P.vivir = V.codigo
    JOIN MUNICIPIOS M ON P.empadronada = M.codigo
WHERE
    P.cabeza = TRUE
GROUP BY
    P.nombre;

-- 16. Nombre, dirección y teléfono de aquellos cabezas de familia que no poseen una vivienda en el municipio en el que están empadronados.
SELECT
    P.nombre,
    V.direccion,
    P.TLF
FROM
    PERSONAS P
    JOIN MUNICIPIOS M ON P.empadronada = M.codigo
    LEFT JOIN VIVIENDAS V ON P.vivir = V.codigo
WHERE
    P.cabeza = TRUE
    AND V.codigo IS NULL;

-- 17. Nombre, dirección y teléfono de las personas que están empadronadas o poseen una vivienda en el municipio de Colunga y cuyo nombre empieza por la letra ‘A’. La consulta incluirá una última columna en la que se mostrará el valor “empadronado” si la fila incluye datos de una persona empadronada o el valor “propietario” si la fila incluye datos de una persona que posee una vivienda en el municipio.
SELECT
    P.nombre,
    V.direccion,
    P.TLF,
    CASE
        WHEN P.vivir IS NOT NULL THEN 'propietario'
        ELSE 'empadronado'
    END AS tipo
FROM
    PERSONAS P
    LEFT JOIN VIVIENDAS V ON P.vivir = V.codigo
    JOIN MUNICIPIOS M ON P.empadronada = M.codigo
WHERE
    M.nombre = 'Colunga'
    AND P.nombre LIKE 'A%';

-- 18. Dirección completa de la vivienda, junto con el nombre y teléfono de su propietario, de aquellas viviendas de Asturias cuya superficie sea mayor que la de todas las viviendas de Boal.
SELECT
    V.direccion,
    P.nombre AS propietario,
    P.TLF
FROM
    VIVIENDAS V
    JOIN PERSONAS P ON V.propietario = P.DNI
WHERE
    V.m2 > (
        SELECT
            MAX(m2)
        FROM
            VIVIENDAS
        WHERE
            empadronada = (
                SELECT
                    codigo
                FROM
                    MUNICIPIOS
                WHERE
                    nombre = 'Boal'
            )
    );

--19. Nombre, dirección y teléfono de las personas cuyo nombre empieza por la letra ‘B’, que están empadronadas en Morcín y poseen viviendas en dicho municipio.
SELECT
    P.nombre,
    V.direccion,
    P.TLF
FROM
    PERSONAS P
    JOIN VIVIENDAS V ON P.vivir = V.codigo
    JOIN MUNICIPIOS M ON P.empadronada = M.codigo
WHERE
    P.nombre LIKE 'B%'
    AND M.nombre = 'Morcín';