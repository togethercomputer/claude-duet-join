# claude-duet-join

Join a **claude-duet** interview session as the candidate — from any machine with **Docker** (Linux / macOS / Windows). No Node, no git-in-PATH gymnastics, no Claude account, no API key. The whole client runs in a container and only makes an **outbound** connection to the host's URL, so it works behind any NAT.

## Prerequisites

- **Docker** ([install](https://docs.docker.com/get-docker/)). Nothing else.

## Join in three steps

```bash
# 1. Get this repo
git clone https://github.com/togethercomputer/claude-duet-join.git
cd claude-duet-join

# 2. Build the client image (once, a few minutes)
docker build -t claude-duet-join .

# 3. Join — using the three values from the host's screen
docker run -it --rm claude-duet-join <session-code> --password <pw> --url <ws-url>
```

`<session-code>`, `<pw>`, and `<ws-url>` come from the **host's pinned banner**:

```
▶ share with candidate — code cd-xxxxxxxx   password xxxxxxxx   url wss://….trycloudflare.com
```

To reconnect after a network drop, just re-run the same `docker run` command.

## Using the session

- Plain text is **chat** between you and the host — Claude doesn't see it.
- `@claude <prompt>` sends to Claude; both of you see the streamed response.
- **`Tab`** cycles focus between the chat, the **file tree**, and the **file viewer** — so you can browse the project's live state.
- `↑ ↓` navigate the tree; **Enter** opens a file.

## Fresh Linux machine (one shot)

```bash
sudo apt-get update && sudo apt-get install -y git curl
curl -fsSL https://get.docker.com | sudo sh
git clone https://github.com/togethercomputer/claude-duet-join.git && cd claude-duet-join
sudo docker build -t claude-duet-join .
sudo docker run -it --rm claude-duet-join <session-code> --password <pw> --url <ws-url>
```

(Non-Debian distros: swap the package manager. To drop `sudo`, run `sudo usermod -aG docker $USER` once and start a new shell.)

## Notes

- The image builds the [claude-duet fork](https://github.com/swamirishi/claude-duet-fork/tree/feat/filesystem-panel) that adds the shared filesystem panel. Point elsewhere with `--build-arg DUET_REPO=… --build-arg DUET_REF=…`.
- Everything the candidate runs is confined to this container; nothing on your machine is shared with the host.
