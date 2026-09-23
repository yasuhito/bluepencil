FROM public.ecr.aws/e1h7x4a2/plow-cloud-agents:base-7ce757a1745de286dd180c5c5182aca31eba8a75@sha256:6e5e1a11a8c6e2ef6ecaa5e7b429e778a9a3befaf416a09922aaaa4a5b21d647
ARG PLOW_REVISION
LABEL org.opencontainers.image.revision=$PLOW_REVISION co.plow.probe=/opt/bluepencil/probe
ENV AGENT_ID=bluepencil AGENT_NAME=bluepencil AGENT_BLURB="Drafts go in. Ship-ready text comes out, with every change explained."

USER root
COPY AGENTS.md SOUL.md IDENTITY.md USER.md /opt/bluepencil/
COPY voice/PROFILE.md /opt/bluepencil/voice/PROFILE.md
COPY shipped/LOG.md /opt/bluepencil/shipped/LOG.md
COPY skills/ /opt/plow/skills/
COPY cloud/start cloud/probe cloud/context.md /opt/bluepencil/
RUN sed -e 's|`SOUL.md`|`/opt/bluepencil/SOUL.md`|g' \
        -e 's|`IDENTITY.md`|`/opt/bluepencil/IDENTITY.md`|g' \
        /opt/bluepencil/AGENTS.md > /opt/plow/prompt/AGENTS.md \
 && cat /opt/bluepencil/USER.md /opt/bluepencil/context.md >> /opt/plow/prompt/AGENTS.md \
 && chmod 0755 /opt/bluepencil/start /opt/bluepencil/probe
USER node
CMD ["/opt/bluepencil/start", "node", "/opt/plow/boot/main.js"]
