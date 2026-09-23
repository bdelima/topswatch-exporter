# Builds topswatch (https://github.com/scottmbaker/topswatch) from source
# and publishes it as bdelima/topswatch-exporter. Upstream does not publish
# its own image (its README documents a local `make docker` + docker
# save/load workflow instead) — see README.md in this repo for the
# licensing note before assuming anything about redistribution terms.

FROM golang:1.25-bookworm AS build
WORKDIR /src
# Pin to a specific commit for reproducible builds — update deliberately,
# not automatically, so a build here always matches a known upstream state.
ARG TOPSWATCH_REF=master
RUN git clone https://github.com/scottmbaker/topswatch.git . \
    && git checkout "${TOPSWATCH_REF}"
RUN make build

FROM debian:bookworm-slim

ARG VERSION=unknown
ARG REVISION=unknown
LABEL org.opencontainers.image.source="https://github.com/scottmbaker/topswatch" \
      org.opencontainers.image.description="Container build of scottmbaker/topswatch (Intel NPU/GPU/CPU Prometheus exporter via PMT hardware registers). Not an official upstream image." \
      org.opencontainers.image.licenses="NOASSERTION" \
      org.opencontainers.image.url="https://github.com/bdelima/topswatch-exporter" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${REVISION}"
ENV APP_VERSION="${VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /src/topswatch /usr/local/bin/topswatch
EXPOSE 9876
ENTRYPOINT ["/usr/local/bin/topswatch"]
