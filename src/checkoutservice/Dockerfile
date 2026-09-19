# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0

FROM --platform=$BUILDPLATFORM golang:1.25.0-alpine@sha256:68fc16b7551a4cf71251f343a47ff766ec4fa7c02fbdeb4c5ed2a14c2c23ea08 AS builder

WORKDIR /src

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -o /checkoutservice .

FROM scratch

WORKDIR /src

COPY --from=builder /checkoutservice /src/checkoutservice

ENV GOTRACEBACK=single

EXPOSE 5050

ENTRYPOINT ["/src/checkoutservice"]