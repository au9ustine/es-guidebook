DOCKER_IMAGE_NAME = au9ustine/es-guidebook
COMMIT_HASH = $(shell git rev-parse HEAD)
COMMIT_BRANCH = $(shell git symbolic-ref --short HEAD)

# Commons
common-build:
	echo "git_branch: $(COMMIT_BRANCH)\ngit_commit: $(COMMIT_HASH)" > .build.yml
	docker build -t $(DOCKER_IMAGE_NAME):latest -f docker/Dockerfile .

# Development
dev-build: common-build
	docker tag $(DOCKER_IMAGE_NAME):latest $(DOCKER_IMAGE_NAME):dev

dive-in: dev-build
	docker run --rm -it $(DOCKER_IMAGE_NAME):dev bash

dev-test:
	docker run --rm $(DOCKER_IMAGE_NAME):dev nosetest -s

dev-up:
	docker-compose -p eg up -d

dev-down:
	docker-compose -p eg down || true
	rm -vf .build.yml

# Circle CI
circleci-dependencies: common-build

circleci-pre-test:
	true

circleci-test:
	make dev-up dev-test

circleci-post-test:
	make dev-down

circleci-deployment:
	true
