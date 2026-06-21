#!/bin/sh
set -e

echo "⏳ Aplicando migraciones..."
python manage.py migrate --noinput

echo "🚀 Iniciando servidor Gunicorn..."
exec gunicorn conceptu.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 2 \
    --timeout 120
