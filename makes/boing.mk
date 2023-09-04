SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)binaries/php.mk
include $(SELF_DIR)lint/symfony.mk

boing:
	$(composer) require friendsofphp/php-cs-fixer --dev
	$(composer) require phpstan/phpstan --dev
