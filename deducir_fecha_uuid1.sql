CREATE OR REPLACE FUNCTION deducir_fecha_uuid1(uuid_str VARCHAR2) RETURN DATE IS
    time_low          NUMBER;
    time_mid          NUMBER;
    time_hi_and_version NUMBER;
    timestamp_raw     NUMBER;
    timestamp         DATE;
BEGIN
    -- Extraer las partes del UUID
    time_low := TO_NUMBER(SUBSTR(uuid_str, 1, 8), 'XXXXXXXXXXXXXXXX');
    time_mid := TO_NUMBER(SUBSTR(uuid_str, 10, 4), 'XXXXXXXXXXXXXXXX');
    time_hi_and_version := TO_NUMBER(SUBSTR(uuid_str, 15, 4), 'XXXXXXXXXXXXXXXX');

    -- Verificar las partes extraídas
    DBMS_OUTPUT.PUT_LINE('Time Low: ' || time_low);
    DBMS_OUTPUT.PUT_LINE('Time Mid: ' || time_mid);
    DBMS_OUTPUT.PUT_LINE('Time Hi and Version: ' || time_hi_and_version);

    -- Cálculo del timestamp_raw (60 bits)
    timestamp_raw := (MOD(time_hi_and_version, 4096) * POWER(2, 48)) + 
                     (time_mid * POWER(2, 32)) + time_low;

    -- Verificar timestamp_raw para depuración
    DBMS_OUTPUT.PUT_LINE('Timestamp raw (60 bits): ' || timestamp_raw);

    -- Convertir timestamp_raw a días desde la fecha base '1582-10-15'
    -- 864000000000 es el número de intervalos de 100 ns en un día
    timestamp := TO_DATE('1582-10-15', 'YYYY-MM-DD') + (timestamp_raw / 864000000000);

    -- Verificar la fecha generada
    DBMS_OUTPUT.PUT_LINE('Fecha calculada: ' || timestamp);

    RETURN timestamp;
END;
