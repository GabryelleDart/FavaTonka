FROM python:3.12-slim

# Bibliotecas usadas pelos três serviços (perfumes, comentarios e favoritos)
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# O código de cada serviço é montado nesta pasta pelo docker-compose.yml
RUN mkdir /servico
WORKDIR /servico
