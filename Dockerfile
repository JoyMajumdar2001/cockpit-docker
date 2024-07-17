# Use the official PHP image as the base image
FROM php:8.2-apache

# Set environment variables
ENV COCKPIT_VERSION 2.8.6
ENV COCKPIT_URL https://github.com/Cockpit-HQ/Cockpit/archive/refs/tags/2.8.6.tar.gz

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip

# Enable Apache rewrite module
RUN a2enmod rewrite

# Download and extract Cockpit CMS
RUN curl -L $COCKPIT_URL -o cockpit.tar.gz \
    && tar -xzf cockpit.tar.gz \
    && mv cockpit-$COCKPIT_VERSION /var/www/html/cockpit \
    && rm cockpit.tar.gz

# Set permissions
RUN chown -R www-data:www-data /var/www/html/cockpit

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
