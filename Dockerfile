FROM debian:stable-slim

ENV GRAFANA_VERSION 5.0.0

WORKDIR /tmp

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        curl \
        libfontconfig \
        wget \
        ca-certificates \
    && wget https://github.com/fg2it/grafana-on-raspberry/releases/download/v${GRAFANA_VERSION}/grafana_${GRAFANA_VERSION}_armhf.deb \
    && dpkg -i grafana_${GRAFANA_VERSION}_armhf.deb \
    && apt-get clean \
    && apt-get purge -y wget \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

USER grafana
VOLUME /var/lib/grafana /var/log/grafana /etc/grafana
EXPOSE 3000
HEALTHCHECK --interval=30s --retries=3 CMD curl --fail http://127.0.0.1:3000 || exit 1

ENTRYPOINT ["/usr/sbin/grafana-server"]
CMD ["--help"]
