import pandas as pd

# Cargar los datos
df = pd.read_csv('international-migration-March-2021-citizenship-by-visa-by-country-of-last-permanent-residence.csv')

# 1. Verificar valores nulos
print("Valores nulos por columna:")
print(df.isnull().sum())

# 2. Estandarizar nombres de países
df['country_of_residence'] = df['country_of_residence'].str.replace(r'\(.*\)', '', regex=True).str.strip()

# 3. Verificar duplicados
duplicates = df.duplicated(subset=['year_month', 'country_of_residence', 'visa', 'citizenship'], keep=False)
print(f"\nRegistros duplicados conceptualmente: {duplicates.sum()}")

# 4. Verificar consistencia de categorías
print("\nValores unicos en columnas de categorias:")
print("passenger_type:", df['passenger_type'].unique())
print("direction:", df['direction'].unique())
print("citizenship:", df['citizenship'].unique())
print("visa:", df['visa'].unique())
print("status:", df['status'].unique())

# 5. Convertir year_month a tipo datetime
df['year_month'] = pd.to_datetime(df['year_month'])

# Mostrar información del dataframe limpio
print("\nInformacion del dataframe despues de limpieza:")
print(df.info())
