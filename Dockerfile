# claude-duet interview — CANDIDATE join client.
#
# A thin terminal client: no Claude, no API key, no host mounts. It only makes
# an OUTBOUND WebSocket connection to the host's tunnel/relay URL, so it works
# behind any NAT on any OS with Docker (Linux/macOS/Windows).
#
# Build:  docker build -t claude-duet-join .
# Run:    docker run -it --rm claude-duet-join <session-code> --password <pw> --url <ws-url>
#
# Builds the claude-duet fork that adds the shared filesystem panel, so the
# candidate sees the same live project tree + file viewer as the host.
# Override the source with --build-arg DUET_REPO=... --build-arg DUET_REF=...
FROM node:20-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
      git ca-certificates python3 make g++ cmake pkg-config \
 && rm -rf /var/lib/apt/lists/*

ARG DUET_REPO=https://github.com/swamirishi/claude-duet-fork.git
ARG DUET_REF=feat/filesystem-panel
ARG CACHE_BUST=1
RUN git clone --branch "$DUET_REF" --single-branch "$DUET_REPO" /opt/claude-duet \
 && cd /opt/claude-duet \
 && npm install \
 && npm run build

WORKDIR /opt/claude-duet
# Args after the image name are the join args (code / --password / --url).
ENTRYPOINT ["node", "/opt/claude-duet/dist/index.js", "join"]
