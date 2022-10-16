## Build
FROM golang:1.16-alpine as build
RUN apk add --no-cache git
WORKDIR /tmp/app
# Download necessary Go modules
COPY src/go.mod .
COPY src/go.sum .
RUN go mod download
COPY src .
RUN go build -o ./out/secret-api .

FROM alpine:3.9
RUN apk add ca-certificates
COPY --from=build /tmp/app/out/secret-api /app/secret-api
EXPOSE 8080
ENTRYPOINT ["/app/secret-api"]
