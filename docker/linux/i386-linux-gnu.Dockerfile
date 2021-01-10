from debian:sid-slim AS base

#Setup container to build image
RUN apt update -y
RUN apt install -y debootstrap
RUN dpkg --add-architecture i386 

#Create i386 root
WORKDIR /image
RUN debootstrap --arch=i386 --variant=minbase sid .

FROM scratch AS i386-linux-gnu-debian
COPY --from=base /image /
RUN apt update -y
RUN apt install -y clang-11 cmake ninja-build automake autoconf libtool texinfo libgtest-dev libbenchmark-dev libbenchmark1
