DC=docker-compose
DCR=$(DC) run --rm
APP_NAME=feed_api

docker-build:
	docker build -t $(APP_NAME) .
