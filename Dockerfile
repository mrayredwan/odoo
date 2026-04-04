FROM mrayredwan/odoo-base

WORKDIR /app

# Copy project files
COPY --chown=odoo:odoo . .

# 🔥 IMPORTANT: install dependencies
RUN pip install --no-cache-dir -r requirements.txt

USER odoo

CMD ["python3","odoo-bin","--workers=2","--limit-memory-soft=268435456","--limit-memory-hard=3221225472","--limit-time-cpu=60","--limit-time-real=120","--proxy-mode","--gevent-port=8072","--max-cron-threads=2"]
