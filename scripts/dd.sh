#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: dd <image_name>"
  exit 1
fi

IMAGE_NAME="$1"

docker build -t "$IMAGE_NAME:latest" .
docker tag "$IMAGE_NAME:latest" "a4n1/$IMAGE_NAME:latest"
docker push "a4n1/$IMAGE_NAME:latest"
echo "Done! Image pushed: a4n1/$IMAGE_NAME:latest"
