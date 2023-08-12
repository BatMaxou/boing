include $(SELF_DIR)binaries/php.mk

PHPQA_TAG ?= php8.1

qa := $(docker) run --rm -t -v `pwd`:/project --workdir="/project" jakzal/phpqa:$(PHPQA_TAG)
phpcsfixer := $(qa) php-cs-fixer
