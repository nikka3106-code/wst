FROM php:8.2-apache

# Copy all files to Apache root
COPY . /var/www/html/

# Enable Apache rewrite
RUN a2enmod rewrite

# Set permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

# Force-remove conflicting MPM symlinks, enable only prefork,
# then bind Apache to Railway's runtime $PORT before starting
CMD bash -c "rm -f /etc/apache2/mods-enabled/mpm_event.* /etc/apache2/mods-enabled/mpm_worker.* && \
    a2enmod mpm_prefork && \
    sed -i \"s/Listen 80/Listen \$PORT/g\" /etc/apache2/ports.conf && \
    sed -i \"s/<VirtualHost \\*:80>/<VirtualHost *:\$PORT>/g\" /etc/apache2/sites-available/000-default.conf && \
    apache2-foreground"
