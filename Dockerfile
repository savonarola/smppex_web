FROM ubuntu:xenial

MAINTAINER Ilya Averyanov <ilya@averyanov.org>

ENV LANG=en_US.UTF-8

RUN apt-get update
RUN apt-get install -y wget locales
RUN locale-gen $LANG
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install -y curl git unzip make npm nodejs-legacy
RUN apt-get install -y esl-erlang=1:19.3
RUN apt-get install -y elixir=1.4.4-1
RUN mix local.rebar --force
RUN mix local.hex --force

