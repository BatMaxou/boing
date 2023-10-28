include $(SELF_DIR)lint/php.mk

PHPSTAN_CODE_PATH ?= src
PHPSTAN_CONFIGURATION_FILE ?= $(SELF_DIR)../lint/phpstan/symfony.neon
PHP_CS_FIXER_CONFIGURATION_FILE ?= $(SELF_DIR)../lint/php-cs-fixer/.php-cs-fixer.php

fixcs: ## Lint - PHPCs - Fixes coding standards
	@$(phpcsfixer) fix --config=$(PHP_CS_FIXER_CONFIGURATION_FILE)

phpcs: ## Lint - PHPCs - Check coding standards
	@$(phpcsfixer) fix --config=$(PHP_CS_FIXER_CONFIGURATION_FILE) --dry-run
