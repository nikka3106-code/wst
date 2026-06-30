FROM php:8.2-apache

# Install mysqli extension
RUN docker-php-ext-install mysqli

# Copy all files to Apache root
COPY . /var/www/html/

# Enable Apache rewrite
RUN a2enmod rewrite

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Force Apache to always listen on port 8080
RUN sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/g' /etc/apache2/sites-available/000-default.conf

EXPOSE 8080

# Force-remove conflicting MPM symlinks, enable only prefork, then start
CMD bash -c "rm -f /etc/apache2/mods-enabled/mpm_event.* /etc/apache2/mods-enabled/mpm_worker.* && \
    a2enmod mpm_prefork && \
    apache2-foreground"
