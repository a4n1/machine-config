#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: pr <image_name>"
  exit 1
fi

NAME="$1"
IMAGE="docker.io/a4n1/$NAME:latest"
SERVICE="podman-$NAME.service"

podman pull "$IMAGE"
sudo systemctl restart "$SERVICE"
echo "Done! $SERVICE restarted with the latest image"
