FROM node:20-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    git \
    openssh-server \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app/src
COPY ./src/package.json /app/src/

RUN yarn install

WORKDIR /app/

