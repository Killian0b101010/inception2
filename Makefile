NAME = inception
COMPOSE = ./srcs/docker-compose.yml

SRC_CONFIG = $(HOME)/.env
DST_CONFIG = srcs/.env

DATA_DIR = $(PWD)/data

build : prepare
	docker compose -f $(COMPOSE) up --build -d

prepare :
	@mkdir -p $(DATA_DIR)/wordpress $(DATA_DIR)/mariadb
	@echo "✓ Data directories created at $(DATA_DIR)"

down  :
	docker compose -f $(COMPOSE) down 

downv :
	docker compose -f $(COMPOSE) down -v 

downv :
	docker compose -f $(COMPOSE) down -v

stop : 
	docker compose -f $(COMPOSE) stop 

ps :
	docker compose -f $(COMPOSE) ps

