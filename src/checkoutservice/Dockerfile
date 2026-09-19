# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0

FROM --platform=$BUILDPLATFORM golang:1.25.13-alpine@sha256:fec9672136e7ccfa4f6cf59177987de3d8ee9b14953b6ea5485dbd08bf7b4aed AS builder
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