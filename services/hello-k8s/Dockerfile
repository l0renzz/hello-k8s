FROM golang:1.20-alpine

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go test ./...

RUN CGO_ENABLED=0 go build -o main .

CMD ["./main"]