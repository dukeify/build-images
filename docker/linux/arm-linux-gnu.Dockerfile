from debian:sid-slim AS base

#Setup container to build image
RUN apt update -y
RUN apt install -y debootstrap
RUN dpkg --add-architecture arm 

#Create arm root
WORKDIR /image
RUN debootstrap --arch=armel --variant=minbase sid .

FROM scratch AS arm-linux-gnu-debian 
COPY --from=base /image /
RUN apt update -y
RUN apt install -y clang-10 cmake ninja-build automake autoconf libtool texinfo gettext libgtest-dev libbenchmark-dev libbenchmark1
