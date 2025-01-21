# Kratos Project Template

## Install Kratos
```shell
go install github.com/go-kratos/kratos/cmd/kratos/v2@latest
```

## Install gonew
```shell
go install golang.org/x/tools/cmd/gonew@latest
```

## Create a service
```shell
# Create a template project
gonew github.com/zzhaolei/kratos-mono-layout github.com/zzhaolei/greeter

# or
git clone github.com/zzhaolei/kratos-mono-layout
# and change go.mod module path

cd greeter
# Add a app template
make create app=hello

go generate ./...
go build -o ./bin/ ./...
./bin/hello -conf ./configs
```
## Generate other auxiliary files by Makefile
```
# Download and update dependencies
make init
# Generate API files (include: pb.go, http, grpc, validate, swagger, errors) by proto file
make api
# Generate all files
make all
```
## Automated Initialization (wire)
```
# install wire
go get github.com/google/wire/cmd/wire

# generate wire
cd app/greeter/cmd/greeter
wire
```

## Docker
```bash
# build
docker build -t <your-docker-image-name> .

# run
docker run --rm -p 8000:8000 -p 9000:9000 -v </path/to/your/configs>:/data/conf <your-docker-image-name>
```
