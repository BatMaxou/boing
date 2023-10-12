SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)boing.mk

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
	@echo "\n$(GREEN)--> Cache clear <--$(RESET)\n"

is-file-empty:
	@if [ "$(file)" ]; then \
		echo ''; \
	else \
		echo "\n$(RED)--> Missing file to restore <--$(RESET)\n"; \
		exit 1; \
	fi

init-backup:
	@if [ "$(DOCKER_ENABLED)" = 1 ]; then \
		$(CONTAINER) mkdir backups -p; \
    else \
        mkdir backups -p; \
    fi
	@echo "\n$(BLUE)--> $(PURPLE)backups $(BLUE)directory enabled <--$(RESET)\n"

refresh-backups:
	@if [ "$(DOCKER_ENABLED)" = 1 ]; then \
		$(CONTAINER) rm -rf backups/*; \
    else \
    	rm -rf backups/*; \
    fi
	@echo "\n$(GREEN)--> Backup directory cleaned <--$(RESET)\n"
	@$(MAKE) dump

create-database:
	@if [ "$(DOCKER_ENABLED)" = 1 ]; then \
    	echo '\n$(YELLOW)--> You should create the database by your own, this method is not safe <--$(RESET)\n'; \
    else \
		$(DRUSH) sql:create -y; \
		echo "\n$(GREEN)--> Database created <--$(RESET)\n"; \
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
	@echo "\n$(GREEN)--> Database dumped <--$(RESET)\n"

restore:
	@$(MAKE) is-file-empty

	@if [ "$(DOCKER_ENABLED)" = 1 ]; then \
		$(DB_CONTAINER) mysql -uroot -p$(DB_PASSWORD) $(DB_NAME) < $(file); \
	else \
		$(DRUSH) sql:cli < $(file); \
	fi

	@echo "\n$(GREEN)--> Database restored <--$(RESET)\n"

config-export:
	@$(MAKE) cache-clear
	@$(DRUSH) config:export -y

config-import:
	@$(MAKE) cache-clear
	@$(DRUSH) config:import -y

install:
	@$(MAKE) do-vendor

	@if [ "$(DOCKER_ENABLED)" = 0 ]; then \
		$(MAKE) create-database; \
	fi; \

	@if [ "$(file)" ]; then \
		$(MAKE) restore file=$(file); \
		$(MAKE) config-import; \
	fi

	@echo "\n$(BLUE)--> Project ready to be started <--$(RESET)\n"
