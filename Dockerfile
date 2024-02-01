ARG BASE_IMAGE=library/debian:stable-slim

FROM docker.io/${BASE_IMAGE}

RUN \
  apt-get update && \
  env DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends privoxy i2pd tor supervisor curl \
  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /var/lib/apt/lists/* && \
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
