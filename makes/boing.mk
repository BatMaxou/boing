SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)binaries/php.mk
include $(SELF_DIR)style/color.mk

ifeq ($(APP_ENV), prod)
	composer_options:= --optimize-autoloader --prefer-dist --no-dev
else
	composer_options:=
endif

boing:
	@$(composer) require friendsofphp/php-cs-fixer --dev
	@$(composer) require phpstan/phpstan --dev

	@echo "\n$(GREEN)--> Lint packages installed <--$(RESET)\n"

vendor:
	@$(composer) install $(composer_options)
	@echo "\n$(GREEN)--> Dependencies ready <--$(RESET)\n"
.PHONY: vendor
