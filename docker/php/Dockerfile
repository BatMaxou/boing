# Configurable packages
ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-fpm-alpine

#Add composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk update && apk upgrade

RUN install-php-extensions pdo_mysql

# ADDITIONAL MODULES

ARG GD_REQUIRE=0
ARG ENABLE_REDIS=0
ARG ENABLE_AMQP=0

RUN if [[ "${GD_REQUIRE}" -eq 1 ]] ; then install-php-extensions gd; fi
RUN if [[ "${ENABLE_AMQP}" -eq 1 ]] ; then install-php-extensions amqp ; fi
RUN if [[ "${ENABLE_REDIS}" -eq 1 ]] ; then install-php-extensions redis ; fi

# Configurable php configuration
ENV MEMORY_LIMIT "256M"

COPY ./php.ini $PHP_INI_DIR/conf.d/

WORKDIR /srv

CMD ["php-fpm", "-R", "-F"]
