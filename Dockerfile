FROM ubuntu:xenial

MAINTAINER Ilya Averyanov <ilya@averyanov.org>

ENV ERLANG_VERSION=1:19.0-1
ENV ELIXIR_VERSION=v1.3.0
ENV LANG=en_US.UTF-8

RUN locale-gen $LANG

RUN apt-get update
RUN apt-get install -y curl git unzip make \
erlang-asn1 \
erlang-base \
erlang-crypto \
erlang-dev \
erlang-inets \
erlang-ssl


RUN curl -fSL -o elixir-precompiled.zip https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip

RUN unzip -d /usr/local elixir-precompiled.zip
RUN mix local.hex --force

