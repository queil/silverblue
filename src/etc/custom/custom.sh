#!/usr/bin/env bash

eval "$(starship init bash)"

export ROOZ_USER=queil
export ROOZ_IMAGE=ghcr.io/queil/image:latest
export ROOZ_SHELL=bash
export ROOZ_CACHES='~/.local/share/containers/storage/'
export DOCKER_HOST=unix:///run/user/1000/podman/podman.sock

alias nano=micro
alias nano2=nano
alias rider=/usr/bin/rider/bin/rider.sh
