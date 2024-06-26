FROM ubuntu:22.04
LABEL MAINTAINER="ValentinGrim"
LABEL CREATOR="ValentinGrim"
LABEL GITHUB="https://github.com/ValentinGrim/deluge-cyberghostvpn"
LABEL FORK="https://github.com/tmcphee/cyberghostvpn"
# LABEL DOCKER="https://hub.docker.com/r/tmcphee/cyberghostvpn"

ENV cyberghost_version=1.4.1
ENV linux_version=22.04
ENV script_version=2.0

ARG DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC

#RUN yes | unminimize

RUN apt-get update -y
RUN apt-get install software-properties-common -y
# Get latest version of deluged
RUN add-apt-repository ppa:deluge-team/stable && apt-get update
RUN apt-get install -y \
	sudo \
	wget \
	unzip \
	iproute2 \
	openresolv \
	expect \
	iputils-ping \
	curl \
	lsb-release \
	geoip-database \
	libgeoip-dev \
	deluged \
	deluge-web

RUN apt-get update -y && \
	apt-get autoremove -y && \
	apt-get autoclean -y

#Download, prepare and install CyberGhost CLI [COPY - CACHED VERSION]
#RUN wget https://download.cyberghostvpn.com/linux/cyberghostvpn-ubuntu-$linux_version-$cyberghost_version.zip -O cyberghostvpn_ubuntu.zip -U="Mozilla/5.0" && \
COPY ver/cyberghostvpn-ubuntu-$linux_version-$cyberghost_version.zip ./
RUN mv cyberghostvpn-ubuntu-$linux_version-$cyberghost_version.zip cyberghostvpn_ubuntu.zip && \
	unzip cyberghostvpn_ubuntu.zip && \
	mv cyberghostvpn-ubuntu-$linux_version-$cyberghost_version/* . && \
	rm -r cyberghostvpn-ubuntu-$linux_version-$cyberghost_version  && \
	rm cyberghostvpn_ubuntu.zip && \
	sed -i 's/cyberghostvpn --setup/#cyberghostvpn --setup/g' install.sh && \
	bash install.sh

COPY start.sh auth.sh /
RUN chmod +x /start.sh && \
	chmod +x /auth.sh

COPY core.conf /opt/default/core.conf

CMD ["bash", "/start.sh"]
