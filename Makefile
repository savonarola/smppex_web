MIX=mix
NPM=npm

clean:
	$(MIX) clean
	$(MIX) deps.clean --all

initial:
	$(MIX) deps.get --only prod
	MIX_ENV=prod $(MIX) compile

assets:
	$(NPM) install
	node_modules/brunch/bin/brunch build --production
	MIX_ENV=prod $(MIX) phoenix.digest

pack:
	tar czf --exclude node_modules --exclude project.tar.gz project.tar.gz .

release: clean initial assets pack


