FROM golang:1.20-alpine as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go test ./...

RUN CGO_ENABLED=0 go build -o hello-k8s-service .




FROM alpine:latest

COPY --from=builder /app/hello-k8s-service /usr/local/bin/hello-k8s-service

CMD ["hello-k8s-service"]