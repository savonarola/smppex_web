FROM elixir:1.11 AS build

MAINTAINER Ilya Averyanov <av@rubybox.dev>

ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs
RUN mix local.rebar --force
RUN mix local.hex --force

ENV MIX_ENV=prod

COPY . /app
WORKDIR /app

RUN rm -df deps
RUN mix deps.get --only prod
RUN mix compile
RUN npm install
RUN node_modules/esbuild/bin/esbuild web/static/js/app.js --bundle --loader:.js=jsx --loader:.eot=copy --loader:.svg=copy --loader:.ttf=copy --loader:.woff2=copy --loader:.woff=copy --outfile=priv/static/js/app.js
RUN mix phx.digest
RUN mix release main --overwrite

FROM ubuntu:focal AS app

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




