# --- Stage 1: Build Stage ---
FROM golang:1.26-alpine AS builder

# Install necessary build tools
RUN apk add --no-cache git gcc musl-dev

WORKDIR /app

# Leverage Docker cache for dependencies
COPY go.mod go.sum ./

# Fix network issues with proxy fallback and setting explicit direct modes
ENV GOPROXY=https://proxy.golang.org/|https://gocenter.io|direct
ENV GO111MODULE=on

RUN go mod download

# Copy the rest of the source code
COPY . .

# Compile the Go application as a statically linked binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o muchtodo-api ./cmd/api

# --- Stage 2: Final Production Stage ---
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata curl

WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/muchtodo-api .

EXPOSE 8080

CMD ["./muchtodo-api"]
