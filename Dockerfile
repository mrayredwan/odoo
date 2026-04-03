FROM python:3.12-slim-bookworm

# تثبيت المكتبات (نفس الخطوات السابقة)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3-dev libldap2-dev libsasl2-dev \
    libssl-dev libxml2-dev libxslt1-dev zlib1g-dev \
    libjpeg-dev libpq-dev libffi-dev curl \
    && rm -rf /var/lib/apt/lists/*

# --- الإضافة الجديدة للأمان ---
# إنشاء مستخدم باسم odoo ومنحه صلاحية المجلد
RUN useradd -m -d /opt/odoo -s /bin/bash odoo
WORKDIR /app
RUN chown -R odoo:odoo /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN chown -R odoo:odoo /app

# التبديل للمستخدم الجديد قبل التشغيل
USER odoo

EXPOSE 8069
CMD ["python3", "odoo-bin"]
