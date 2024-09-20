ARG PROJECT_NAME=proj

# The ubuntu image creates a user "ubuntu" with gid=1000 uid=1000
FROM ubuntu:latest AS base

# Install required packages
RUN apt-get update && DEBIAN_FRONTEND=nointeractive apt-get install -y --no-install-recommends gcc gdb libc6-dev make

FROM base AS install-watchexec
ARG WATCHEXEC_TARGET=https://github.com/watchexec/watchexec/releases/download/v2.1.2/watchexec-2.1.2-x86_64-unknown-linux-gnu.deb

# Install packages to download from github
RUN DEBIAN_FRONTEND=nointeractive apt-get install -y --no-install-recommends git wget \
# Download the target watchexec version from github (I dont know how to verify the certificate)
    && wget --no-check-certificate -O watchexec.deb ${WATCHEXEC_TARGET} \
# Unpack the deb file and install deps
    && dpkg -i watchexec.deb \
# Discard the package after installation
    && rm watchexec.deb

# For active development
FROM install-watchexec AS dev
# Change ownership of ubuntu home directory: root -> ubuntu
RUN chown ubuntu:ubuntu -R /home/ubuntu
WORKDIR /home/ubuntu
USER ubuntu
# CMD watchexec -w src -w include -w Makefile make debug
CMD ["watchexec", "-w", "src", "-w", "include", "-w", "Makefile", "make", "debug"]

# For shell development
FROM base AS dev-nowatch
# Change ownership of ubuntu home directory: root -> ubuntu
RUN chown ubuntu:ubuntu -R /home/ubuntu
WORKDIR /home/ubuntu
USER ubuntu
ENTRYPOINT [ "/bin/sh" ]

# For compiling release binaries
FROM base AS build-release
ARG PROJECT_NAME
WORKDIR /${PROJECT_NAME}
COPY Makefile .
COPY src ./src
COPY include ./include
RUN make release \
    && tar -czf ${PROJECT_NAME}.tar.gz bin include
ENTRYPOINT [ "/bin/sh" ]

# For using in another docker image
FROM scratch AS build-scratch
ARG PROJECT_NAME
WORKDIR /${PROJECT_NAME}
COPY --from=build-release /${PROJECT_NAME}/include ./include/
COPY --from=build-release /${PROJECT_NAME}/bin ./bin/

# For exporting the whole project
FROM scratch AS bundle-scratch
ARG PROJECT_NAME
COPY --from=build-release /${PROJECT_NAME}/${PROJECT_NAME}.tar.gz .