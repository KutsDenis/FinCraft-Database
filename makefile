# Переменные
DOCKER_COMPOSE = docker-compose
MIGRATE = migrate
SERVICE = postgres

# Пути
MIGRATIONS_PATH = migrations

# Подгрузить переменные из .env
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Команды
.PHONY: up down restart logs clean ps shell migrate-up migrate-down migrate-reset migrate-status

# Запустить все сервисы в фоне
up:
	$(DOCKER_COMPOSE) up -d

# Остановить все сервисы
down:
	$(DOCKER_COMPOSE) down

# Перезапустить сервисы
restart:
	$(DOCKER_COMPOSE) down && $(DOCKER_COMPOSE) up -d

# Показать логи сервиса
logs:
	$(DOCKER_COMPOSE) logs -f $(SERVICE)

# Очистить контейнеры, volume'ы и сети
clean:
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

# Показать статус контейнеров
ps:
	$(DOCKER_COMPOSE) ps

# Войти в shell PostgreSQL
shell:
	docker exec -it $(SERVICE) psql -U $(DB_USER) -d $(DB_NAME)

# Применить все миграции
migrate-up:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(DB_DSN)" up

# Откатить N миграций
migrate-down:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(DB_DSN)" down $(N)

# Откатить все миграции
migrate-reset:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(DB_DSN)" down

# Проверить статус миграций
migrate-status:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(DB_DSN)" version
