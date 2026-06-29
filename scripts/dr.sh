#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: dr <image_name> <port>"
  exit 1
fi

IMAGE_NAME="$1"
PORT="$2"
shift 2

docker rm -f "$IMAGE_NAME" 2>/dev/null || true
docker build -t "$IMAGE_NAME" .
docker run -p "$PORT:$PORT" --name "$IMAGE_NAME" "$@" "$IMAGE_NAME"
