FROM i386/ubuntu:18.04
MAINTAINER Sugeng Tigefa <tigefa@gmail.com>

COPY . /bd_build

RUN /bd_build/prepare.sh && \
	/bd_build/system_services.sh && \
	/bd_build/utilities.sh && \
	/bd_build/cleanup.sh

ENV DEBIAN_FRONTEND="teletype" \
    LANG="id_ID.UTF-8" \
    LANGUAGE="id_ID:id" \
    LC_ALL="id_ID.UTF-8"

CMD ["/sbin/my_init"]
