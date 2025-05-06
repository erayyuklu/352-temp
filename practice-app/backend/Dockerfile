FROM python:3.9-slim

WORKDIR /app

# Gerekli paketleri yükleyin
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# PostgreSQL istemci kütüphanelerini yükleyin
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Proje dosyalarını kopyalayın
COPY . .

# Uygulamayı başlatın
EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]