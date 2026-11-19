/*******************************************************
 * SELECCIÓN DE LA BASE DE DATOS
 *******************************************************/
-- Seleccionamos la base de datos para trabajar
USE FARMACIA;

/**************
 * APARTADO A
 **************/

-- 1. Listar todos los empleados ordenados por fecha de alta más antigua a más reciente.
SELECT * FROM EMPLEADO 
ORDER BY fechaAlta ASC;

-- 2. Listar los nombres de los clientes que son mutualistas y además son de paso ordenados 
-- por nombre.
SELECT c.nombre 
FROM CLIENTE c 
JOIN DE_PASO d ON c.Codigo = d.Codigo 
WHERE c.mutualista = 'S' 
ORDER BY c.nombre ASC;

-- 3. Listar la fecha y el identificador de venta para las ventas realizadas en enero de 2025, 
-- ordenadas por fecha descendentemente y por id_venta ascendentemente.
SELECT fecha, id_venta 
FROM VENTA 
WHERE fecha >= '2025-01-01' AND fecha <= '2025-01-31'
ORDER BY fecha DESC, id_venta ASC;

-- 4. Mostrar para cada id_venta la suma de todas las unidades de medicamentos vendidas en cada 
-- venta ordenadas por la suma de unidades descendentemente.
SELECT id_venta, SUM(unidades) AS total_unidades 
FROM DETALLE 
GROUP BY id_venta 
ORDER BY total_unidades DESC;

/***************
 * APARTADO B
 ***************/

-- 5. Crear un listado con el nombre del empleado, el nombre del cliente, el id_venta y la fecha 
-- de la venta con formato DD/MM/AAAA ordenado por la fecha más reciente a la más antigua.
SELECT e.nombre AS Empleado, c.nombre AS Cliente, v.id_venta, DATE_FORMAT(v.fecha, '%d/%m/%Y') AS fecha_venta
FROM VENTA v 
JOIN EMPLEADO e ON v.cod_empleado = e.cod_empleado 
JOIN CLIENTE c ON v.Codigo_cliente = c.Codigo 
ORDER BY v.fecha DESC;

-- 6. Listar el nombre de aquellos medicamentos vendidos en enero de 2025, cuyo PVP supere 
-- el euro y sea de tipo Antibiótico. No se debe repetir el nombre del medicamento y deben 
-- estar ordenados alfabéticamente.
SELECT DISTINCT m.nombre 
FROM MEDICAMENTO m 
JOIN DETALLE d ON m.Codigo = d.Codigo_medicamento 
JOIN VENTA v ON d.id_venta = v.id_venta 
WHERE v.fecha BETWEEN '2025-01-01' AND '2025-01-31'
  AND m.pvp > 1.00 
  AND m.tipo = 'Antibiótico' 
ORDER BY m.nombre ASC;

-- 7. Comprobar si hay clientes que son de paso y habituales al mismo tiempo. Mostrar el nombre
--  de dichos clientes ascendentemetnte.
SELECT c.nombre 
FROM CLIENTE c 
JOIN DE_PASO dp ON c.Codigo = dp.Codigo 
JOIN HABITUAL h ON c.Codigo = h.Codigo 
ORDER BY c.nombre ASC;

-- 8. Obtener de cada medicamento (nombre, tipo y stock) los CIF y direcciones de los 
-- proveedores de quienes se los hemos comprado alguna vez.
SELECT DISTINCT m.nombre, m.tipo, m.stock, p.CIF, p.Direccion 
FROM MEDICAMENTO m 
JOIN COMPRAR cp ON m.Codigo = cp.Codigo_medicamento 
JOIN PROVEEDOR p ON cp.cod_proveedor = p.cod_proveedor;

-- 9. Mostrar para cada empleado el número de ventas que ha realizado, teniendo en cuenta que 
-- los empleados que no han realizado ninguna deberán aparecer también en el listado. Mostrar 
-- el nombre y salario base, así como el número de ventas realizadas, ordenado por número de 
-- ventas de menor a mayor.
SELECT e.nombre, e.salarioBase, COUNT(v.id_venta) AS num_ventas 
FROM EMPLEADO e 
LEFT JOIN VENTA v ON e.cod_empleado = v.cod_empleado 
GROUP BY e.cod_empleado, e.nombre, e.salarioBase 
ORDER BY num_ventas ASC;

-- 10. Listar el nombre de aquellos clientes (una única vez) que hayan comprado alguna vez el 
-- medicamento Ibuprofeno 400mg.
SELECT DISTINCT c.nombre 
FROM CLIENTE c 
JOIN VENTA v ON c.Codigo = v.Codigo_cliente 
JOIN DETALLE d ON v.id_venta = d.id_venta 
JOIN MEDICAMENTO m ON d.Codigo_medicamento = m.Codigo 
WHERE m.nombre = 'Ibuprofeno 400mg';

-- 11. Mostrar el nombre de aquellos empleados que no tengan gerente asignado.
SELECT nombre 
FROM EMPLEADO 
WHERE emp_gerente IS NULL;

-- 12. Obtener el nombre y antigüedad (en años) de aquellos empleados que lleven 20 años o más 
-- en la farmacia. Ordénalos de más antiguos a más recientes.
SELECT nombre, (YEAR(CURDATE()) - YEAR(fechaAlta)) AS antiguedad_anios 
FROM EMPLEADO 
WHERE (YEAR(CURDATE()) - YEAR(fechaAlta)) >= 20 
ORDER BY fechaAlta ASC;

-- 13.Mostrar el nombre y beneficio del medicamento del que obtenemos mayor beneficio en su 
-- venta. Si es más de uno, mostrarlos todos.
SELECT nombre, (pvp - precioCompra) AS beneficio 
FROM MEDICAMENTO 
WHERE (pvp - precioCompra) = (SELECT MAX(pvp - precioCompra) FROM MEDICAMENTO);

-- 14. Listar el importe total que se ha gastado en nuestra farmacia cada cliente, teniendo en
-- cuenta su código y nombre. Para este cálculo debes tener en cuenta las unidades de 
-- medicamento que se han llevado y lo que se le ha cobrado por ellos.
SELECT c.Codigo, c.nombre, SUM(d.unidades * m.pvp) AS importe_total 
FROM CLIENTE c 
JOIN VENTA v ON c.Codigo = v.Codigo_cliente 
JOIN DETALLE d ON v.id_venta = d.id_venta 
JOIN MEDICAMENTO m ON d.Codigo_medicamento = m.Codigo 
GROUP BY c.Codigo, c.nombre;

-- 15. Muestra para cada nombre de medicamento y mes (aaaa/mm), la media de unidades compradas
-- (cantidad) a los proveedores. Ordena el resultado por nombre ascendentemente y mes 
-- descendentemente.
SELECT m.nombre, 
       CONCAT(YEAR(cp.fecha), '/', MONTH(cp.fecha)) AS mes, 
       AVG(cp.cantidad) AS media_comprada 
FROM MEDICAMENTO m 
JOIN COMPRAR cp ON m.Codigo = cp.Codigo_medicamento 
GROUP BY m.nombre, mes
ORDER BY m.nombre ASC, mes DESC;

-- 16. Muestra por cada mes del año 2025, el nombre del mes y la cantidad de medicamente que 
-- se han vendido en cada mes siempre y cuando haya sido más de 30 unidades.
SELECT MONTHNAME(v.fecha) AS mes, SUM(d.unidades) AS total_unidades 
FROM VENTA v 
JOIN DETALLE d ON v.id_venta = d.id_venta 
WHERE YEAR(v.fecha) = 2025 
GROUP BY MONTH(v.fecha), mes 
HAVING total_unidades > 30;

/*****************
 * APARTADO C
 *****************/

-- 17. Mostrar el nombre de los clientes que hayan comprado el medicamento más caro (según PVP).
SELECT DISTINCT c.nombre 
FROM CLIENTE c 
JOIN VENTA v ON c.Codigo = v.Codigo_cliente 
JOIN DETALLE d ON v.id_venta = d.id_venta 
JOIN MEDICAMENTO m ON d.Codigo_medicamento = m.Codigo 
WHERE m.pvp = (SELECT MAX(pvp) FROM MEDICAMENTO);

-- 18. Mostrar para cada código de cliente y nombre, el importe total que se ha gastado en 
-- nuestra farmacia, siempre que dicho importe total supere el de la media gastada por cada 
-- uno de los clientes. (hay que tener en cuenta las unidades de cada medicamento que se han 
-- llevado y lo que hemos cobrado por ellos).
SELECT c.Codigo, c.nombre, SUM(d.unidades * m.pvp) AS importe_total 
FROM CLIENTE c 
JOIN VENTA v ON c.Codigo = v.Codigo_cliente 
JOIN DETALLE d ON v.id_venta = d.id_venta 
JOIN MEDICAMENTO m ON d.Codigo_medicamento = m.Codigo 
GROUP BY c.Codigo, c.nombre 
HAVING importe_total > (
    SELECT AVG(gasto_cliente) 
    FROM (
        SELECT SUM(d2.unidades * m2.pvp) AS gasto_cliente 
        FROM VENTA v2 
        JOIN DETALLE d2 ON v2.id_venta = d2.id_venta 
        JOIN MEDICAMENTO m2 ON d2.Codigo_medicamento = m2.Codigo 
        GROUP BY v2.Codigo_cliente
    ) AS tabla_medias
);