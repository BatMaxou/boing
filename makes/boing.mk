SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)lint/symfony.mk

boing:
	composer require friendsofphp/php-cs-fixer --dev