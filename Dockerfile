FROM alpine:3.6
MAINTAINER James <c00lways@gmail.com>

RUN apk update \
  &&  apk add ca-certificates wget \
  && update-ca-certificates

# ==========================================
# ssh
# thanks to https://hub.docker.com/r/gotechnies/alpine-ssh
RUN apk --update add --no-cache bash \
  && rm -rf /var/cache/apk/*

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

VOLUME ["/home/app"]
EXPOSE 3000

