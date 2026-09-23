# Plow cloud image

This packages bluepencil's editing instructions and skills on Plow's OpenClaw
base. It uses the base gateway and automatic Agent Index reporter; the host-side
`tools/index-bridge` scripts are not installed or started in this image.

Build from the repository root for `linux/amd64`, then run the disposable probe:

```sh
docker build --platform linux/amd64 -f cloud/Dockerfile -t bluepencil:test .
docker run --rm --network none --entrypoint /opt/bluepencil/probe bluepencil:test
```

Build and push through `plow-agents` or your registry, then deploy the public
image by digest on a free test line:

```sh
plow-agents deploy REGISTRY/bluepencil@sha256:DIGEST --line LINE_UID
```

The image seeds a blank voice profile and shipped log only when absent. It keeps
the company voice, drafts and memory in `/var/lib/plow/workspace`, and the base
keeps Index registration state in `/var/lib/plow/.agent-index`. Mount persistent
storage at `/var/lib/plow` when running outside Plow cloud. Recreating the image
must retain that volume; do not copy one installation's registration to another.

Text an editing request, check the rewrite and saved draft, and confirm fresh
usage on the **bluepencil** Index installation. Repeat the reporting pass and
restart with the same volume to check that usage is not doubled and the install
identity stays the same. The offline probe checks packaging, seed preservation
and the base gateway; it does not establish live usage reporting.

This image supports Plow chat and optional Latch access. The Slack and
agent-to-agent configuration in the root README remains a separate self-hosted
setup. Bluepencil still drafts; a human publishes.
