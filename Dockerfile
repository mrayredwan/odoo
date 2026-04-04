FROM python:3.12-slim-bookworm

# Install system dependencies + official patched wkhtmltopdf
RUN apt-get update && apt-get install -y --no-install-recommends build-essential python3-dev libldap2-dev libsasl2-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev libjpeg-dev libpq-dev libffi-dev curl fonts-dejavu libxrender1 libxext6 libfontconfig1 xfonts-75dpi xfonts-base && wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb && apt install -y ./wkhtmltox_0.12.6.1-3.bookworm_amd64.deb && rm -f wkhtmltox_0.12.6.1-3.bookworm_amd64.deb && rm -rf /var/lib/apt/lists/*

# Create Odoo user
RUN useradd -m -d /opt/odoo -s /bin/bash odoo

WORKDIR /app

# Copy requirements and install (faster as root)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files and set ownership
COPY --chown=odoo:odoo . .

# Switch to non-root user
USER odoo

CMD ["python3","odoo-bin","--workers=2","--limit-memory-soft=268435456","--limit-memory-hard=3221225472","--limit-time-cpu=60","--limit-time-real=120","--proxy-mode","--gevent-port=8072","--max-cron-threads=2"]
