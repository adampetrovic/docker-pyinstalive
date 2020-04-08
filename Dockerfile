FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PYINSTALIVE_RELEASE=3.1.8
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="adam@petrovic.com.au"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_DATA_HOME="/config" \
XDG_CONFIG_HOME="/config"

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	jq \
	ffmpeg \
	libssl1.0 \
	python3 \
	python3-setuptools \
	wget && \
 echo "**** install pyinstalive ****" && \
 mkdir -p \
	/app/pyinstalive && \
 if [ -z ${PYINSTALIVE_RELEASE+x} ]; then \
	PYINSTALIVE_RELEASE=$(curl -sX GET "https://api.github.com/repos/dvingerh/PyInstaLive/releases/latest" \
	| jq -r .tag_name); \
 fi && \
 curl -o \
 /tmp/pyinstalive.tar.gz -L \
	"https://github.com/dvingerh/PyInstaLive/archive/${PYINSTALIVE_RELEASE}.tar.gz" && \
 tar xf \
 /tmp/pyinstalive.tar.gz -C \
	/app/pyinstalive --strip-components=1 && \
 cd /app/pyinstalive && \
 python3 setup.py install && \
 echo "**** fix for host id mapping error ****" && \
 chown -R root:root /app/pyinstalive && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/* \
	/app/pyinstalive

# add local files
COPY root/ /
# volumes
VOLUME /config /downloads
