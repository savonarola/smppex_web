FROM elixir:1.20 AS build

MAINTAINER Ilya Averyanov <av@rubybox.dev>

ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV MIX_ENV=prod

RUN apt-get update
RUN apt-get install -y nodejs npm
RUN mix local.rebar --force
RUN mix local.hex --force

COPY . /app
WORKDIR /app

RUN mix deps.get --only prod
RUN mix compile
RUN npm ci --prefix assets
RUN npm run build --prefix assets
RUN mix phx.digest
RUN mix release main --overwrite

FROM ubuntu:noble AS app

RUN apt-get update
RUN apt-get install -y openssl locales

ENV LANG=en_US.UTF-8
RUN locale-gen $LANG

COPY --from=build /app/_build/prod/rel/main /app

WORKDIR /app
ENV HOME=/app

EXPOSE 2775
EXPOSE 8080

CMD ["bin/main", "start"]
