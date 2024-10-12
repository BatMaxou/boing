SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)boing.mk
include $(SELF_DIR)lint/aatis.mk

install:
	@$(MAKE) vendor
.PHONY: install
