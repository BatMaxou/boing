SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)binaries/php.mk
include $(SELF_DIR)style/color.mk

boing:
	@$(composer) require friendsofphp/php-cs-fixer --dev
	@$(composer) require phpstan/phpstan --dev

	@echo "\n$(GREEN)--> Lint packages installed <--$(RESET)\n"

do-vendor:
	@$(composer) install
	@echo "\n$(GREEN)--> Dependencies ready <--$(RESET)\n"
