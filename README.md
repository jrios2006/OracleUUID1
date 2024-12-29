# Oracle UUID 1
Generar UUID1 en Oracle 19c

Oracle no proporciona una función para generar UUID de tipo 1 de manera nativa.

Este proyecto devuelve dos funciones escritas en Oracle para generar  un uuid de tipo 1.

Como Oracle no propociona acceso a las direcciones MAC de las tarjetas de red, usamos un número pseudoaleatorio para componer el dato.

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

Dejo un ejemplo escrito en python para verificar su uso desde otros sistemas ajemos a Oracle. Un ejemplo de salida de este programa es:

```
python validar_UUID.py 
UUID generado: e3e5c6de-c50c-11ef-8619-94de80d761c4
Fecha calculada para el UUID generado: 2024-12-28 11:14:22.554083
Fecha calculada para el UUID preexistente 771A3A00-C514-11EF-7907-BDE13633A369: 2024-12-28 12:08:36
```

Se puede revisar la RFC 
<a href="https://datatracker.ietf.org/doc/html/rfc4122#section-4.2.1" target="_blank">Haz clic aquí para para encontrar documentación acerca de los UUID de tipo 1</a>

 

Se pue de usar este enlace para pruebas https://www.uniqueids.org/es/v1-uuid

## SYS_GUID()

Oracle propociona esta función que devuelve un UUID, pero no es de tipo 1

```sql
SELECT SYS_GUID() FROM DUAL;
```
Esto nos devuelve un UUID almacenado en hex (16 bits) ideal para almacenarlos en la base de datos. 

|SYS_GUID()|
|----------|
|���h�#N����\u0010��%\u0018|

Si usamos nuestra función de deducir la fecha observamos como no es de tipo 1

```sql
SELECT deducir_fecha_uuid1(SUBSTR(RAWTOHEX('§Ú´XÙ4H³¿C JÍyØö'), 1, 8) || '-' ||
       SUBSTR(RAWTOHEX('§Ú´XÙ4H³¿C JÍyØö'), 9, 4) || '-' ||
       SUBSTR(RAWTOHEX('§Ú´XÙ4H³¿C JÍyØö'), 13, 4) || '-' ||
       SUBSTR(RAWTOHEX('§Ú´XÙ4H³¿C JÍyØö'), 17, 4) || '-' ||
       SUBSTR(RAWTOHEX('§Ú´XÙ4H³¿C JÍyØö'), 21, 12)) AS FECHA FROM dual;
```
|FECHA|
|-----|
|3569-12-08 04:42:11.000|

Una versión superioro podría considerar el tamaño del dato y buscar optimizar. De momento parece razonable para un mejor compresión usar el formato ASCII y usar  bytes de almacenamiento.

```sql
SELECT SUBSTR(RAWTOHEX('§Ú´XÙ4H³¿C JÍyØö'), 1, 8) || '-' ||
       SUBSTR(RAWTOHEX('§Ú´XÙ4H³¿C JÍyØö'), 9, 4) || '-' ||
       SUBSTR(RAWTOHEX('§Ú´XÙ4H³¿C JÍyØö'), 13, 4) || '-' ||
       SUBSTR(RAWTOHEX('§Ú´XÙ4H³¿C JÍyØö'), 17, 4) || '-' ||
       SUBSTR(RAWTOHEX('§Ú´XÙ4H³¿C JÍyØö'), 21, 12) AS UUID FROM DUAL;
```

En crudo §Ú´XÙ4H³¿C JÍyØö y en claro

|UUID|
|----|
|A7DAB458-D934-48B3-BF43-204ACD79D8F6|

Prefiero este último formato para mejorar la compresión y las búsquedas y sentencias SQL en la aplicación.
