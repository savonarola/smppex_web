FROM ubuntu:xenial AS build

MAINTAINER Ilya Averyanov <ilya@averyanov.org>

ENV LANG=en_US.UTF-8

RUN apt-get update
RUN apt-get install -y wget locales
RUN locale-gen $LANG
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install -y curl git unzip make
RUN apt-get install -y esl-erlang=1:22.3.3-1
RUN apt-get install -y elixir=1.10.3-1
RUN mix local.rebar --force
RUN mix local.hex --force

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs

ENV MIX_ENV=prod

COPY . /app
WORKDIR /app

RUN mix deps.get --only prod
RUN mix compile
RUN npm install
RUN node_modules/brunch/bin/brunch build --production
RUN mix phx.digest
RUN mix release main --overwrite

FROM ubuntu:xenial AS app

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




