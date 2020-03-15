# docker-musl-cross

This repository contains a `Dockerfile` that builds an image with the
[musl-cross][1] toolchain installed.  I will attempt to keep the version
of musl up-to-date.

Building the container:
```
docker build .  -t eshornock/musl-cross:wheezy --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
```

[1]: https://github.com/GregorR/musl-cross
