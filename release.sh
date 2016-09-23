#!/bin/sh

set -e

RELEASE=$1
BRANCH=$2

if [ "x$RELEASE" == "x" ]
then
    echo "Release name not set"
    exit 1
fi

if [ "x$BRANCH" == "x" ]
then
    echo "Branch name not set"
    exit 1
fi

RELEASE_DIR=releases/$1
REMOTE=git@github.com:savonarola/smppex_web.git
IMAGE_TAG=smppex_web

CWD=$(pwd)

rm -rf $RELEASE_DIR
mkdir -p $RELEASE_DIR

git clone $REMOTE $RELEASE_DIR/smppex_web.git --bare
cp config/prod.secret.exs $RELEASE_DIR/prod.secret.exs
cp build.sh $RELEASE_DIR/build.sh

docker build -t $IMAGE_TAG .
docker run -v $CWD/$RELEASE_DIR:/smppex_web -w /smppex_web $IMAGE_TAG /bin/bash build.sh $BRANCH

rm -rf $RELEASE_DIR/smppex_web.git
rm $RELEASE_DIR/prod.secret.exs
rm $RELEASE_DIR/build.sh


