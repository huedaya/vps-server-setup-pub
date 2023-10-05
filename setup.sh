#!/bin/sh
mkdir -p /home/server/apps
mkdir -p /home/server/system
mkdir -p traefik-data/config
touch traefik-data/acme.json
chmod 600 traefik-data/acme.json
docker network create proxy
docker-compose up -d
