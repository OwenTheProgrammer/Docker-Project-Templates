ARG PROJECT_NAME=proj

# The ubuntu image creates a user "ubuntu" with gid=1000 uid=1000
FROM ubuntu:24.04 AS base

# Install required packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc gdb libc6-dev make

FROM base AS watchexec-build
ARG WATCHEXEC_TARGET="https://github.com/watchexec/watchexec/releases/download/v2.1.2/watchexec-2.1.2-x86_64-unknown-linux-gnu.deb"
RUN apt-get install -y --no-install-recommends wget ca-certificates \
    && wget -O /tmp/watchexec.deb ${WATCHEXEC_TARGET} \
    && dpkg -i /tmp/watchexec.deb

# For active development
FROM watchexec-build AS dev
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
ENTRYPOINT [ "/bin/bash" ]

# For compiling release binaries
FROM base AS build-release
ARG PROJECT_NAME
WORKDIR /${PROJECT_NAME}
COPY . .
RUN make release -j $(nproc) \
    && tar -czf ${PROJECT_NAME}.tar.gz bin include
ENTRYPOINT [ "/bin/bash" ]

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