include $(SELF_DIR)binaries/php.mk

PHP_CS_FIXER_CONFIGURATION_FILE ?= $(SELF_DIR)../lint/php-cs-fixer/.php-cs-fixer.php

PHP_FIXER_VERSION ?= 3-php8.3

ifeq ($(docker), )
	phpcsfixer := vendor/bin/php-cs-fixer
else
	phpcsfixer := $(docker) run --rm -it -v `pwd`:/code ghcr.io/php-cs-fixer/php-cs-fixer:${PHP_FIXER_VERSION}
endif

fixcs:
	@$(phpcsfixer) fix --config=$(PHP_CS_FIXER_CONFIGURATION_FILE)
.PHONY: fixcs

phpcs:
	@$(phpcsfixer) fix --config=$(PHP_CS_FIXER_CONFIGURATION_FILE) --dry-run
.PHONY: phpcs

phpstan:
	@$(php) vendor/bin/phpstan analyse $(PHPSTAN_CODE_PATH) --configuration=$(PHPSTAN_CONFIGURATION_FILE)
.PHONY: phpstan
