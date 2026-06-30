FROM php:8.2-apache

# Fix MPM conflict - use prefork (required for mod_php)
RUN a2dismod mpm_event mpm_worker 2>/dev/null; a2enmod mpm_prefork

# Copy all files to Apache root
COPY . /var/www/html/

# Enable Apache rewrite
RUN a2enmod rewrite

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Apache will listen on whatever $PORT Railway provides at runtime
RUN echo 'Listen ${PORT}' > /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/g' /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["sh", "-c", "apache2-foreground"]
