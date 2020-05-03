all: push

build:
	docker build -t smppex_web .

tag: build
	docker tag smppex_web registry.rubybox.ru/smppex_web

push: tag
	docker push registry.rubybox.ru/smppex_web

run: build
	docker run -p 8080:8080 -p 2775:2775 --env-file config/docker.env smppex_web
