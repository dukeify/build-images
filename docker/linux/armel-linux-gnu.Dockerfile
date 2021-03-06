from debian:sid-slim AS base

#Setup container to build image
RUN apt update -y
RUN apt install -y debootstrap
RUN dpkg --add-architecture armel

#Create armel image (Debian uses the convention "endian little" 
#instead of "little endian")
#This image supports ARMv4
WORKDIR /image
RUN debootstrap --arch=armel --variant=minbase sid .

FROM scratch AS armel-linux-gnu-debian
COPY --from=base /image /
RUN apt update -y
RUN apt install -y clang-11 cmake ninja-build automake autoconf libtool gettext libgtest-dev libbenchmark-dev libbenchmark1 
