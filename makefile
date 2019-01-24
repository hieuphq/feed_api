DC=docker-compose
DCR=$(DC) run --rm
APP_NAME=feed_api
DOCKER_USER=hieuphq

docker-build:
	docker build -t $(DOCKER_USER)/$(APP_NAME) .

docker-push:
	docker push $(DOCKER_USER)/$(APP_NAME)
