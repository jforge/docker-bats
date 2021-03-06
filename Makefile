build_args := --build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
              --build-arg VCS_REF=$(shell git rev-parse --short HEAD)

ver?=0.4.0
latest:=0.4.0

.PHONY: build build-quick test tag push deploy help

build-quick: ## Build using caches
	@${MAKE} build cache=""

build: cache ?=--pull --no-cache
build: ## Build a bats version
	docker build ${cache} ${build_args} -t jforge/bats:${ver} .

test: ## Test the image
	docker run --rm \
		-v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/app \
		-e ver=${ver} \
		jforge/bats:${ver} .

tag: ## Tag the image to latest if it is the latest
ifeq (${ver},${latest})
	docker tag jforge/bats:${ver} jforge/bats:latest
endif

push: ## Push the images to the respository
	docker push jforge/bats:${ver}
ifeq (${ver},${latest})
	docker push jforge/bats:latest
endif

deploy: ## Tag and push the image
deploy: tag push

help: ## Show this help message.
	@echo 'usage: make [target] ...'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'
