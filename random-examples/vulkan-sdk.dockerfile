FROM ubuntu:24.04 AS base

# == INSTALL THE VULKAN SDK WITH UPDATED KEYRING SIGNING ==
RUN apt-get update \
	&& apt-get install -y --no-install-recommends wget ca-certificates \
	&& wget -O /usr/share/keyrings/lunarg-vk.asc "https://packages.lunarg.com/lunarg-signing-key-pub.asc" \
	&& echo "deb [signed-by=/usr/share/keyrings/lunarg-vk.asc] https://packages.lunarg.com/vulkan noble main" > /etc/apt/sources.list.d/lunarg-vk.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends vulkan-sdk libvulkan-dev