FROM alpine:3.7

ARG VERSION=0.4.0

LABEL maintainer="github@jforge.de" \
    license="MIT" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="jforge" \
    org.label-schema.name="bats" \
    org.label-schema.version="${VERSION}" \
    org.label-schema.description="alpine image for testing with bats" \
    org.label-schema.vcs-url="https://github.com/jforge/docker-bats" \
    org.label-schema.docker.cmd="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/app jforge/bats"

RUN apk add --no-cache --update bash curl docker make jq git bc && \
      curl -o "/tmp/v${VERSION}.tar.gz" -L "https://github.com/sstephenson/bats/archive/v${VERSION}.tar.gz" && \
      tar -x -z -f "/tmp/v${VERSION}.tar.gz" -C /tmp/ && \
      bash "/tmp/bats-${VERSION}/install.sh" /usr/local && \
      rm -rf /tmp/*

VOLUME /app
WORKDIR /app

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

ENTRYPOINT ["/usr/local/bin/bats"]
CMD ["-h"]
