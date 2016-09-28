#!/bin/sh

set -e

BRANCH=$1
RELEASE=$2

if [ "x$BRANCH" == "x" ]
then
    BRANCH=master
    echo "Using default branch: $BRANCH"

fi

if [ "x$RELEASE" == "x" ]
then
    RELEASE=$(date "+%Y%m%d-%H%M%S")
    echo "Autogenerated release name: $RELEASE"
fi

RELEASE_DIR=releases/$RELEASE

if ! [ -d $RELEASE_DIR ]
then
    ./release.sh $RELEASE $BRANCH
fi

ansible-playbook -i deploy/hosts deploy/deploy.yml --extra-vars "local_release_dir=$RELEASE_DIR"
