/* ======================================================================
   PROYECTO      : RetailPro — TechStore
   MÓDULO        : 4 — Extrayendo métricas clave con SQL
   ARCHIVO       : m4_consultas_negocio.sql
   BASE DE DATOS : Ventas_Tech_DB
   MOTOR         : SQL Server (T-SQL)
   AUTOR         : Fernando
   ------------------------------------------------------------------
   OBJETIVO
   El equipo comercial necesita, antes de la reunión del lunes,
   métricas concretas (no las filas crudas) sobre la facturación,
   los productos top y los clientes recurrentes. Este script responde
   esas preguntas de negocio directamente desde la base de datos.

   TABLA UTILIZADA: ventas
     - id_cliente
     - id_producto
     - cantidad
     - precio_unitario
     - fecha_venta
   ====================================================================== */

USE Ventas_Tech_DB;
GO


/* ======================================================================
   CONSULTA 1 — Resumen ejecutivo mensual
   ------------------------------------------------------------------
   ¿Cuánto facturamos, cuántos pedidos hicimos y cuál fue el ticket
   promedio, mes a mes?
   ====================================================================== */
SELECT
    MONTH(fecha_venta)                 AS mes,
    SUM(cantidad * precio_unitario)    AS total_facturado,
    COUNT(*)                           AS cantidad_pedidos,
    AVG(cantidad * precio_unitario)    AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO


/* ======================================================================
   CONSULTA 2 — Ranking de productos (Top 5)
   ------------------------------------------------------------------
   ¿Qué 5 productos generaron más facturación, y cuántas unidades
   vendieron?
   ====================================================================== */
SELECT TOP 5
    id_producto,
    SUM(cantidad)                      AS unidades_vendidas,
    SUM(cantidad * precio_unitario)    AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;
GO


/* ======================================================================
   CONSULTA 3 — Clientes recurrentes
   ------------------------------------------------------------------
   ¿Qué clientes compraron más de una vez, y cuánto gastaron en total?
   ====================================================================== */
SELECT
    id_cliente,
    COUNT(*)                           AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)    AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
GO


/* ======================================================================
   CONSULTA 4 — Meses por encima / por debajo del promedio
   ------------------------------------------------------------------
   Para cada mes, ¿su facturación quedó por encima o por debajo del
   promedio mensual general?
   ====================================================================== */
SELECT
    mensual.mes,
    mensual.total_facturado,
    CASE
        WHEN mensual.total_facturado > (
            SELECT AVG(sub.total_mensual)
            FROM (
                SELECT SUM(cantidad * precio_unitario) AS total_mensual
                FROM ventas
                GROUP BY MONTH(fecha_venta)
            ) AS sub
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM (
    SELECT
        MONTH(fecha_venta)              AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
) AS mensual
ORDER BY mensual.mes;
GO


/* ======================================================================
   HALLAZGOS
   ------------------------------------------------------------------
   Insights obtenidos al ejecutar las 4 consultas contra los datos de
   prueba cargados en Ventas_Tech_DB.
   ====================================================================== */

-- 1. [Consulta 2] El producto 1 (Laptop Pro 15) concentra $3.600,00 de
--    facturación, el 56% del total generado por el Top 5 de productos,
--    casi el triple que el segundo puesto ($1.350,00).

-- 2. [Consultas 1 y 4] Con los datos de prueba cargados, todas las ventas
--    caen en un único mes (marzo), con un total de $6.444,00 en 10
--    pedidos y un ticket promedio de $644,40. Al haber un solo mes, la
--    comparación contra el promedio general no distingue meses "por
--    encima" — este análisis va a tomar valor real recién con datos
--    de varios meses.

-- 3. [Consulta 3] Los 5 clientes de la base hicieron exactamente 2
--    pedidos cada uno, es decir, el 100% son clientes recurrentes en
--    este dataset. El cliente 1 concentra el mayor gasto ($2.640,00),
--    coincidiendo con la compra del producto más caro del catálogo.
