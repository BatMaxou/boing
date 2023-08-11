# Configurable packages
ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-fpm-alpine

#Add composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk update && apk upgrade

# Configurable php configuration
ENV MEMORY_LIMIT "256M"

COPY ./php.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv

CMD ["php-fpm", "-R", "-F"]
