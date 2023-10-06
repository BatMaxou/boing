SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)binaries/php.mk

current-date = $(shell date +"_%Y-%m-%d_%H-%M-%S")
port ?= 8616

ifeq ($(DOCKER_ENABLED), 1)
	CONTAINER_NAME ?= php
	DB_CONTAINER_NAME ?= db
	CONTAINER := $(docker-compose) exec $(CONTAINER_NAME)
	DB_CONTAINER := $(docker-compose) exec -T $(DB_CONTAINER_NAME)
	DRUSH := $(CONTAINER) vendor/bin/drush
else
	DRUSH := vendor/bin/drush
endif

cache-clear:
	@$(DRUSH) cache:rebuild
	@echo "--> Cache clear"

init-backup:
	@if [ "$(DOCKER_ENABLED)" = 1 ]; then \
		$(CONTAINER) mkdir backups -p; \
    else \
        mkdir backups -p; \
    fi
	@echo "--> backups directory enabled"

refresh-backups:
	@if [ "$(DOCKER_ENABLED)" = 1 ]; then \
		$(CONTAINER) rm -rf backups/*; \
    else \
    	rm -rf backups/*; \
    fi
	@echo "--> Backup directory cleaned"
	@$(MAKE) dump

create-database:
	@if [ "$(DOCKER_ENABLED)" = 1 ]; then \
    	echo '--> You should create the database by your own, this method is not safe'; \
    else \
		$(DRUSH) sql:create -y; \
		echo "--> Database created"; \
    fi

start:
	@$(DRUSH) rs $(port)

dump:
	@$(MAKE) init-backup
	@if [ "$(DOCKER_ENABLED)" = 1 ]; then \
		$(DB_CONTAINER) mysqldump -uroot -p$(DB_PASSWORD) $(DB_NAME) > backups/dump$(current-date).sql; \
    else \
		$(DRUSH) sql:dump --result-file=../backups/dump$(current-date).sql; \
    fi
	@echo "--> Database dumped"

restore:
	@if [ "$(DOCKER_ENABLED)" = 1 ]; then \
		$(DB_CONTAINER) mysql -uroot -p$(DB_PASSWORD) $(DB_NAME) < $(file); \
    else \
		$(DRUSH) sql:cli < $(file); \
    fi
	@echo "--> Database restored"

config-export:
	@$(MAKE) cache-clear
	@$(DRUSH) config:export -y

config-import:
	@$(MAKE) cache-clear
	@$(DRUSH) config:import -y

install:
	@$(composer) install
	@if [ "$(DOCKER_ENABLED)" = 0 ]; then \
		$(MAKE) create-database; \
    fi
	@$(MAKE) restore file=$(file)
	@$(MAKE) config-import
	@echo "--> Project ready to be started"
