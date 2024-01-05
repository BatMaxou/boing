include $(SELF_DIR)binaries/php.mk

PHPQA_TAG ?= php8.2
PHP_CS_FIXER_CONFIGURATION_FILE ?= $(SELF_DIR)../lint/php-cs-fixer/.php-cs-fixer.php

qa := $(docker) run --rm -t -v `pwd`:/project --workdir="/project" jakzal/phpqa:$(PHPQA_TAG)
phpcsfixer := $(qa) php-cs-fixer

fixcs: ## Lint - PHPCs - Fixes coding standards
	@$(phpcsfixer) fix --config=$(PHP_CS_FIXER_CONFIGURATION_FILE)

phpcs: ## Lint - PHPCs - Check coding standards
	@$(phpcsfixer) fix --config=$(PHP_CS_FIXER_CONFIGURATION_FILE) --dry-run

phpstan: ## Lint - PHPStan - static code analysis
	@$(php) vendor/bin/phpstan analyse $(PHPSTAN_CODE_PATH) --configuration=$(PHPSTAN_CONFIGURATION_FILE)
