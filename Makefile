NAME = inception
COMPOSE = ./srcs/docker-compose.yml

SRC_CONFIG = $(HOME)/.env
DST_CONFIG = srcs/.env

build : 
	docker compose -f $(COMPOSE) up --build -d

down  :
	docker compose -f $(COMPOSE) down 

downv :
	docker compose -f $(COMPOSE) down -v

stop : 
	docker compose -f $(COMPOSE) stop 

ps :
	docker compose -f $(COMPOSE) ps

