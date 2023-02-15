FROM php:8.1-apache

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    libaio1 libaio-dev libfreetype6-dev libicu-dev libjpeg62-turbo-dev libldap2-dev libonig-dev libpng-dev libzip-dev \
    build-essential gifsicle jpegoptim locales optipng pngquant \
    curl cron git imagemagick sudo telnet unzip vim wget zip \
    && a2enmod rewrite \
    && curl https://get.volta.sh | bash

# Install extensions
RUN    docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install exif gd intl mbstring opcache pcntl pdo_mysql zip \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && pecl install -o -f redis \
    && docker-php-ext-enable redis

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/pear

EXPOSE 80 443