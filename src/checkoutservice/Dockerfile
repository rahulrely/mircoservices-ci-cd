# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0

FROM golang:1.23.4-alpine@sha256:c23339199a08b0e12032856908589a6d41a0dab141b8b3b21f156fc571a3f1d3 AS builder

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