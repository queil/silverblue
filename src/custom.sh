#!/usr/bin/env bash

eval "$(starship init bash)"

export ROOZ_USER=queil
export ROOZ_IMAGE=ghcr.io/queil/image:latest
export ROOZ_SHELL=bash
export DOCKER_HOST=unix:///run/user/1000/podman/podman.sock
