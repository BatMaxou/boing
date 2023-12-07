ARG PHP_VERSION=8.3

FROM php:${PHP_VERSION}-fpm-alpine

WORKDIR /srv

ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk update && apk upgrade

RUN apk add --no-cache \
  nginx \
  envsubst \
  acl \
  bash \
  ca-certificates \
  git \
  openssh \
  rsync \
  patch \
  mysql-client \
  supervisor \
  make

# -------------------- Supervisor ----------------------
COPY .boing/docker/app/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# -------------------- PHP ----------------------
ENV MEMORY_LIMIT "256M"

RUN install-php-extensions intl curl dom fileinfo mbstring zip opcache exif apcu pdo_mysql

ARG GD_REQUIRE=0

RUN if [[ "${GD_REQUIRE}" -eq 1 ]] ; then install-php-extensions gd ; fi

COPY .boing/docker/php/php.ini $PHP_INI_DIR/conf.d/

# -------------------- Nginx ----------------------
ENV root "/srv/web"
ENV fastcgi_pass "app:9000"
ENV client_max_body_size "100M"

COPY .boing/docker/nginx/drupal/default.conf /etc/nginx/conf.d/default.template
COPY .boing/docker/nginx/nginx.conf /etc/nginx/nginx.conf

RUN envsubst "`env | awk -F = '{printf \" \\\\$%s\", $1}'`" < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf

WORKDIR "/srv"

COPY . /srv

ENV DOCKER_ENABLED 0

EXPOSE 80

RUN make vendor

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
