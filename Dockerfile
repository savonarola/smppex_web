FROM ubuntu:xenial

MAINTAINER Ilya Averyanov <ilya@averyanov.org>

ENV LANG=en_US.UTF-8

RUN locale-gen $LANG \
    && apt-get update \
    && apt-get install -y wget \
    && wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && apt-get update \
    && apt-get install -y curl git unzip make erlang elixir npm nodejs-legacy \
    && mix local.hex --force \
    && mix local.rebar --force

