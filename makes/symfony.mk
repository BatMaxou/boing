SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

DB_HOST ?= db
DB_PORT ?= 3306
DB_USER ?= root
DB_PASSWORD ?= root

include $(SELF_DIR)boing.mk
include $(SELF_DIR)lint/symfony.mk

ifeq ($(DOCKER_ENABLED),1)
	mysqldump := $(docker-compose) run --rm db mysqldump -h $(DB_HOST) -P $(DB_PORT) -u $(DB_USER) -p'$(DB_PASSWORD)'
else
	mysqldump := mysqldump -h $(DB_HOST) -P $(DB_PORT) -u $(DB_USER) -p'$(DB_PASSWORD)'
endif

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

database-dump:
	$(mysqldump) $(DB_NAME) | gzip -9 > dump/backup_$(shell date +%F_%T).sql.gz 2> /dev/null

install:
	@$(MAKE) vendor
