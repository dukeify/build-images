from debian:sid-slim AS base

#Setup container to build image
RUN apt update -y
RUN apt install -y debootstrap
RUN dpkg --add-architecture armhf 

#Create armhf image
#This image supports ARMv7
WORKDIR /image
RUN debootstrap --arch=armhf --variant=minbase sid .

FROM scratch AS armhf-linux-gnu-debian
COPY --from=base /image /
RUN apt update -y
RUN apt install -y clang-11 cmake ninja-build automake autoconf libtool gettext libgtest-dev libbenchmark-dev libbenchmark1 
