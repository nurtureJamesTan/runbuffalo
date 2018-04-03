FROM debian:stretch
MAINTAINER James <c00lways@gmail.com>

RUN apt-get update\
  &&  apt-get install -y ca-certificates wget \
  && update-ca-certificates

# ==========================================
# ssh
# thanks to https://hub.docker.com/r/gotechnies/alpine-ssh
RUN apt-get install -y vim curl cron

RUN useradd dummy1
RUN useradd dummy2
RUN useradd -u 1002 -d /home/app -s /bin/bash -G sudo app
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/app/web/log && mkdir -p /home/app/.ssh
RUN touch /home/app/.ssh/authorized_keys
RUN chmod 600 /home/app/.ssh/authorized_keys && chmod 700 /home/app/.ssh
#RUN chown app:app -R /home/app

COPY entry.sh /home/
RUN chmod a+x /home/entry.sh

WORKDIR /home/app/web
ENTRYPOINT ["/home/entry.sh"]

ENV MIGRATE 1
ENV CRON 0

VOLUME ["/home/app"]
EXPOSE 3000

