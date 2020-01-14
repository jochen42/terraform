#!/bin/bash

set -x
set -e

IMAGE_BASE=jochen42/terraform
declare -a TERRAFORM_VERSIONS=("0.11.14" "0.12.19")

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

for TERRAFORM_VERSION in ${TERRAFORM_VERSIONS[@]}; do
    echo "[INFO] Build for terrform ${TERRAFORM_VERSION} as ${IMAGE_BASE}:${TERRAFORM_VERSION}" 
    docker build \
        --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
        --tag ${IMAGE_BASE}:${TERRAFORM_VERSION} .

    docker image ls | grep ${IMAGE_BASE}
    
    echo "[INFO] Push long version ${IMAGE_BASE}:${TERRAFORM_VERSION}" 
    docker push ${IMAGE_BASE}:${TERRAFORM_VERSION}

    echo "[INFO] Push short version ${IMAGE_BASE}:${SHORTVERSION}" 
    SHORTVERSION="$(cut -d '.' -f 1 <<< "$TERRAFORM_VERSION")"."$(cut -d '.' -f 2 <<< "$TERRAFORM_VERSION")"
    docker tag ${IMAGE_BASE}:${TERRAFORM_VERSION} ${IMAGE_BASE}:${SHORTVERSION}
    docker image ls | grep ${IMAGE_BASE}
    docker push ${IMAGE_BASE}:${SHORTVERSION}
done
