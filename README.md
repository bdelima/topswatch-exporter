# topswatch-exporter

A published, ready-to-run container build of [`topswatch`](https://github.com/scottmbaker/topswatch) by [scottmbaker](https://github.com/scottmbaker) — Intel NPU/GPU/CPU stats (tile config, per-domain power, temperature) read directly from PMT hardware registers, with a native Prometheus `/metrics` exporter mode.

**All the actual functionality here is upstream's work — this repo only adds a Dockerfile and a publish workflow.** See [`ATTRIBUTION.md`](ATTRIBUTION.md).

## Licensing note

`topswatch` upstream has **no stated open-source license** (no `LICENSE` file, no license badge) as of this repo's creation. Upstream's own README documents a local `make docker` build plus a `docker save`/`docker load` workflow for offline transfer — it does not publish its own image. This repo builds from upstream source and publishes the result to Docker Hub; it is **not an official image**, and the licensing terms for redistributing a build of this project are unclear since none are stated upstream. If you're the topswatch author and want this changed or taken down, please open an issue.

## Running it

```bash
docker run -d \
  --name topswatch-exporter \
  --restart unless-stopped \
  --privileged \
  --pid host \
  -v /sys:/sys:rw \
  -v /proc:/proc:ro \
  -p 9876:9876 \
  bdelima/topswatch-exporter:latest
```

See [`docker-compose.example.yml`](docker-compose.example.yml) for a Compose version. Port 9876 serves both the Prometheus `/metrics` endpoint and topswatch's own built-in web dashboard.

### Why these permissions

Per topswatch's own documented requirements:

| Setting | Why |
|---|---|
| `/sys:/sys:rw` | PMT telemetry needs *write* access to `/sys`, not just read |
| `/proc:/proc:ro` | process attribution |
| `--pid host` | process attribution across NPU/GPU/CPU |
| `--privileged` | `perf_event_open` + debugfs NPU firmware version access |

## Updating to a newer upstream commit

The Dockerfile pins upstream via a build arg (`TOPSWATCH_REF`, defaults to `master` — upstream's only branch). To rebuild against a specific upstream commit or tag:

```bash
docker build --build-arg TOPSWATCH_REF=<commit-or-tag> -t topswatch-exporter .
```

Bump `VERSION` and push to `main` to publish a new tag via the release workflow (`.github/workflows/docker-publish.yml`) to [`bdelima/topswatch-exporter`](https://hub.docker.com/r/bdelima/topswatch-exporter) (multi-arch: `linux/amd64`, `linux/arm64`).
