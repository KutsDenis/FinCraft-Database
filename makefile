# Переменные
DOCKER_COMPOSE = docker-compose
MIGRATE = migrate
SERVICE = postgres
TEST_SERVICE = postgres-test

# Пути
MIGRATIONS_PATH = migrations

# Подгрузить переменные из .env
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Формируем строки подключения
DB_DSN = postgres://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable
TEST_DB_DSN = postgres://$(TEST_DB_USER):$(TEST_DB_PASSWORD)@$(TEST_DB_HOST):$(TEST_DB_PORT)/$(TEST_DB_NAME)?sslmode=disable

# Команды
.PHONY: up down restart logs clean ps shell test-up test-down test-logs test-shell all-up all-down all-logs migrate-up migrate-down migrate-reset migrate-status test-migrate-up test-migrate-down test-migrate-reset test-migrate-status

# Запустить основную базу
up:
	$(DOCKER_COMPOSE) up -d $(SERVICE)

# Остановить основную базу
down:
	$(DOCKER_COMPOSE) down $(SERVICE)

# Перезапустить основную базу
restart:
	$(DOCKER_COMPOSE) down $(SERVICE) && $(DOCKER_COMPOSE) up -d $(SERVICE)

# Показать логи основной базы
logs:
	$(DOCKER_COMPOSE) logs -f $(SERVICE)

# Войти в shell PostgreSQL (основная база)
shell:
	docker exec -it $(SERVICE) psql -U $(DB_USER) -d $(DB_NAME)

# Запустить тестовую базу
test-up:
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.override.yml up -d --no-deps $(TEST_SERVICE)

# Остановить тестовую базу
test-down:
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.override.yml down $(TEST_SERVICE)

# Показать логи тестовой базы
test-logs:
	$(DOCKER_COMPOSE) logs -f $(TEST_SERVICE)

# Войти в shell PostgreSQL (тестовая база)
test-shell:
	docker exec -it $(TEST_SERVICE) psql -U $(TEST_DB_USER) -d $(TEST_DB_NAME)

# Запустить все базы
all-up:
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.override.yml up -d

# Остановить все базы
all-down:
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.override.yml down

# Показать логи всех баз
all-logs:
	$(DOCKER_COMPOSE) logs -f

# Применить все миграции (основная база)
migrate-up:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(DB_DSN)" up

# Откатить N миграций (основная база)
migrate-down:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(DB_DSN)" down $(N)

# Откатить все миграции (основная база)
migrate-reset:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(DB_DSN)" down

# Проверить статус миграций (основная база)
migrate-status:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(DB_DSN)" version

# Применить все миграции (тестовая база)
test-migrate-up:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(TEST_DB_DSN)" up

# Откатить N миграций (тестовая база)
test-migrate-down:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(TEST_DB_DSN)" down $(N)

# Откатить все миграции (тестовая база)
test-migrate-reset:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(TEST_DB_DSN)" down

# Проверить статус миграций (тестовая база)
test-migrate-status:
	$(MIGRATE) -path $(MIGRATIONS_PATH) -database "$(TEST_DB_DSN)" version
