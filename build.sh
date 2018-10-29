#!/bin/bash
source .env

TAG="zero88/fluentd"

function build {
    local tag="$TAG:$1"

    echo "----------------------------------------------------------------------------"
    echo "Base image version:   $2"
    echo "Fluentd plugins:      $3"
    echo "Dockerfile:           $4"
    echo "----------------------------------------------------------------------------"

    docker build -f $4 -t "$tag" \
            --build-arg "FLUENTD_BUILD_VERSION=$2" \
            --build-arg "FLUENTD_PLUGINS=$3" \
            ./  || { echo "Build $tag failure"; exit 2; }
}

build "$FLUENTD_VERSION-es" $FLUENTD_BUILD_VERSION "$FLUENTD_ELASTIC_PLUGINS" $DOCKER_FILE_ALPINE
echo "----------------------------------------------------------------------------"
echo
build "$FLUENTD_VERSION-aws" $FLUENTD_BUILD_VERSION "$FLUENTD_AWS_PLUGINS" $DOCKER_FILE_ALPINE
echo "----------------------------------------------------------------------------"
echo
build "$FLUENTD_VERSION-gcp" $FLUENTD_BUILD_VERSION "$FLUENTD_GCP_PLUGINS" $DOCKER_FILE_ALPINE

docker push "$TAG:$FLUENTD_VERSION-es"
echo "----------------------------------------------------------------------------"
echo
docker push "$TAG:$FLUENTD_VERSION-aws"
echo "----------------------------------------------------------------------------"
echo
docker push "$TAG:$FLUENTD_VERSION-gcp"