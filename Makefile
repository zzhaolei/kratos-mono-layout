VERSION=$(shell git rev-parse --is-inside-work-tree > /dev/null 2>&1 && git describe --tags --always)

.PHONY: init
# init env
init:
	find app -maxdepth 1 -mindepth 1 -type d -print | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) init'

.PHONY: api
# generate api
api:
	find app -maxdepth 1 -mindepth 1 -type d -print | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) api'

.PHONY: config
# config
config:
	find app -maxdepth 1 -mindepth 1 -type d -print | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) config'

.PHONY: generate
# generate
generate:
	find app -maxdepth 1 -mindepth 1 -type d -print | xargs -L 1 bash -c 'cd "$$0" && pwd && $(MAKE) generate'

.PHONY: build
# build
build:
	mkdir -p bin/ && go build -ldflags "-X main.Version=$(VERSION)" -o ./bin/ ./...

.PHONY: create
# create app
create:
	@if [ -z "$(app)" ]; then echo "Usage: make create app=name"; exit 1; fi
	kratos new app/$(app) --nomod
	kratos proto add api/$(app)/v1/$(app).proto && \
	kratos proto client api/$(app)/v1/$(app).proto && \
	kratos proto server api/$(app)/v1/$(app).proto -t app/$(app)/internal/service && \
	cd app/$(app) && echo "include ../../app_makefile.mk" > ./Makefile && cd ../../

.PHONY: all
# all
all: api generate
