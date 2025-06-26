import pandas as pd
import numpy as np

# Cargar los datos originales
df = pd.read_csv('international-migration-March-2021-citizenship-by-visa-by-country-of-last-permanent-residence.csv')

# Mostrar cómo se veían originalmente los primeros registros
print("=== DATOS ORIGINALES ===")
print(df.head())
print("\nInformacion inicial:")
print(df.info())

# 1. Limpieza de nombres de países
def clean_country_name(country):
    # Eliminar notas entre par�ntesis
    country = country.split('(')[0].strip()
    # Estandarizar nombres especiales
    if "Czech" in country:
        return "Czech Republic"
    return country

df['country_of_residence'] = df['country_of_residence'].apply(clean_country_name)

# 2. Normalización de categorías
df['visa'] = df['visa'].str.replace('NZ and Australian citizens', 'Citizen', case=False)
df['passenger_type'] = df['passenger_type'].str.title()
df['direction'] = df['direction'].str.title()
df['citizenship'] = np.where(df['citizenship'] == 'NZ', 'New Zealand', 'Other')

# 3. Manejo de valores cero/missing
# Consideramos que estimate=0 es válido (puede haber meses sin migración)
# Pero verificamos si hay valores nulos
print("\nValores nulos antes de limpieza:")
print(df.isnull().sum())

# 4. Convertir fechas a formato datetime
df['year_month'] = pd.to_datetime(df['year_month'])
df['month_of_release'] = pd.to_datetime(df['month_of_release'], format='%Y-%m')

# 5. Eliminar columnas redundantes
# month_of_release podría ser redundante con year_month en algunos casos
# Pero la dejamos por ahora

# 6. Verificar y eliminar duplicados exactos
duplicados = df.duplicated()
print(f"\nNumero de duplicados exactos encontrados: {duplicados.sum()}")
df = df.drop_duplicates()

# 7. Crear columna de año para facilitar análisis
df['year'] = df['year_month'].dt.year

# Mostrar cómo quedaron los datos después de la limpieza
print("\n=== DATOS LIMPIOS ===")
print(df.head())
print("\nInformacion despues de limpieza:")
print(df.info())

# Guardar el archivo limpio
df.to_csv('migration_data_cleaned.csv', index=False)
print("\nArchivo limpio guardado como 'migration_data_cleaned.csv'")