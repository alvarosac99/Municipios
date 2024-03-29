CREATE TABLE
    Municipios (codigo INT PRIMARY KEY, nombre VARCHAR(50) NOT NULL, provincia VARCHAR(50));

CREATE TABLE
    Viviendas (
        codigo INT PRIMARY KEY,
        CP INT,
        direccion VARCHAR(200),
        m2 INT,
        municipio INT,
        FOREIGN KEY (municipio) REFERENCES Municipios (codigo)
    );

CREATE TABLE
    Personas (
        DNI VARCHAR(9) PRIMARY KEY,
        telefono INT,
        nombre VARCHAR(50),
        cabeza_familia VARCHAR(9),
        vivienda INT,
        FOREIGN KEY (cabeza_familia) REFERENCES Personas (DNI),
        FOREIGN KEY (vivienda) REFERENCES Viviendas (codigo)
    );

CREATE TABLE
    Poseer (
        id INT PRIMARY KEY AUTO_INCREMENT,
        vivienda INT,
        propietario VARCHAR(9),
        FOREIGN KEY (vivienda) REFERENCES Viviendas (codigo),
        FOREIGN KEY (propietario) REFERENCES Personas (DNI)
    );

INSERT INTO
    Municipios (codigo, nombre, provincia)
VALUES
    (1, 'Madrid', 'Madrid'),
    (2, 'Barcelona', 'Barcelona'),
    (3, 'Sevilla', 'Sevilla');

-- Insertar datos en la tabla Viviendas
INSERT INTO
    Viviendas (codigo, CP, direccion, m2, municipio)
VALUES
    (1, 28001, 'Calle Gran Vía, 1', 100, 1),
    (2, 08001, 'Avenida Diagonal, 100', 120, 2),
    (3, 41001, 'Plaza de España, 5', 80, 3);

-- Insertar datos en la tabla Personas
INSERT INTO
    Personas (DNI, telefono, nombre, cabeza_familia, vivienda)
VALUES
    ('12345678A', 666555444, 'Juan Pérez', '12345678A', 1),
    ('23456789B', 677666555, 'María García', '12345678A', 1),
    ('34567890C', 688777666, 'Antonio López', '34567890C', 2),
    ('45678901D', 699888777, 'Laura Martínez', '34567890C', 2),
    ('56789012E', 600999888, 'Carlos Rodríguez', '56789012E', 3),
    ('67890123F', 611000999, 'Sara Gómez', '56789012E', 3);

-- Insertar datos en la tabla Poseer
INSERT INTO
    Poseer (vivienda, propietario)
VALUES
    (1, '12345678A'),
    (1, '23456789B'),
    (2, '34567890C'),
    (2, '45678901D'),
    (3, '56789012E'),
    (3, '67890123F'),
SELECT
    nombre,
    telefono
FROM
    Personas
WHERE
    vivienda = (
        SELECT
            v.codigo
        FROM
            Viviendas v
            JOIN Municipios m ON v.municipio = m.codigo
        WHERE
            m.nombre = 'Luarca'
    );

SELECT
    viviendas.direccion,
    viviendas.m2
FROM
    viviendas
    JOIN municipios ON viviendas.municipio = municipios.codigo
WHERE
    municipios.nombre = "Navia";

-- 4. De todas las viviendas del municipio de Avilés, su dirección, localidad y nombre del propietario.
SELECT
    V.direccion,
    P.nombre AS propietario,
FROM
    Viviendas V
    JOIN Municipios M ON V.municipio = M.codigo
    JOIN Poseer ON V.codigo = Poseer.vivienda
    JOIN Personas P ON Poseer.propietario = P.DNI
WHERE
    M.nombre = 'Avilés';

-- 5. Nombre, dirección y teléfono de todos los cabeza de familia empadronados en el municipio de Tineo.
SELECT
    P.Nombre,
    P.Telefono
FROM
    Personas p
    JOIN viviendas v ON P.vivienda = V.codigo
WHERE
    P.DNI = P.cabeza_familia;

--6.
--7.Nombre de todos los municipios de Asturias en los que la superficie media de sus viviendas supera los 70 m2.
SELECT
    M.nombre
FROM
    MUNICIPIOS M
    JOIN VIVIENDAS V ON M.codigo = V.codigo
WHERE
    Municipios.provincia = 'Asturias'
GROUP BY
    M.nombre
HAVING
    AVG(V.m2) > 70;

--8. Nombre de cada municipio de Asturias y cantidad de viviendas en cada uno de ellos que supera los 300 m2
SELECT
    M.nombre,
    COUNT(Viviendas.codigo)
FROM
    MUNICIPIOS M
    JOIN VIVIENDAS V ON M.viviendas = V.municipio
WHERE
    Municipios.provincia = 'Asturias'
    AND Viviendas.m2 > 300
GROUP BY
    M.nombre;

-- 9. Número total de cabezas de familia empadronados en el municipio de Proaza.
SELECT
    COUNT(*) AS total_cabezas_familia
FROM
    PERSONAS
WHERE
    cabeza_familia = DNI
    AND vivienda = (
        SELECT
            codigo
        FROM
            MUNICIPIOS
        WHERE
            nombre = 'Proaza'
    );

-- 10. Número total de municipios en cada provincia junto con el nombre de la misma.
SELECT
    nombre,
    COUNT(*) AS total
FROM
    MUNICIPIOS
GROUP BY
    provincia;

-- 11. Cantidad total de personas a cargo de cada cabeza de familia de las localidades de Asturias cuyo nombre empieza o termina por la letra ‘s’.
SELECT
    P.nombre,
    COUNT(*)
FROM
    Personas P
    JOIN Viviendas V ON P.vivienda = V.codigo
    JOIN Municipios M ON V.municipio = M.codigo
WHERE
    (
        P.nombre LIKE 's%'
        OR P.nombre LIKE '%s'
    )
    AND P.cabeza_familia = 'P.DNI'
    AND M.provincia = 'Asturias'
GROUP BY
    P.cabeza_familia;