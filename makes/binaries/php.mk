# Defines php binaries

include $(SELF_DIR)binaries/docker.mk

PHP_DOCKER_COMPOSER_SERVICE ?= php

ifeq ($(DOCKER_ENABLED),1)
    PHP_BIN := $(docker-compose) run --rm $(PHP_DOCKER_COMPOSER_SERVICE) php -d memory_limit=-1
    COMPOSER_BIN ?= /usr/local/bin/composer
else
    PHP_BIN ?= PATH=$(PHP_PATH):$$PATH php
    COMPOSER_BIN ?= $(shell which composer)
endif

php := $(PHP_BIN)
composer := $(php) $(COMPOSER_BIN)
    