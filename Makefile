all: push

build:
	docker build -t smppex_web .

tag: build
	docker tag smppex_web cr.yandex/crpj428ot3ll9595ju8d/smppex_web

push: tag
	docker push cr.yandex/crpj428ot3ll9595ju8d/smppex_web

run: build
	docker run -p 8080:8080 -p 2775:2775 --env-file config/docker.env smppex_web
