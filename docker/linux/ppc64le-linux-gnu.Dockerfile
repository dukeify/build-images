from debian:sid-slim AS base

#Setup container to build image
RUN apt update -y
RUN apt install -y debootstrap
RUN dpkg --add-architecture ppc64el

#Create ppc64le image (Debian uses the convention "endian little" 
#instead of "little endian")
WORKDIR /image
RUN debootstrap --arch=ppc64el --variant=minbase sid .

FROM scratch AS ppc64le-linux-gnu-debian
COPY --from=base /image /
RUN apt update -y
RUN apt install -y clang-11 cmake ninja-build automake autoconf libtool gettext libgtest-dev libbenchmark-dev libbenchmark1 
