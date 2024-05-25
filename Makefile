.DEFAULT_GOAL := help
.PHONY: *

UID ?= $(shell id -u)
GID ?= $(shell id -g)

#
# Make sure to run the given command in a container identified by the given service.
# Enter into given container to execute the command only if /.dockerenv file does not exist and given Docker compose service exists.
#
# $(1) the user with which run the command
# $(2) the Docker Compose service
# $(3) the command to run
#
define run-in-container
	if [ $$(env|grep -c "^CI=") -gt 0 -a $$(env|grep -cw "DOCKER_DRIVER") -eq 1 ]; then \
		docker compose exec --user $(1) -T $(2) $(3); \
	elif [ ! -f /.dockerenv -a "$$(docker compose ps -q $(2) 2>/dev/null)" ]; then \
		docker compose exec --user $(1) $(2) $(3); \
	else \
		cd site && $(3); \
	fi
endef

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

############################
# APPLICATION
############################

install: ## Install Dependencies
	@$(call run-in-container,www-data,php,php -d memory_limit=256M /usr/bin/composer install)

clear: ## Clear cache
	@$(call run-in-container,root,php,rm -rf var/cache/*)
	@$(call run-in-container,root,php,bin/console cache:clear)
	@$(call run-in-container,root,php,bin/console cache:warmup)

check-phpstan: ## Check PHP errors and standards.
	@$(call run-in-container,root,php,php -d memory_limit=-1 vendor/bin/phpstan analyse src --level 9)

check-phpstyle: ## Fix PHP code style.
	@$(call run-in-container,www-data,php,./vendor/bin/php-cs-fixer fix --verbose --diff --dry-run)

fix-phpstyle: ## Fix PHP code style.
	@$(call run-in-container,www-data,php,./vendor/bin/php-cs-fixer fix --verbose)