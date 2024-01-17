#!/usr/bin/env bash
export _DEBIAN_RELEASE=bookworm-slim
docker buildx build --platform linux/arm64/v8,linux/amd64 --build-arg=DEBIAN_RELEASE=${_DEBIAN_RELEASE} -t deblatex:${_DEBIAN_RELEASE} .
