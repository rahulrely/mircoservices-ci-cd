# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Stage 1: Build native dependencies
FROM --platform=$BUILDPLATFORM node:20-alpine AS builder

# Install build dependencies for native modules (e.g., @google-cloud/profiler)
RUN apk update && apk upgrade --no-cache && \
    apk add --no-cache python3 make g++

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci --omit=dev

# Stage 2: Minimal runtime image
FROM node:20-alpine

# Upgrade base packages to ensure no lingering OS-level CVEs remain
RUN apk update && apk upgrade --no-cache

WORKDIR /usr/src/app

# Non-root user provided by node image for better container security
USER node

COPY --chown=node:node --from=builder /usr/src/app/node_modules ./node_modules
COPY --chown=node:node . .

EXPOSE 7000

ENTRYPOINT [ "node", "server.js" ]