# استخدام نسخة بايثون المتوافقة
FROM python:3.12-slim-bookworm

# تثبيت متطلبات النظام الضرورية لأودو
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpq-dev \
    libffi-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# إعداد مجلد العمل
WORKDIR /app

# نسخ ملف المتطلبات وتثبيته
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# نسخ كود أودو بالكامل إلى الحاوية
COPY . .

# فتح المنفذ الخاص بأودو
EXPOSE 8069

# أمر التشغيل
CMD ["python3", "odoo-bin"]
