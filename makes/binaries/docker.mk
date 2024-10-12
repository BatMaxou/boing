DOCKER_ENABLED ?= 0

ifeq ($(DOCKER_ENABLED),1)
  docker := $(shell which docker)
  docker-compose := $(docker) compose
else
  docker :=
  docker-compose :=
endif
