FROM ubuntu:latest AS base
ARG GLFW_BRANCH_TAG=3.4

RUN apt update \
    && DEBIAN_FRONTEND=nointeractive apt install -y --no-install-recommends libwayland-dev libxkbcommon-dev xorg-dev git gcc make cmake \
    && git config --global http.sslverify false \
    && git clone https://github.com/glfw/glfw.git --branch ${GLFW_BRANCH_TAG} --depth 1 glfw \
    && cmake -S glfw -B build -D GLFW_LIBRARY_TYPE=STATIC \
    && make -C build \
    && cmake -P build/cmake_install.cmake

FROM scratch AS final
COPY --from=base /usr/local/include/ /usr/local/include/
COPY --from=base /usr/local/lib/libglfw3.a /usr/local/lib/libglfw3.a 

FROM scratch AS export
COPY --from=base /usr/local/include/ /include/
COPY --from=base /usr/local/lib/libglfw3.a /lib/libglfw3.a