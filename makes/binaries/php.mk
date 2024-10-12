include $(SELF_DIR)binaries/docker.mk

PHP_DOCKER_COMPOSER_SERVICE ?= php

ifeq ($(DOCKER_ENABLED),1)
  PHP_BIN := $(docker-compose) run --rm $(PHP_DOCKER_COMPOSER_SERVICE) php -d memory_limit=-1
  COMPOSER_BIN := $(shell $(docker-compose) run --rm $(PHP_DOCKER_COMPOSER_SERVICE) which composer)
else
  PHP_BIN := $(shell which php) -d memory_limit=-1
  COMPOSER_BIN := $(shell which composer)
endif

php := $(PHP_BIN)
composer := $(php) $(COMPOSER_BIN)
