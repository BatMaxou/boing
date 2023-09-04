SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)binaries/docker.mk

database:
	$(php) bin/console doctrine:database:create
	$(php) bin/console doctrine:schema:update -f --complete
	$(php) bin/console doctrine:fixture:load -n

database-drop:
	$(php) bin/console doctrine:database:drop -f

database-reset: database-drop database
