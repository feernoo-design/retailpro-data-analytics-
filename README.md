# RetailPro · Data Analytics

Proyecto integrador de la carrera de Análisis de Datos de CoderHouse. Simula el análisis de ventas de un distribuidor de tecnología ficticio (RetailPro / TechStore), desde el diseño de la base de datos hasta el modelo en Power BI.

> **Aviso:** todos los datos son ficticios y de prueba (10 ventas de 5 clientes). Los resultados no representan un negocio real.

## Descripción

El repositorio reúne los entregables de los distintos módulos del proyecto:

- Creación de la base de datos Ventas_Tech_DB con datos de prueba.
- Consultas SQL de negocio para el equipo comercial.
- Consultas con JOIN y UNION ALL para enriquecer el análisis.
- Un modelo en Power BI con relaciones, tabla calendario y medidas DAX.

## Contenido del repositorio

| Archivo / carpeta | Descripción |
|---|---|
| `ventas_tech_db_2.sql` | Crea la base de datos Ventas_Tech_DB con sus tablas y datos de prueba |
| `m4_consultas_negocio_5.sql` | Consultas de negocio: resumen mensual, top de productos, clientes recurrentes y meses vs. promedio |
| `m5_consultas_joins_4.sql` | Consultas con JOIN y UNION ALL: vista base, clientes sin ventas, productos sin ventas y consolidado por origen |
| `Pipeline_ETL_NOMS_FERNANDO_M8.pbix` | Modelo en Power BI con relaciones, tabla calendario y medidas DAX |
| `modulo7/` | Archivos del Módulo 7 |

## Herramientas utilizadas

- SQL Server (T-SQL)
- SQL Server Management Studio (SSMS)
- Power BI Desktop
- GitHub para el control de versiones

## Cómo ejecutar los scripts SQL

1. Abrí SQL Server Management Studio (SSMS) y conectate a tu servidor.
2. Ejecutá primero `ventas_tech_db_2.sql` para crear la base de datos Ventas_Tech_DB y cargar los datos de prueba.
3. Verificá que la carga salió bien con esta consulta, que debe devolver 10 filas:
```sql
   SELECT COUNT(*) FROM ventas;
```
4. Ejecutá `m4_consultas_negocio_5.sql`.
5. Ejecutá `m5_consultas_joins_4.sql`.

El orden importa: los scripts de los pasos 4 y 5 consultan las tablas creadas en el paso 2. Ambos ya incluyen `USE Ventas_Tech_DB`, así que no hace falta seleccionar la base a mano.

## Estado del proyecto

El repositorio contiene hasta ahora los entregables de los módulos 3, 4, 5, 7 y 8.

## Autor

Fernando NOMS · Carrera de Análisis de Datos, CoderHouse
