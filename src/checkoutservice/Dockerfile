# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0

FROM --platform=$BUILDPLATFORM golang:1.24.13-alpine@sha256:757779acac4af1b349a20f357c7296097b4a0b89da4ad0e370b339060077282a AS builder

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