SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)binaries/php.mk

DRUSH := vendor/bin/drush
current-date = $(shell date +"_%Y-%m-%d_%H-%M-%S")

port ?= 8616

cache-clear:
	@echo "Cache clear"
	$(DRUSH) cache:rebuild

init-backup:
	@mkdir backups -p

refresh-backups:
	@rm -rf backups/*

create-database:
	@$(DRUSH) sql:create -y

start:
	@$(DRUSH) rs $(port)

dump:
	@$(MAKE) init-backup
	@$(DRUSH) sql:dump --result-file=../backups/dump$(current-date).sql

restore:
	@$(DRUSH) sql:cli < $(file)

config-export:
	@$(MAKE) cache-clear
	@$(DRUSH) config:export -y

config-import:
	@$(MAKE) cache-clear
	@$(DRUSH) config:import -y

install:
	@$(composer) install
	@$(MAKE) create-database
	@$(MAKE) restore file=$(file)
	@$(MAKE) config-import
