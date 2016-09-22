MIX=mix
BRUNCH=brunch

clean:
	$(MIX) clean
	$(MIX) deps.clean --all

initial:
	$(MIX) deps.get --only prod
	MIX_ENV=prod $(MIX) compile

assets:
	$(BRUNCH) build --production
	MIX_ENV=prod $(MIX) phoenix.digest

pack:
	tar czf --exclude node_modules project.tar.gz .

release: clean initial assets pack


