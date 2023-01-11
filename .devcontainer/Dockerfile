# syntax=docker/dockerfile-upstream:master-labs
FROM debian:stable-slim as hsl-builder

RUN apt update && \
    apt install -y build-essential gfortran git \
    libopenblas-serial-dev libtool wget metis pkg-config 

COPY . /src

WORKDIR /src

RUN ./configure --prefix=/build \
    --enable-static --disable-shared && \
    make && \
    make install

ENV PKG_CONFIG_PATH=/build/lib/pkgconfig

ADD https://github.com/coin-or-tools/ThirdParty-Mumps.git#stable/3.0 /mumps-src

WORKDIR /mumps-src

RUN ./get.Mumps && \
    OPENBLASFLAGS=$(pkg-config --libs --static openblas) \
    ./configure --prefix=/build \
    --with-lapack="-L/usr/lib/x86_64-linux-gnu/openblas-serial -l:libopenblas.a -lgfortran -lm" \
    --disable-pthread-mumps \
    --enable-static \
    --disable-shared \
    && make -j$(nproc) \
    && make test \
    && make install

ADD https://github.com/coin-or/Ipopt.git#stable/3.14 /ipopt-src

WORKDIR /ipopt-src


RUN ./configure --prefix=/build --disable-linear-solver-loader --disable-sipopt --disable-java --enable-static --disable-shared --with-hsl-cflags="$(pkg-config --cflags coinhsl)" --with-hsl-lflags="-L/build/lib -L/usr/lib/x86_64-linux-gnu/openblas-serial -l:libcoinhsl.a -l:libopenblas.a -lgfortran -lm" --with-mumps-cflags="$(pkg-config --cflags coinmumps)" --with-mumps-lflags="-L/build/lib -L/usr/lib/x86_64-linux-gnu/openblas-serial -l:libcoinmumps.a -l:libopenblas.a -lgfortran -lm" --with-lapack="-L/usr/lib/x86_64-linux-gnu/openblas-serial -l:libopenblas.a -lgfortran -lm" \
&& make -j$(nproc) \
&& make install

