FROM ubuntu:xenial

MAINTAINER Ilya Averyanov <ilya@averyanov.org>

ENV ERLANG_VERSION=1:19.0-1
ENV ELIXIR_VERSION=v1.3.0
ENV LANG=en_US.UTF-8

RUN locale-gen $LANG

RUN apt-get update
RUN apt-get install -y curl git unzip make

RUN apt-get install -y erlang-asn1
RUN apt-get install -y erlang-base
RUN apt-get install -y erlang-crypto
RUN apt-get install -y erlang-dev
RUN apt-get install -y erlang-inets
RUN apt-get install -y erlang-ssl
RUN apt-get install -y erlang-parsetools

RUN curl -fSL -o elixir-precompiled.zip https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip
RUN unzip -d /usr/local elixir-precompiled.zip
RUN mix local.hex --force
RUN mix local.rebar --force

RUN apt-get install -y npm

