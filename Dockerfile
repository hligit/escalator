FROM --platform=$BUILDPLATFORM golang:1.14 as builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
WORKDIR /go/src/github.com/atlassian/escalator/
COPY go.mod go.sum ./
COPY cmd cmd
COPY pkg pkg
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo cmd/main.go

FROM --platform=$TARGETPLATFORM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /go/src/github.com/atlassian/escalator/main .
CMD [ "./main" ]
