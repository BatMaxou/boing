SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)boing.mk
include $(SELF_DIR)lint/symfony.mk

database-create:
	@$(php) bin/console doctrine:database:create

database-drop:
	@$(php) bin/console doctrine:database:drop -f

database-update:
	@$(php) bin/console doctrine:schema:update -f --complete

database-fixtures:
	@$(php) bin/console doctrine:fixture:load -n

database: database-create database-update database-fixtures

database-reset: database-drop database

install:
	@$(MAKE) vendor
