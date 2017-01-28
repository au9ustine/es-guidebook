DOCKER_IMAGE_NAME = au9ustine/es-guidebook
COMMIT_HASH = $(shell git rev-parse HEAD)
COMMIT_BRANCH = $(shell git symbolic-ref --short HEAD)

# Commons
common-build:
	echo "git_branch: $(COMMIT_BRANCH)\ngit_commit: $(COMMIT_HASH)" > .build.yml
	docker build -t $(DOCKER_IMAGE_NAME):latest -f docker/Dockerfile .

# Development
dev-build: dev-down common-build
	docker tag $(DOCKER_IMAGE_NAME):latest $(DOCKER_IMAGE_NAME):dev

dev-testing:
	docker run --rm --network=eg_default $(DOCKER_IMAGE_NAME):dev nosetests -s

dev-up:
	docker-compose -p eg up -d

dev-down:
	docker-compose -p eg down || true
	rm -vf .build.yml

# Circle CI
circleci-dependencies: common-build
	docker version

circleci-pre-test:
	docker run -d --name es-guidebook -p 9200:9200 elasticsearch:5.1.2

circleci-test:
	curl -vvv http://localhost:9200/

circleci-deployment:
	true
