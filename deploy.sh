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

if ! [ -d $RELEASE_DIR ]
then
    ./release.sh $RELEASE $BRANCH
fi

ansible-playbook -i deploy/hosts deploy/deploy.yml --extra-vars "release_dir=$RELEASE_DIR"
