SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)binaries/php.mk

boing:
	$(composer) require friendsofphp/php-cs-fixer --dev
	$(composer) require phpstan/phpstan --dev

	@echo "\n$(GREEN)--> Lint packages installed <--$(RESET)\n"
