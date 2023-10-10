SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)lint/symfony.mk
include $(SELF_DIR)boing.mk

database:
	@$(php) bin/console doctrine:database:create
	@$(php) bin/console doctrine:schema:update -f --complete
	@$(php) bin/console doctrine:fixture:load -n

database-drop:
	@$(php) bin/console doctrine:database:drop -f

database-reset: database-drop database

install:
	@$(MAKE) do-vendor