Base de Datos: Consultas SQL y Modificación de Datos (Farmacia)
Proyecto completo de gestión de bases de datos relacionales sobre un sistema de farmacia. El repositorio incluye dos scripts que abarcan desde consultas avanzadas de lectura (DQL) hasta la manipulación de datos (DML), transacciones y control de concurrencia.

Tecnologías y Herramientas
Motor de Base de Datos: MySQL
Herramienta de gestión: MySQL Workbench
Lenguajes: SQL (DQL, DML, TCL)

Funcionalidades y Conceptos Aplicados
El proyecto se divide en dos scripts principales:

1. Consultas SQL Avanzadas (Zafra_Vallejo_Ana_BD_Tarea4.sql)
Consultas de lectura (DQL): Filtros, ordenaciones (ORDER BY), agrupaciones (GROUP BY) y filtros de grupo (HAVING).
Joins: Uso de INNER JOIN y LEFT JOIN para combinar múltiples tablas.
Funciones: Uso de agregados (SUM, AVG, MAX, COUNT) y funciones de fecha (DATE_FORMAT, YEAR, MONTHNAME, CURDATE).
Subconsultas: Subconsultas escalares y tablas derivadas para comparar resultados con medias globales.

2. Modificación de Datos y Transacciones (Zafra_Vallejo_Ana_BD_Tarea5.sql)
Manipulación de Datos (DML): Inserción (INSERT), actualización (UPDATE) y eliminación (DELETE) de registros basados en condiciones y subconsultas.
Creación de tablas desde consultas: Uso de CREATE TABLE ... AS e INSERT INTO ... SELECT para generar tablas de resumen (TOP_VENTAS).
Transacciones y Control de Concurrencia (TCL):
Uso de START TRANSACTION y ROLLBACK para garantizar la integridad de los datos (deshacer cambios si es necesario).
Bloqueo de tablas en modo lectura (LOCK TABLES ... READ) para evitar conflictos de escritura simultánea.

Cómo ejecutar los scripts
Abre MySQL Workbench y conéctate a tu servidor local.
Ejecuta el script script_Tarea5_2526.sql (que contiene la creación de la base de datos FARMACIA y la inserción de datos iniciales).
Ejecuta el archivo Zafra_Vallejo_Ana_BD_Tarea4.sql para ver los resultados de las consultas de lectura.
Ejecuta el archivo Zafra_Vallejo_Ana_BD_Tarea5.sql para probar las modificaciones, transacciones y bloqueos.
