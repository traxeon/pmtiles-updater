FROM alpine:latest

# Install aria2 for downloading and supercronic for container-friendly cron scheduling
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache aria2 bash supercronic tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# URL to download PMTiles from. Defaults to latest Protomaps planet build if unset.
ENV PMTILES_SOURCE_URL=""

# Directory where the PMTiles file will be stored. Mount a volume here.
ENV PMTILES_DATA_PATH="/data"

# Output filename for the downloaded PMTiles file.
ENV PMTILES_FILENAME="world.pmtiles"

# Timezone for cron schedule interpretation. Defaults to UTC.
ENV TZ="UTC"

# Cron schedule for updates. Default: every Monday at 3am local time.
ENV CRON_SCHEDULE="0 3 * * 1"

# Number of parallel connections for aria2c download.
ENV ARIA2C_CONNECTIONS=8

# Maximum number of retry attempts on download failure.
ENV ARIA2C_MAX_TRIES=5

# Seconds to wait between retry attempts.
ENV ARIA2C_RETRY_WAIT=60

ENTRYPOINT ["/entrypoint.sh"]