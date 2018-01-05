# Include environment variables from .env
include .env

RAILS_CMD=bin/rails
RAKE_CMD=bin/rake

# Colors
GREEN=\033[0;32m
RED=\033[0;31m
NC=\033[0m # No Color

# If code is executed inside a container
ifneq ($(wildcard /.dockerenv),)
	DOCKER_HOST_IP := $(shell /sbin/ip route|awk '/default/ { print $$3 }')
else
	DOCKER_APP_CONTAINER_ID := $(shell docker ps --filter="name=$(APP_CONTAINER_NAME)" -q)
endif

# Models
# scaffold:
# destroy:

# Database
create_db:
	# $(RAKE_CMD) db:schema:load;	# Load db schema (Delete and Create empty DB)
	$(RAKE_CMD) db:drop;			# Drop DB
	$(RAKE_CMD) db:create;			# Create DB if doesn't exists
	#$(RAKE_CMD) db:clear;			# Drop tables from environment related db
	$(RAKE_CMD) db:migrate;			# Create tables and relations - Used for version control

clear:
	$(RAKE_CMD) db:clear RAILS_ENV=$(ENV);

migrate:
	$(RAKE_CMD) db:migrate RAILS_ENV=$(ENV);

seed:
	$(RAKE_CMD) db:seed RAILS_ENV=$(ENV);

init: migrate seed
redo: destroy scaffold create_db seed

deploy:
	git push heroku master:master
	heroku run rake db:migrate -a jesucrypto-api;

build:
ifeq ($(wildcard /.dockerenv),)
	docker-compose build
endif

run:
ifeq ($(wildcard /.dockerenv),)
	docker-compose up
endif

start:
ifeq ($(wildcard /.dockerenv),)
	docker-compose up -d
endif

stop:
ifeq ($(wildcard /.dockerenv),)
	docker-compose stop
endif

restart:
ifeq ($(wildcard /.dockerenv),)
	docker-compose restart
endif

rm-containers:
ifeq ($(wildcard /.dockerenv),)
	docker rm $(shell docker stop $(APP_CONTAINER_NAME) $(DATABASE_CONTAINER_NAME)
endif

clean-images:
ifeq ($(wildcard /.dockerenv),)
	docker rmi $(shell docker images -q -f "dangling=true")
endif

rebuild:
	(${MAKE} rm-containers || ${MAKE} clean-images || true) && ${MAKE} build

enter:
	docker exec -it $(APP_CONTAINER_NAME) /bin/bash -l

enter-db:
	docker exec -it $(DATABASE_CONTAINER_NAME) /bin/bash -l

status:
ifeq ($(wildcard /.dockerenv),)
ifeq ($(DOCKER_APP_CONTAINER_ID),)
	@echo "$(RED)APP container is not running$(NC)"
else
	@echo "$(GREEN)APP container is running$(NC)"
endif
endif

s: server
server: start
ifeq ($(wildcard /.dockerenv),)
	docker exec -it $(APP_CONTAINER_NAME) /bin/bash -l -c "make server";
else
	TRUSTED_IP=$(DOCKER_HOST_IP) RAILS_ENV=$(ENV) $(RAILS_CMD) s -b 0.0.0.0 -p 3000 #TRUSTED_IP=$(DOCKER_HOST_IP) RAILS_ENV=$(ENV) bundle exec puma -b tcp://0.0.0.0 -p 3000
	
endif

c: console
console: start
ifeq ($(wildcard /.dockerenv),)
	docker exec -it $(APP_CONTAINER_NAME) /bin/bash -l -c "make console";
else
	TRUSTED_IP=$(DOCKER_HOST_IP) RAILS_ENV=$(ENV) $(RAILS_CMD) c
endif

b: bundle
bundle: start
ifeq ($(wildcard /.dockerenv),)
	docker exec -it $(APP_CONTAINER_NAME) /bin/bash -l -c "make script";
else
	/bin/bash -l -c /etc/my_init.d/0000_init_container.sh;
endif