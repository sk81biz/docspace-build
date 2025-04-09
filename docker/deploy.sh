#!/bin/bash

BUILD_ALL_SERVICES=${BUILD_ALL_SERVICES:-"false"}
BUILD_SERVICES_LIST=${BUILD_SERVICES_LIST:-" onlyoffice-router onlyoffice-login  onlyoffice-sdk onlyoffice-doceditor"}

random_hex=$(cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 8 | head -n 1)
export VERSION=$(echo "$(date +'%d.%m.%Y-time:%H:%M:%S')_hex:${random_hex}")

#APP_URL_PORTAL="https://sdk-ssr.onlyoffice.io" REPO="onlyoffice" DOCKER_IMAGE_PREFIX="4testing" DOCKER_TAG="develop-ssr" docker compose -f \
#       	/home/ubuntu/projects/DocSpace-buildtools/install/docker/docspace.yml config
cd /home/ubuntu/projects/docspace-build/docker/

docker system prune -f

if [[ "$BUILD_ALL_SERVICES" == "true" ]]; then
	BUILD_SERVICES_LIST=""
fi

echo "BUILD_NUMBER: ${VERSION}"
echo "BUILD_ALL_SERVICES: ${BUILD_ALL_SERVICES}"
echo "BUILD_SERVICES_LIST: ${BUILD_SERVICES_LIST}"

DOCKERFILE="Dockerfile.app" REPO="onlyoffice" DOCKER_IMAGE_PREFIX="4testing" DOCKER_TAG="develop-ssr" docker compose -f build.yml build ${BUILD_SERVICES_LIST} \
	--build-arg GIT_BRANCH="bugfix/sdk-ssr" --build-arg BUILD_NUMBER="${VERSION}"

docker image ls | grep "develop-ssr"

APP_URL_PORTAL="https://sdk-ssr.onlyoffice.io" REPO="onlyoffice" DOCKER_IMAGE_PREFIX="4testing" DOCKER_TAG="develop-ssr" docker compose -f \
       	/home/ubuntu/projects/DocSpace-buildtools/install/docker/docspace.yml up -d
