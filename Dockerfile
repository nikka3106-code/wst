FROM php:8.2-apache

# Fix MPM conflict - use prefork (required for mod_php)
RUN a2dismod mpm_event mpm_worker 2>/dev/null; a2enmod mpm_prefork

# Copy all files to Apache root
COPY . /var/www/html/

# Enable Apache rewrite
RUN a2enmod rewrite

# Set permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

# At container start, inject the real $PORT value into Apache config, then launch
CMD bash -c "sed -i \"s/Listen 80/Listen \$PORT/g\" /etc/apache2/ports.conf && \
    sed -i \"s/<VirtualHost \\*:80>/<VirtualHost *:\$PORT>/g\" /etc/apache2/sites-available/000-default.conf && \
    apache2-foreground"
