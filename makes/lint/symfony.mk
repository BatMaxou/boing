include $(SELF_DIR)lint/php.mk

PHP_CS_FIXER_CONFIGURATION_FILE ?= $(SELF_DIR)../lint/php-cs-fixer/.php-cs-fixer.php

fixcs: ## Lint - PHPCs - Fixes coding standards
	@$(phpcsfixer) fix --config=$(PHP_CS_FIXER_CONFIGURATION_FILE)
