include $(SELF_DIR)lint/php.mk

PHPSTAN_CODE_PATH ?= src
PHPSTAN_CONFIGURATION_FILE ?= $(SELF_DIR)../lint/phpstan/symfony.neon
