FROM debian:stable-slim as builder

RUN apt update && \
    apt install -y build-essential gfortran

COPY . /src

WORKDIR /src

RUN ./configure --prefix=/build && \
    make && \
    make install
