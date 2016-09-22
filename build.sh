#!/bin/sh

RELEASE=$1

if [ "x$RELEASE" == "x" ]
then
    echo "Release name not set"
    exit 1
fi

RELEASE_DIR=releases/$1
REMOTE=git@github.com:savonarola/smppex_web.git
IMAGE_TAG=smppex_web

SMPPEX_WEB=$(pwd)
RELEASE_DIR_FULL=$SMPPEX_WEB/$RELEASE_DIR

mkdir -p releases
git clone $REMOTE $RELEASE_DIR

docker build -t $IMAGE_TAG .
docker run -v $RELEASE_DIR_FULL:/smppex_web -w /smppex_web $IMAGE_TAG make release


