FROM alpine:3.6
MAINTAINER James <c00lways@gmail.com>

RUN apk update \
  &&  apk add ca-certificates wget \
  && update-ca-certificates

# ==========================================
# ssh
# thanks to https://hub.docker.com/r/gotechnies/alpine-ssh
RUN apk --update add --no-cache bash vim curl\
  && rm -rf /var/cache/apk/*

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk update && \
    curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && \
    rm -rf /var/cache/apk/*

RUN adduser -h /home/app -D -s /bin/bash -g app,sudo app
RUN mkdir -p /home/app/web/log
RUN mkdir -p /home/app/.ssh
RUN touch /home/app/.ssh/authorized_keys
RUN chmod 600 /home/app/.ssh/authorized_keys
RUN chmod 700 /home/app/.ssh
RUN chown app:app -R /home/app

COPY entry.sh /home/app/
RUN chmod a+x /home/app/entry.sh

WORKDIR /home/app/web
ENTRYPOINT ["/home/app/entry.sh"]

ENV MIGRATE 1

VOLUME ["/home/app"]
EXPOSE 3000

