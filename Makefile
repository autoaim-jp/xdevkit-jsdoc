include setting.conf
SHELL=/bin/bash
PHONY=default help init jsdoc-rebuild jsdoc-build jsdoc-up jsdoc-up-publish jsdoc-down

.PHONY: $(PHONY)

default: help

jsdoc-up: docker-compose-up-jsdoc
jsdoc-up-publish: docker-compose-up-jsdoc-publish

jsdoc-rebuild: jsdoc-down jsdoc-build
jsdoc-build: docker-compose-build-jsdoc
jsdoc-down: docker-compose-down-jsdoc

help:
	@echo "Usage: make init"
	@echo "Usage: make jsdoc-(up|up-publish)"
	@echo "Usage: make jsdoc-(rebuild|build|down)"
	@echo "Usage: make help"

init:
	mkdir -p $(PWD)/src/setting/secret/
	ssh-keygen -t rsa -b 4096 -f $(PWD)/src/setting/secret/id_rsa_deploy_key -N ""
	echo "info: register this as a deploy key at github"
	cat src/setting/secret/id_rsa_deploy_key.pub

docker-compose-up-jsdoc-publish:
	GIT_USER_NAME=${GIT_USER_NAME} GIT_USER_EMAIL=${GIT_USER_EMAIL} JSDOC_COMMAND="generate-publish" docker compose -p docker-jsdoc -f ./docker/docker-compose.jsdoc.yml up --abort-on-container-exit
docker-compose-up-jsdoc:
	GIT_USER_NAME=${GIT_USER_NAME} GIT_USER_EMAIL=${GIT_USER_EMAIL} JSDOC_COMMAND="generate" docker compose -p docker-jsdoc -f ./docker/docker-compose.jsdoc.yml up --abort-on-container-exit

docker-compose-build-jsdoc:
	docker compose -p docker-jsdoc -f ./docker/docker-compose.jsdoc.yml build

docker-compose-down-jsdoc:
	docker compose -p docker-jsdoc -f ./docker/docker-compose.jsdoc.yml down --volumes
