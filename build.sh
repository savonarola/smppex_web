#!/bin/bash

BRANCH=$1

if [ "x$BRANCH" == "x" ]
then
    echo "Branch name not set"
    exit 1
fi

git clone -b $BRANCH --single-branch smppex_web.git /tmp/smppex_web
cp prod.secret.exs /tmp/smppex_web/config/prod.secret.exs

cd /tmp/smppex_web

mix deps.get --only prod
MIX_ENV=prod mix compile
npm install
node_modules/brunch/bin/brunch build --production
MIX_ENV=prod mix phoenix.digest

cd /tmp

tar czf smppex_web.tar.gz ./smppex_web --exclude=node_modules

cd /smppex_web

mv /tmp/smppex_web.tar.gz ./

