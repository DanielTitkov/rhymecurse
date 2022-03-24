NAME := app
BUILD_CMD ?= CGO_ENABLED=0 go build -o bin/${NAME} -ldflags '-v -w -s' ./cmd/${NAME}
DEV_CONFIG_PATH := ./configs/dev.yml
CONFIG_TEMPLATE_PATH := ./configs/template.yml

# Docker
DOCKER_APP_FILENAME ?= deployments/docker/Dockerfile
DOCKER_COMPOSE_FILE ?= deployments/docker-compose/docker-compose.yml

# sed
SECRET_KEY ?= "very-secret-key"
CONFIG_PATH ?= ./configs/new.yml

define sedi
    sed --version >/dev/null 2>&1 && sed -- $(1) > ${CONFIG_PATH} || sed "" $(1) > ${CONFIG_PATH}
endef

.PHONY: run
run: 
	go run cmd/$(NAME)/main.go ${DEV_CONFIG_PATH}

.PHONY: up
up:
	docker-compose -f ${DOCKER_COMPOSE_FILE} up --build --remove-orphans --always-recreate-deps --renew-anon-volumes

.PHONY: test
test:
	go test ./... -cover

.PHONY: build
build:
	echo "building"
	${BUILD_CMD}
	echo "build done"

.PHONY: lint
lint:
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.29.0
	./bin/golangci-lint run -v

.PHONY: substitute_config_vars
substitute_config_vars:
	$(call sedi," \
		s/{{db_password}}/${DB_PASSWORD}/g;         \
		s/{{db_name}}/${DB_NAME}/g;                 \
		s/{{db_host}}/${DB_HOST}/g;                 \
		s/{{db_port}}/${DB_PORT}/g;                 \
		s/{{db_user}}/${DB_USER}/g;                 \
		s/{{secret_key}}/${SECRET_KEY}/g;           \
		s/{{telegram_to}}/${TELEGRAM_TO}/g;         \
		s/{{telegram_token}}/${TELEGRAM_TOKEN}/g;   \
		" ${CONFIG_TEMPLATE_PATH})
	cat ${CONFIG_PATH}