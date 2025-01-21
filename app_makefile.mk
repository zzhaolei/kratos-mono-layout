GOHOSTOS:=$(shell go env GOHOSTOS)
GOPATH:=$(shell go env GOPATH)
VERSION=$(shell git rev-parse --is-inside-work-tree > /dev/null 2>&1 && git describe --tags --always)

API_PATH=../../api
APP_PATH=../../app
DOCS=../../docs
THIRD_PARTY=../../third_party

INTERNAL_PROTO_FILES=$(shell find ./internal -name *.proto)
API_PROTO_FILES=$(shell find $(API_PATH) -name *.proto)

.PHONY: init
# init env
init:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install github.com/go-kratos/kratos/cmd/protoc-gen-go-http/v2@latest
	go install github.com/go-kratos/kratos/cmd/protoc-gen-go-errors/v2@latest
	go install github.com/google/gnostic/cmd/protoc-gen-openapi@latest
	go install github.com/google/wire/cmd/wire@latest

.PHONY: api
# generate api proto
api:
	protoc --proto_path=$(API_PATH) \
	       --proto_path=$(THIRD_PARTY) \
	       --go_out=paths=source_relative:$(API_PATH) \
	       --go-http_out=paths=source_relative:$(API_PATH) \
	       --go-grpc_out=paths=source_relative:$(API_PATH) \
	       --go-errors_out=paths=source_relative:$(API_PATH) \
	       --openapi_out=fq_schema_naming=true,default_response=false:$(DOCS) \
	       $(API_PROTO_FILES)

.PHONY: config
# generate internal proto
config:
	protoc --proto_path=./internal \
	       --proto_path=$(THIRD_PARTY) \
	       --go_out=paths=source_relative:./internal \
	       $(INTERNAL_PROTO_FILES)

.PHONY: build
# build
build:
	mkdir -p bin/ && go build -ldflags "-X main.Version=$(VERSION)" -o ./bin/ ./...

.PHONY: generate
# generate
generate:
	go generate ./...
	go mod tidy

# show help
help:
	@echo ''
	@echo 'Usage:'
	@echo ' make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
	helpMessage = match(lastLine, /^# (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
			printf "\033[36m%-22s\033[0m %s\n", helpCommand,helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
