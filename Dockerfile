FROM alpine:latest
RUN apk add --no-cache aria2 curl bash && \
    curl -fsSLo /usr/local/bin/supercronic \
      https://github.com/aptible/supercronic/releases/latest/download/supercronic-linux-amd64 && \
    chmod +x /usr/local/bin/supercronic
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENV PMTILES_URL=""
ENV PMTILES_OUTPUT="/data/world.pmtiles"
ENV CRON_SCHEDULE="0 3 * * 1"
ENV ARIA2C_CONNECTIONS=8
ENV ARIA2C_MAX_TRIES=5
ENV ARIA2C_RETRY_WAIT=60
ENTRYPOINT ["/entrypoint.sh"]
