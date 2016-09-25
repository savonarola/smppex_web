#!/bin/bash
git clone smppex_web.git /tmp/smppex_web
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

