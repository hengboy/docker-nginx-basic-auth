FROM nginx:alpine

ENV HTPASSWD='hengboy:$apr1$mFAvczmL$GG.LvNbebMDYp/kGGd3fg0' \
    FORWARD_PORT=80 \
    FORWARD_HOST=web \
    READ_TIMEOUT=5000

WORKDIR /opt

RUN apk add --no-cache gettext

COPY auth.conf auth.htpasswd launch.sh ./

# make sure root login is disabled
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow

CMD ["./launch.sh"]
