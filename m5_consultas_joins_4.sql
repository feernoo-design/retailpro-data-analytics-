-- ============================================================
-- RetailPro
-- Proyecto Integrador · Módulo 5
-- Cruzando tablas para enriquecer el análisis
-- ------------------------------------------------------------
-- Base de datos : Ventas_Tech_DB
-- Motor         : SQL Server (T-SQL) · SSMS
-- Preparado por : Fernando
-- ============================================================

USE Ventas_Tech_DB;
GO


-- ============================================================
-- CONSULTA 1 · Vista base del proyecto (INNER JOIN)
-- ------------------------------------------------------------
-- Cruza ventas, clientes, productos y categorias en una sola
-- fila. Es la vista enriquecida que va a alimentar el dashboard
-- de Power BI en el Módulo 7.
--   · Columna para agrupar : nombre_categoria
--   · Columna para filtrar : ciudad
-- ============================================================
SELECT
    v.fecha_venta,
    v.id_cliente,
    c.nombre                       AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria           AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes   c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  p   ON v.id_producto  = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;
GO


-- ============================================================
-- CONSULTA 2 · Clientes sin ventas (LEFT JOIN)
-- ------------------------------------------------------------
-- Clientes registrados que todavía no realizaron ninguna compra.
-- ============================================================
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;
GO


-- ============================================================
-- CONSULTA 3 · Productos sin ventas (LEFT JOIN)
-- ------------------------------------------------------------
-- Productos del catálogo que no tienen ninguna venta registrada.
-- La categoría se trae con INNER JOIN a categorias (todo producto
-- tiene id_categoria obligatorio); el LEFT JOIN que importa para
-- el filtro es el de ventas.
-- ============================================================
SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN  ventas v        ON p.id_producto  = v.id_producto
WHERE v.id_producto IS NULL;
GO


-- ============================================================
-- CONSULTA 4 · Consolidado por origen (UNION ALL)
-- ------------------------------------------------------------
-- La columna "origen" no se consulta: se genera como valor
-- literal en cada SELECT. Como el esquema no tiene tabla
-- territorios, se usa la ciudad del cliente como dimensión
-- geográfica: "Buenos Aires" vs. "Resto del país".
-- UNION ALL conserva todas las ventas (no descarta coincidencias)
-- y el GROUP BY final totaliza por origen.
-- ============================================================
SELECT
    origen,
    SUM(cantidad * precio_unitario) AS total_vendido,
    COUNT(*)                        AS cantidad_ventas
FROM (
    SELECT v.fecha_venta, v.cantidad, v.precio_unitario,
           'Buenos Aires' AS origen
    FROM ventas v
    INNER JOIN clientes c ON v.id_cliente = c.id_cliente
    WHERE c.ciudad = 'Buenos Aires'

    UNION ALL

    SELECT v.fecha_venta, v.cantidad, v.precio_unitario,
           'Resto del país' AS origen
    FROM ventas v
    INNER JOIN clientes c ON v.id_cliente = c.id_cliente
    WHERE c.ciudad <> 'Buenos Aires'
) AS consolidado
GROUP BY origen;
GO
