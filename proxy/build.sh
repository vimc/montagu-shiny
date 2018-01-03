#!/usr/bin/env bash
docker build \
       --tag montagu-shiny-proxy \
       --build-arg plugins=jwt \
       github.com/abiosoft/caddy-docker.git
