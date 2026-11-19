/********************************
 * SELECCIÓN DE LA BASE DE DATOS
 ********************************/
-- Seleccionamos la base de datos para trabajar
USE FARMACIA;

/**************
 * APARTADO B
 **************/

-- 1. Insertar los datos en la tabla MEDICAMENTO teniendo en cuenta que se debe 
-- insertar sólo los valores necesarios en los campos correspondientes.
INSERT INTO MEDICAMENTO (Codigo, nombre, tipo, posología, stock, precioCompra, pvp) VALUES
(316, 'Enantyum 25mg', 'Analgésico', 'Tomar 1 cada 8 horas', 80, 2.80, 4.00),
(317, 'Nolotil 575mg', 'Antipirético', 'Tomar 1 cada 6 horas', 50, 1.00, 1.60),
(318, 'Adiro 100 mg', 'Antiplaquetario', 'Tomar 1 al día', 100, 0.95, 1.45);

-- 2. Incrementar en un 5% el salario base de todos los empleados que realizaron 
-- alguna venta en agosto de 2025. (Una única sentencia).
UPDATE EMPLEADO
SET salarioBase = salarioBase * 1.05
WHERE cod_empleado IN (
    SELECT DISTINCT cod_empleado
    FROM VENTA
    WHERE MONTH(fecha) = 8 AND YEAR(fecha) = 2025
);

-- 3. Eliminar los proveedores a los que no le hayamos comprado nada. 
-- (Una única sentencia).
DELETE FROM PROVEEDOR
WHERE cod_proveedor NOT IN (
    SELECT DISTINCT cod_proveedor
    FROM COMPRAR
);

-- 4. Rebajar en 0.10 euros el precio de venta de los medicamentos que aparecen 
-- en más de 9 ventas.
UPDATE MEDICAMENTO
SET pvp = pvp - 0.10
WHERE Codigo IN (
    SELECT Codigo_medicamento
    FROM DETALLE
    GROUP BY Codigo_medicamento
    HAVING COUNT(id_venta) > 9
);

-- 5. Actualizar el campo unidades_vendidas con el total de las unidades vendidas 
-- de cada medicamento. (Una única sentencia)
UPDATE MEDICAMENTO M
LEFT JOIN (
    SELECT Codigo_medicamento, SUM(unidades) as total_vendidas
    FROM DETALLE
    GROUP BY Codigo_medicamento
) D ON M.Codigo = D.Codigo_medicamento
SET M.unidades_vendidas = IFNULL(D.total_vendidas, 0);

-- 6. Aumentar en 70 euros el salario base de los empleados que han realizado 
-- al menos 4 ventas. (Una única sentencia)
UPDATE EMPLEADO
SET salarioBase = salarioBase + 70
WHERE cod_empleado IN (
    SELECT cod_empleado
    FROM VENTA
    GROUP BY cod_empleado
    HAVING COUNT(id_venta) >= 4
);

-- 7. Insertar en la tabla TOP_VENTAS el id_venta y el importe total recaudado 
-- con la venta, de aquellas ventas cuyo importe total recaudado sea superior 
-- a 10 euros. (Una única sentencia). Nota: Antes de hacer la sentencia de inserción 
-- habría que crear la tabla TOP_VENTAs.
CREATE TABLE IF NOT EXISTS TOP_VENTAS (
    id_venta INTEGER PRIMARY KEY,
    importe_total DECIMAL(10,2)
);

INSERT INTO TOP_VENTAS (id_venta, importe_total)
SELECT D.id_venta, SUM(D.unidades * M.pvp) AS importe_total
FROM DETALLE D
JOIN MEDICAMENTO M ON D.Codigo_medicamento = M.Codigo
GROUP BY D.id_venta
HAVING importe_total > 10;

/*****************
 * APARTADO C
 *****************/

-- 8. Bloquear la tabla CLIENTE en modo lectura. A continuación, intenta actualizar
-- los datos del cliente "Carlos Gómez" indicando que ahora sí es mutualista. 
LOCK TABLES CLIENTE READ;

UPDATE CLIENTE 
SET mutualista = 'S' 
WHERE nombre = 'Carlos Gómez';

-- 9. Iniciar una transacción. Rebajar en un 50% el precio de compra de todos los medicamentos de los que hemos comprado más 
-- de 40 unidades (teniendo en cuenta todas las compras del medicamento). Deshacer la transacción y comprobar que los 
-- registros recuperan su valor anterior.
START TRANSACTION;

UPDATE MEDICAMENTO
SET precioCompra = precioCompra * 0.50
WHERE Codigo IN (
    SELECT Codigo_medicamento
    FROM COMPRAR
    GROUP BY Codigo_medicamento
    HAVING SUM(cantidad) > 40
);

SELECT * FROM MEDICAMENTO;

ROLLBACK;

SELECT * FROM MEDICAMENTO;