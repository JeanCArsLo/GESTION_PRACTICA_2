# ─────────────────────────────────────────────
# Etapa base: imagen oficial de Python slim
# ─────────────────────────────────────────────
FROM python:3.11-slim

# Evita que Python genere archivos .pyc y habilita logs sin buffer
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# ─────────────────────────────────────────────
# Dependencias del sistema (necesarias para psycopg2)
# ─────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────
# Dependencias Python
# ─────────────────────────────────────────────
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# ─────────────────────────────────────────────
# Código fuente del proyecto
# ─────────────────────────────────────────────
COPY . .

# ─────────────────────────────────────────────
# Colectar archivos estáticos
# ─────────────────────────────────────────────
RUN python manage.py collectstatic --noinput

# Puerto expuesto por Gunicorn
EXPOSE 8000

# ─────────────────────────────────────────────
# Script de entrada: migra y luego levanta el servidor
# ─────────────────────────────────────────────
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
