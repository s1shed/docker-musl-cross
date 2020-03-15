ARG IMAGE=eshornock/debian:wheezy
FROM $IMAGE AS base
LABEL maintainer Edward Shornock <ed.shornock@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

# Install build tools
RUN set -ex &&              \
    apt-get update &&       \
    apt-get upgrade -y &&   \
    apt-get install -y      \
    --no-install-recommends \
        autoconf            \
        automake            \
        bison               \
        ca-certificates     \
        curl                \
        fakeroot            \
        file                \
        flex                \
        git                 \
        libtool             \
        make                \
        pkg-config          \
        python              \
        texinfo             \
        vim-nox             \
        wget

FROM base AS build
# Install musl-cross
RUN set -ex &&                                                      \
    apt-get update &&                                               \
    apt-get install -y build-essential &&                           \
    mkdir /build &&                                                 \
    cd /build &&                                                    \
    git clone https://github.com/s1shed/musl-cross &&               \
    cd musl-cross &&                                                \
    echo 'GCC_BUILTIN_PREREQS=yes' >> config.sh &&                  \
    ./build.sh

FROM base
COPY --from=build /opt /opt
ARG BUILD_DATE=undefined
ENV BUILD_DATE=$BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="eshornock/musl-cross"
LABEL org.label-schema.description="Container with a musl-cross toolchain installed"
LABEL org.label-schema.vcs-url="https://github.com/s1shed/docker-musl-cross"
LABEL org.label-schema.docker.cmd="docker run --rm -it -v $(pwd):/output eshornock/musl-cross:wheezy"

ENV PATH=/opt/cross/x86_64-linux-musl/bin:/opt/cross/i486-linux-musl/bin:$PATH
CMD ["bash"]
