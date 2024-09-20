FROM ubuntu:latest AS base
ARG WATCHEXEC_TARGET=https://github.com/watchexec/watchexec/releases/download/v2.1.2/watchexec-2.1.2-x86_64-unknown-linux-gnu.deb

RUN apt-get update \
    && DEBIAN_FRONTEND=nointeractive apt-get install -y --no-install-recommends git wget \
    && wget --no-check-certificate -O watchexec.deb ${WATCHEXEC_TARGET} \
    && dpkg -i watchexec.deb \
    && rm watchexec.deb

FROM scratch AS final    
# Found file locations through dpkg --contents watchexec.deb
COPY --from=base \
    /usr/share/bash-completion/completions/watchexec        \
    /usr/share/zsh/site-functions/_watchexec                \
    /usr/share/fish/vendor_completions.d/watchexec.fish     \
    /usr/share/man/man1/watchexec.1.gz                      \
    /usr/share/doc/watchexec/watchexec.1.md                 \
    /usr/bin/watchexec                                      \
    ./