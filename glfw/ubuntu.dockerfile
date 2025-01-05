FROM ubuntu:24.04 AS base
ARG BRANCH_TAG=3.4

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		gcc make cmake git ca-certificates libwayland-dev libxkbcommon-dev xorg-dev \
	&& git clone https://github.com/glfw/glfw.git --branch ${BRANCH_TAG} --depth 1 /tmp/glfw/ \
	&& cmake -S /tmp/glfw/ -B /tmp/build/ -D GLFW_LIBRARY_TYPE=STATIC -D GLFW_BUILD_EXAMPLES=OFF -D GLFW_BUILD_DOCS=OFF \
	&& make -C /tmp/build/ \
	&& cmake -P /tmp/build/cmake_install.cmake

FROM scratch AS final
COPY --from=base /usr/local/include/ /usr/local/include/
COPY --from=base /usr/local/lib/libglfw3.a /usr/local/lib/libglfw3.a

FROM scratch AS export
COPY --from=base /usr/local/include/ /include/
COPY --from=base /usr/local/lib/libglfw3.a /lib/libglfw3.a