FROM python:3.12-slim-bookworm

# تثبيت متطلبات النظام
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3-dev libldap2-dev libsasl2-dev \
    libssl-dev libxml2-dev libxslt1-dev zlib1g-dev \
    libjpeg-dev libpq-dev libffi-dev curl \
    && rm -rf /var/lib/apt/lists/*

# إنشاء المستخدم
RUN useradd -m -d /opt/odoo -s /bin/bash odoo

WORKDIR /app

# نسخ ملف المتطلبات وتثبيته كـ root (أسرع)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- التعديل الجوهري هنا ---
# نسخ الملفات وتغيير الملكية في نفس اللحظة
COPY --chown=odoo:odoo . .

# الانتقال للمستخدم العادي
USER odoo

CMD ["python3","odoo-bin","--workers=2","--limit-memory-soft=268435456","--limit-memory-hard=3221225472","--limit-time-cpu=60","--limit-time-real=120","--proxy-mode","--gevent-port=8072","--max-cron-threads=2"]
