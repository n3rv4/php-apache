FROM php:8.2-apache

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    libaio1 libaio-dev libfreetype6-dev libicu-dev libjpeg62-turbo-dev libldap2-dev libonig-dev libpng-dev libzip-dev \
    build-essential gifsicle jpegoptim locales optipng pngquant \
    curl cron git imagemagick sudo telnet unzip vim wget zip supervisor \
    && a2enmod rewrite

RUN mkdir -p /var/log/supervisor

RUN wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz\
    && tar -zxvf Python-2.7.8.tgz\
    && cd Python-2.7.8\
    && ./configure \
    && make \
    && make install

RUN curl https://get.volta.sh | bash

COPY _php/timezone.ini /usr/local/etc/php/conf.d/timezone.ini
COPY _php/vars.ini /usr/local/etc/php/conf.d/vars.ini

# Install extensions
RUN    docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install exif gd ldap intl mbstring opcache pcntl pdo_mysql zip \
    && pecl install -o -f redis \
    && docker-php-ext-enable redis

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/pear

COPY openssl.cnf /etc/ssl/openssl.cnf

EXPOSE 80 443