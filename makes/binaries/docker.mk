# Defines docker binaries

DOCKER_ENABLED ?= 0

ifeq ($(DOCKER_ENABLED),1)
  docker := $(shell which docker)
  docker-compose := $(docker) compose
  dockerize := $(docker) run --rm --network=$(NETWORK_TO_DOCKERIZE) jwilder/dockerize -timeout 60s -wait
else
  docker := :
  docker-compose := :
  dockerize := :
endif
