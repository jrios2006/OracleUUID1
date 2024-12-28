import uuid
from datetime import datetime, timedelta

def generar_uuid1():
    # Generar un UUID versión 1, que ya contiene la información de la fecha y hora
    generated_uuid = uuid.uuid1()
    
    # Mostrar el UUID generado
    print(f"UUID generado: {generated_uuid}")
    
    # Extraer los componentes del UUID
    time_low = generated_uuid.time & 0xFFFFFFFF  # 32 bits (time_low)
    time_mid = (generated_uuid.time >> 32) & 0xFFFF  # 16 bits (time_mid)
    time_hi_and_version = (generated_uuid.time >> 48) & 0x0FFF  # 12 bits (time_hi) + version
    
    # Cálculo del timestamp_raw (60 bits)
    timestamp_raw = (time_hi_and_version * (2**48)) + (time_mid * (2**32)) + time_low
    
    # La fecha base es el 15 de octubre de 1582
    base_date = datetime(1582, 10, 15)
    
    # Convertir el timestamp a segundos (100 ns = 1e-7 segundos)
    seconds_since_base = timestamp_raw * 1e-7
    generated_time = base_date + timedelta(seconds=seconds_since_base)
    
    # Mostrar la fecha calculada
    print(f"Fecha calculada para el UUID generado: {generated_time}")
    return generated_uuid, generated_time

def deducir_fecha_uuid1(uuid_str):
    # Asegúrate de que el UUID esté en el formato correcto
    my_uuid = uuid.UUID(uuid_str)
    
    # Extraer los componentes del UUID
    time_low = my_uuid.time & 0xFFFFFFFF  # 32 bits (time_low)
    time_mid = (my_uuid.time >> 32) & 0xFFFF  # 16 bits (time_mid)
    time_hi_and_version = (my_uuid.time >> 48) & 0x0FFF  # 12 bits (time_hi) + version
    
    # Concatenar las partes para obtener el timestamp (60 bits)
    timestamp_raw = (time_hi_and_version * (2**48)) + (time_mid * (2**32)) + time_low
    
    # La fecha base es el 15 de octubre de 1582
    base_date = datetime(1582, 10, 15)
    
    # Convertir el timestamp a segundos (100 ns = 1e-7 segundos)
    seconds_since_base = timestamp_raw * 1e-7
    generated_time = base_date + timedelta(seconds=seconds_since_base)
    
    # Devolver la fecha generada
    return generated_time

# Paso 1: Generar un nuevo UUID1 y calcular su fecha
generated_uuid, generated_time = generar_uuid1()

# Paso 2: Calcular la fecha de un UUID preexistente
uuid_str = '771A3A00-C514-11EF-7907-BDE13633A369'  # Reemplaza con el UUID que deseas verificar
calculated_time = deducir_fecha_uuid1(uuid_str)

# Mostrar el resultado para el UUID preexistente
print(f"Fecha calculada para el UUID preexistente {uuid_str}: {calculated_time}")
