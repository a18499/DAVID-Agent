FROM debian:unstable 


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y openjdk-8-jre-headless



#Falco
ENV FALCO_REPOSITORY stable

LABEL RUN="docker run -i -t -v /var/run/docker.sock:/host/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro -v /boot:/host/boot:ro -v /lib/modules:/host/lib/modules:ro -v /usr:/host/usr:ro --name NAME IMAGE"

ENV SYSDIG_HOST_ROOT /host

ENV HOME /root

RUN cp /etc/skel/.bashrc /root && cp /etc/skel/.profile /root

ADD http://download.draios.com/apt-draios-priority /etc/apt/preferences.d/

RUN echo "deb http://httpredir.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
	bash-completion \
	curl \
	jq \
	ca-certificates \
	gnupg2 \
	gcc \
	gcc-5 \
	gcc-4.9 && rm -rf /var/lib/apt/lists/*

# Since our base Debian image ships with GCC 5.0 which breaks older kernels, revert the
# default to gcc-4.9. Also, since some customers use some very old distributions whose kernel
# makefile is hardcoded for gcc-4.6 or so (e.g. Debian Wheezy), we pretend to have gcc 4.6/4.7
# by symlinking it to 4.9

RUN rm -rf /usr/bin/gcc \
 && ln -s /usr/bin/gcc-4.9 /usr/bin/gcc \
 && ln -s /usr/bin/gcc-4.9 /usr/bin/gcc-4.8 \
 && ln -s /usr/bin/gcc-4.9 /usr/bin/gcc-4.7 \
 && ln -s /usr/bin/gcc-4.9 /usr/bin/gcc-4.6

RUN curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | apt-key add - \
 && curl -s -o /etc/apt/sources.list.d/draios.list http://download.draios.com/$FALCO_REPOSITORY/deb/draios.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends falco \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN ln -s $SYSDIG_HOST_ROOT/lib/modules /lib/modules


RUN mkdir -p /home/Config
RUN mkdir -p /home/DataLog
COPY ./docker-entrypoint.sh / 
COPY ./DockerLogger-1.0-SNAPSHOT.jar /home/ 
COPY ./falco_rules.yaml /etc/ 
COPY ./Config/ /home/Config/

ENTRYPOINT ["/docker-entrypoint.sh"]
WORKDIR /home/

