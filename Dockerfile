FROM phusion/baseimage
MAINTAINER Brandon Matthews <bmatt@luciddg.com>

RUN apt-get update && \
    apt-get install -y --force-yes \
      freeradius \
      freeradius-ldap
RUN mkdir /var/run/freeradius/
RUN chown freerad:freerad /var/run/freeradius

RUN mkdir -p /etc/service/freeradius
ADD freeradius-wrapper.sh /etc/service/freeradius/run

# Work around for AUFS bug
# as per https://github.com/docker/docker/issues/783#issuecomment-56013588
RUN mkdir /etc/ssl/private-copy && \
 mv /etc/ssl/private/* /etc/ssl/private-copy/ && \
 rm -r /etc/ssl/private && \
 mv /etc/ssl/private-copy /etc/ssl/private && \
 chmod 0710 /etc/ssl/private  && \
 chmod 0640 /etc/ssl/private/*  && \
 chgrp -R ssl-cert /etc/ssl/private

EXPOSE 1812/udp 1813/udp 1814/udp
