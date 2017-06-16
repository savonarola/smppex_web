FROM ubuntu:xenial

MAINTAINER Ilya Averyanov <ilya@averyanov.org>

ENV LANG=en_US.UTF-8

RUN    apt-get update \
    && apt-get install -y wget locales \
    && locale-gen $LANG \
    && wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && apt-get update \
    && apt-get install -y curl git unzip make esl-erlang elixir npm nodejs-legacy \
    && mix local.hex --force \
    && mix local.rebar --force

