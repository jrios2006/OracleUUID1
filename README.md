# Oracle UUID 1
Generar UUID1 en Oracle 19c

Oracle no proporciona una función para generar UUID de tipo 1 de manera nativa.

Este proyecto devuelve dos funciones escritas en Oracle para generar  un uuid de tipo 1.

Como Oracle no propociona acceso a las direcciones MAC de las tarjetas de red, usmos un número pseudoaleatorio para componer el dato.

## Funciones SQL

Se definen 2 funciones

* generate_uuid1
* deducir_fecha_uuid1

Su uso será de esta manera:

```sql
SELECT generate_uuid1 AS UUID1 FROM dual;
```
|UUID1|
|-----|
|535BF180-C51E-11EF-1471-16271ADF2DC8|

```sql
SELECT deducir_fecha_uuid1('771A3A00-C514-11EF-7907-BDE13633A369') AS FECHA FROM dual;
```
|FECHA|
|-----|
|2024-12-28 12:08:36.000|

```sql
SELECT 
    generate_uuid1() AS uuid_generado,
    deducir_fecha_uuid1(generate_uuid1()) AS fecha_generada
FROM dual;
```
|UUID_GENERADO|FECHA_GENERADA|
|-------------|--------------|
|E2B4D500-C51D-11EF-6222-A6112D2DFBDB|2024-12-28 13:16:02.000|


```sql
SELECT deducir_fecha_uuid1('novale') FROM dual;
```
Devolverá un error como el siguiente:
```
QL Error [6502] [65000]: ORA-06502: PL/SQL: error  numérico o de valor
ORA-06512: en "DEDUCIR_FECHA_UUID1", línea 9


Error position: line: 77 pos: 7
```

El código tiene mensajes por consola para su traza.

Dejo un ejemplo escrito en python para verificar su uso desde otros sistemas ajemos a Oracle.


