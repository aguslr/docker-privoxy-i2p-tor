ARG BASE_IMAGE=alpine:latest

FROM docker.io/${BASE_IMAGE}

RUN \
  apk add --update --no-cache privoxy i2pd tor supervisor curl \
  && rm -rf /var/cache/apk/* && \
  (cd /etc/privoxy && for i in *.new; do mv "${i}" "${i%.*}"; done) && \
  mkdir -p /var/log/supervisord /var/run/supervisord /etc/supervisor.d

COPY config/privoxy.cfg /etc/privoxy/config
COPY config/i2pd.conf /etc/i2p/i2pd.conf
COPY config/torrc /etc/tor/torrc
COPY config/supervisord.conf /etc/supervisord.conf

EXPOSE 8118/tcp 4444/tcp 9050/tcp

HEALTHCHECK --interval=5m --timeout=5s \
  CMD timeout 2 curl -sfo /dev/null --proxy 127.0.0.1:8118 -L 'http://config.privoxy.org/'

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisord.conf"]
