# Compile stage
#FROM golang:1.10.1-alpine3.7 AS build-env

FROM golang:1.13.9-alpine3.10 AS build-env

ENV CGO_ENABLED 0
ADD main.go main.go
 
# The -gcflags "all=-N -l" flag helps us get a better debug experience
RUN go build -gcflags "all=-N -l" -o /main main.go
 
# Compile Delve
RUN apk add --no-cache git
RUN go get github.com/derekparker/delve/cmd/dlv
 
# Final stage
#FROM alpine:3.7
 
FROM alpine:3.10

# Port 8080 belongs to our application, 40000 belongs to Delve
# EXPOSE 8080 
EXPOSE 40000
 
# Allow delve to run on Alpine based containers.
RUN apk add --no-cache libc6-compat
 
WORKDIR /
 
COPY --from=build-env /main /
COPY --from=build-env /go/bin/dlv /
 
# Run delve
CMD ["/dlv", "--listen=:40000", "--headless=true","--accept-multiclient", "--api-version=2", "exec", "/main"]
