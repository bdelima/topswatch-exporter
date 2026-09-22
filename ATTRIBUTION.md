# Attribution

This image is a container build of [`topswatch`](https://github.com/scottmbaker/topswatch) by [scottmbaker](https://github.com/scottmbaker) — all of the actual monitoring functionality (Intel NPU/GPU/CPU stats via PMT hardware registers, the Prometheus exporter, the web dashboard) is their work, not this repo's.

This repo adds nothing but a Dockerfile that builds topswatch from source and a GitHub Actions workflow that publishes the result to Docker Hub, since upstream doesn't publish its own image.

**Licensing:** topswatch has no stated open-source license as of this writing (no `LICENSE` file, no license badge on the repo). That means the usual terms an open-source license would spell out — redistribution, modification, sublicensing — simply aren't defined. This repo publishes a build anyway; see the note in [`README.md`](README.md). If you are the topswatch author and want this changed, taken down, or licensed properly, please open an issue on this repo.
