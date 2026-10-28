# docker-eth-nethermind
Ethereum (Nethermind) Docker container Docker Nethermind container from the primary repository https://github.com/NethermindEth/nethermind

Created with the intention to use a github pipeline to test syncing and possible consensus bugs after a new client release occurs.

The image packages the official `linux-arm64` release zip and is published as a `linux/arm64` image.

## Updating to a new Nethermind release

Edit the three `ARG`s at the top of the `Dockerfile` using the values on the release page
(`https://github.com/NethermindEth/nethermind/releases/tag/<version>`):

- `VERSION`: the release tag, e.g. `2.2.2`
- `COMMIT`: the short commit hash in the asset name `nethermind-<version>-<commit>-linux-arm64.zip`
- `SHA256`: the sha256 digest GitHub shows next to that asset

BuildKit verifies the download against `SHA256` and fails the build if it doesn't match.
