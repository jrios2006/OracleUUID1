CREATE OR REPLACE FUNCTION generate_uuid1 RETURN VARCHAR2 IS
    time_low           NUMBER;
    time_mid           NUMBER;
    time_hi_and_version NUMBER;
    clock_seq          NUMBER;
    node               NUMBER;
    timestamp          NUMBER;
    
    -- Variables intermedias para cada parte en formato hexadecimal
    hex_time_low       VARCHAR2(8);
    hex_time_mid       VARCHAR2(4);
    hex_time_hi_version VARCHAR2(4);
    hex_clock_seq      VARCHAR2(4);  -- Se asegura de tener 4 caracteres
    hex_node           VARCHAR2(12);
    
    uuid_str           VARCHAR2(64);  -- Tamaño mayor para la cadena UUID
BEGIN
    -- Obtener el timestamp de la fecha actual (en intervalos de 100 ns desde el 1582-10-15)
    timestamp := (SYSDATE - TO_DATE('1582-10-15', 'YYYY-MM-DD')) * 86400 * 10000000;

    -- Verificar el valor del timestamp para depuración
    DBMS_OUTPUT.PUT_LINE('Timestamp raw: ' || timestamp);

    -- Calcular los 60 bits del timestamp y dividir en las partes correspondientes
    time_low := MOD(timestamp, POWER(2, 32));  -- 32 bits
    timestamp := FLOOR(timestamp / POWER(2, 32));  -- Desplazar 32 bits
    time_mid := MOD(timestamp, POWER(2, 16));  -- 16 bits
    timestamp := FLOOR(timestamp / POWER(2, 16));  -- Desplazar 16 bits

    -- Asignar la versión 1 en los 12 bits más significativos de time_hi_and_version
    time_hi_and_version := MOD(timestamp, POWER(2, 12)) + 4096;  -- 12 bits + versión 1 (0x1000)

    -- Verificar los valores de time_hi_and_version para depuración
    DBMS_OUTPUT.PUT_LINE('Time Hi and Version: ' || time_hi_and_version);

    -- Obtener el clock sequence (de 14 bits, entre 0 y 16383)
    clock_seq := MOD(FLOOR(DBMS_RANDOM.VALUE(0, 16383)), 16384);  -- Aseguramos que está en el rango de 14 bits (0-16383)

    -- Obtener el node (dirección MAC o similar, por simplicidad aquí se usa un valor aleatorio de 48 bits)
    node := MOD(FLOOR(DBMS_RANDOM.VALUE(0, POWER(2, 48))), POWER(2, 48));  -- Aseguramos que está en el rango de 48 bits

    -- Convertir cada parte a formato hexadecimal
    hex_time_low := TO_CHAR(time_low, 'FMXXXXXXXXXXXXXXXX');
    hex_time_mid := TO_CHAR(time_mid, 'FMXXXX');
    hex_time_hi_version := TO_CHAR(time_hi_and_version, 'FMXXXX');
    hex_clock_seq := TO_CHAR(clock_seq, 'FM0000');  -- Aseguramos que tenga 4 dígitos hexadecimales
    hex_node := TO_CHAR(node, 'FMXXXXXXXXXXXXXXXX');

    -- Imprimir las partes intermedias en el log para depuración
    DBMS_OUTPUT.PUT_LINE('Hex Time Low: ' || hex_time_low);
    DBMS_OUTPUT.PUT_LINE('Hex Time Mid: ' || hex_time_mid);
    DBMS_OUTPUT.PUT_LINE('Hex Time Hi and Version: ' || hex_time_hi_version);
    DBMS_OUTPUT.PUT_LINE('Hex Clock Seq: ' || hex_clock_seq);
    DBMS_OUTPUT.PUT_LINE('Hex Node: ' || hex_node);

    -- Concatenar las partes en el formato estándar de UUID
    uuid_str := hex_time_low || '-' || 
                hex_time_mid || '-' || 
                hex_time_hi_version || '-' || 
                hex_clock_seq || '-' || 
                hex_node;

    -- Aseguramos que la concatenación final esté correcta
    DBMS_OUTPUT.PUT_LINE('UUID: ' || uuid_str);

    RETURN uuid_str;
END;
