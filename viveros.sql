-- Ejecución del script: sudo -u postgres psql -f viveros.sql
-- Acceder a la base de datos: psql -U gestor_viveros -d viveros -W
-- Eliminar la base de datos: sudo -u postgres psql -c "DROP DATABASE viveros;"

CREATE DATABASE viveros;

\c viveros

-- ENTIDADES FUERTES

CREATE TABLE vivero (
    id_vivero SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    latitud NUMERIC(9,6) NOT NULL,
    longitud NUMERIC(9,6) NOT NULL
);

CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(8,2) NOT NULL CHECK (precio >= 0),
    tipo VARCHAR(50) NOT NULL
);

CREATE TABLE puesto (
    id_puesto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE empleado (
    nif VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(15),
    direccion VARCHAR(200)
);

CREATE TABLE cliente (
    nif VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(200), 
    email VARCHAR(100), 
    fecha_plus DATE 
);

-- ENTIDADES DÉBILES Y 1:N

CREATE TABLE zona (
    id_vivero INTEGER,
    id_zona INTEGER, 
    nombre VARCHAR(100) NOT NULL,
    latitud NUMERIC(9,6) NOT NULL,
    longitud NUMERIC(9,6) NOT NULL,
    PRIMARY KEY (id_vivero, id_zona),
    FOREIGN KEY (id_vivero) REFERENCES vivero(id_vivero) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE bonificacion (
    id_cliente VARCHAR(9),
    mes VARCHAR(7), -- Formato 'MM/YYYY'
    volumen NUMERIC(10,2) NOT NULL CHECK (volumen >= 0),
    bonificacion NUMERIC(8,2) NOT NULL CHECK (bonificacion >= 0),
    PRIMARY KEY (id_cliente, mes),
    FOREIGN KEY (id_cliente) REFERENCES cliente(nif) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    id_cliente VARCHAR(9) NOT NULL,
    id_empleado VARCHAR(9) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(nif) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_empleado) REFERENCES empleado(nif) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RELACIONES N:M

CREATE TABLE producto_zona (
    id_producto INTEGER,
    id_vivero INTEGER,
    id_zona INTEGER,
    cantidad INTEGER NOT NULL DEFAULT 0 CHECK (cantidad >= 0),
    PRIMARY KEY (id_producto, id_vivero, id_zona),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_vivero, id_zona) REFERENCES zona(id_vivero, id_zona) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE empleado_vivero (
    nif_empleado VARCHAR(9),
    id_vivero INTEGER,
    fecha0 DATE NOT NULL,
    fecha1 DATE, 
    id_puesto INTEGER NOT NULL,
    PRIMARY KEY (nif_empleado, id_vivero, fecha0),
    FOREIGN KEY (nif_empleado) REFERENCES empleado(nif) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_vivero) REFERENCES vivero(id_vivero) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_puesto) REFERENCES puesto(id_puesto) ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (fecha1 IS NULL OR fecha1 >= fecha0) 
);

CREATE TABLE empleado_zona (
    nif_empleado VARCHAR(9),
    id_vivero INTEGER,
    id_zona INTEGER,
    fecha0 DATE NOT NULL,
    fecha1 DATE, 
    tarea VARCHAR(150) NOT NULL,
    PRIMARY KEY (nif_empleado, id_vivero, id_zona, fecha0),
    FOREIGN KEY (nif_empleado) REFERENCES empleado(nif) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_vivero, id_zona) REFERENCES zona(id_vivero, id_zona) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (fecha1 IS NULL OR fecha1 >= fecha0)
);

CREATE TABLE pedido_producto (
    id_pedido INTEGER,
    id_producto INTEGER,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_venta NUMERIC(8,2) NOT NULL CHECK (precio_venta >= 0),
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- INSERCIÓN DE DATOS 

INSERT INTO vivero (nombre, latitud, longitud) VALUES 
('Vivero Santa Cruz', 28.4636, -16.2518),
('Vivero La Laguna', 28.4871, -16.3146),
('Vivero Puerto Cruz', 28.4165, -16.5508),
('Vivero Arona', 28.1005, -16.6796),
('Vivero Adeje', 28.1189, -16.7323);

INSERT INTO zona (id_vivero, id_zona, nombre, latitud, longitud) VALUES 
(1, 1, 'Almacén Principal', 28.4636, -16.2518),
(1, 2, 'Zona Exterior', 28.4638, -16.2520),
(2, 1, 'Invernadero A', 28.4872, -16.3147),
(3, 1, 'Almacén Central', 28.4165, -16.5508),
(5, 1, 'Sección Jardinería', 28.1189, -16.7323);

INSERT INTO producto (nombre, precio, tipo) VALUES 
('Rosal rojo', 12.50, 'Planta'),
('Maceta cerámica 20cm', 8.90, 'Decoración'),
('Saco tierra 50L', 5.50, 'Jardinería'),
('Manguera 10m', 15.00, 'Herramienta'),
('Orquídea', 22.00, 'Planta');

INSERT INTO puesto (nombre) VALUES 
('Responsable de Tienda'),
('Especialista en Jardinería'),
('Atención al Cliente'),
('Mozo de Almacén'),
('Coordinador General');

INSERT INTO empleado (nif, nombre, telefono, direccion) VALUES 
('11111111A', 'Juan García López', '600111222', 'Calle Luna 1'),
('22222222B', 'Ana María Torres', '600333444', NULL),
('33333333C', 'Carlos Ruiz', NULL, 'Av Marítima 3'),
('44444444D', 'Laura Gómez', '600777888', 'Plaza España 4'),
('55555555E', 'Pedro Martín', '600999000', 'Calle Mayor 5');

INSERT INTO cliente (nif, nombre, direccion, email, fecha_plus) VALUES 
('99999999Z', 'María Rodríguez', 'Calle Pino 1', 'maria@email.com', '2026-04-15'),
('88888888Y', 'Antonio Fernández', 'Calle Roble 2', NULL, NULL),
('77777777X', 'Lucía Díaz', 'Calle Palmera 3', 'lucia@email.com', '2025-11-20'),
('66666666W', 'Javier Ramos', NULL, 'javier@email.com', NULL),
('55555555V', 'Carmen Santana', 'Calle Cactus 5', 'carmen@email.com', '2026-01-10');

INSERT INTO bonificacion (id_cliente, mes, volumen, bonificacion) VALUES 
('99999999Z', '10/2026', 125.50, 5.00),
('77777777X', '09/2026', 450.00, 25.00),
('77777777X', '10/2026', 210.00, 10.00),
('55555555V', '01/2026', 150.00, 7.50),
('99999999Z', '08/2026', 300.00, 15.00);

INSERT INTO pedido (fecha, id_cliente, id_empleado) VALUES 
('2026-10-07', '99999999Z', '11111111A'),
('2026-10-08', '88888888Y', '22222222B'),
('2026-10-09', '77777777X', '33333333C'),
('2026-10-10', '66666666W', '11111111A'),
('2026-10-11', '55555555V', '44444444D');

INSERT INTO pedido_producto (id_pedido, id_producto, cantidad, precio_venta) VALUES 
(1, 1, 2, 12.50),
(1, 2, 4, 10.10),
(2, 2, 1, 8.90),
(3, 3, 10, 5.50),
(4, 4, 1, 15.00),
(4, 5, 1, 22.00),
(5, 1, 1, 12.50);

INSERT INTO producto_zona (id_producto, id_vivero, id_zona, cantidad) VALUES 
(1, 1, 2, 150),
(1, 1, 1, 50),
(3, 1, 1, 200),
(2, 2, 1, 45),
(5, 5, 1, 30);

INSERT INTO empleado_vivero (nif_empleado, id_vivero, fecha0, fecha1, id_puesto) VALUES 
('11111111A', 1, '2026-01-01', '2026-06-30', 1),
('11111111A', 2, '2026-07-01', NULL, 5),
('22222222B', 1, '2026-01-01', NULL, 3),
('33333333C', 3, '2025-05-01', '2026-10-01', 4),
('44444444D', 5, '2026-08-01', NULL, 2);

INSERT INTO empleado_zona (nif_empleado, id_vivero, id_zona, fecha0, fecha1, tarea) VALUES 
('11111111A', 1, 2, '2026-01-01', '2026-03-31', 'Atención en jardines'),
('11111111A', 1, 1, '2026-04-01', '2026-06-30', 'Control de stock de almacén'),
('22222222B', 1, 2, '2026-01-01', NULL, 'Cajero de exteriores'),
('33333333C', 3, 1, '2025-05-01', '2026-10-01', 'Carga y descarga'),
('44444444D', 5, 1, '2026-08-01', NULL, 'Poda y regado');

-- PRUEBA DELETE

-- EJEMPLO 1: CASCADE
-- Al eliminar una zona, desaparecen sus asignaciones relacionadas.
-- ROLLBACK permite conservar los datos originales.

BEGIN;

DELETE FROM zona
WHERE id_vivero = 1 AND id_zona = 2;

SELECT * FROM producto_zona
WHERE id_vivero = 1 AND id_zona = 2;

SELECT * FROM empleado_zona
WHERE id_vivero = 1 AND id_zona = 2;

ROLLBACK;


-- EJEMPLO 2: RESTRICT
-- No se puede eliminar un cliente que tiene pedidos.
-- El error de clave foránea es esperado.

BEGIN;

SAVEPOINT antes_del_delete;

DELETE FROM cliente
WHERE nif = '99999999Z';

-- Si el DELETE falla, ejecutar:
ROLLBACK TO SAVEPOINT antes_del_delete;

ROLLBACK;

-- SELECT DE CADA TABLA

SELECT * FROM vivero;
SELECT * FROM zona;
SELECT * FROM producto;
SELECT * FROM puesto;
SELECT * FROM empleado;
SELECT * FROM cliente;
SELECT * FROM bonificacion;

-- TABLA PEDIDO
-- Atributo derivado

SELECT
    p.id_pedido,
    p.fecha,
    p.id_cliente,
    p.id_empleado,
    COALESCE(
        SUM(pp.cantidad * pp.precio_venta),
        0
    ) AS importe
FROM pedido p
LEFT JOIN pedido_producto pp
    ON p.id_pedido = pp.id_pedido
GROUP BY
    p.id_pedido,
    p.fecha,
    p.id_cliente,
    p.id_empleado
ORDER BY p.id_pedido;
