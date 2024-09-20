FROM alpine:latest AS base
ARG GLFW_BRANCH_TAG=3.4

RUN apk add --no-cache \
    libx11-dev libxi-dev libxcursor-dev libxrandr-dev libxkbcommon-dev libxinerama-dev \
    linux-headers musl-dev wayland-dev mesa-dev \
    pkgconf cmake git gcc make \
    && git config --global http.sslverify false \
    && git clone https://github.com/glfw/glfw.git --branch ${GLFW_BRANCH_TAG} --depth 1 glfw \
    && cmake -S glfw -B build -D GLFW_LIBRARY_TYPE=STATIC \
    && make -C build \
    && cmake -P build/cmake_install.cmake

FROM scratch AS final
COPY --from=base                \
    /usr/local/lib/libglfw3.a   \
    /usr/local/include/GLFW     \
    ./
