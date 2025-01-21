FROM golang:1.23-alpine3.20 AS builder

COPY service /app
WORKDIR /app

RUN GOPROXY=https://goproxy.cn make build

FROM golang:alpine

WORKDIR /app
COPY --from=builder /app/bin /app

WORKDIR /app

EXPOSE 8000
EXPOSE 9000
VOLUME /data/conf

CMD ["./server", "-conf", "/data/conf"]
