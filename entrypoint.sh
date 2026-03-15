#!/usr/bin/env bash
set -e

# use busybox friendly date for yesterday - trax
if [ -z "$PMTILES_SOURCE_URL" ]; then
  PMTILES_SOURCE_URL="https://build.protomaps.com/$(date -d @$(($(date +%s) - 86400)) +%Y%m%d).pmtiles"
fi

PMTILES_OUTPUT="${PMTILES_DATA_PATH}/${PMTILES_FILENAME}"
TMP_OUTPUT="${PMTILES_OUTPUT}.tmp"

cat > /etc/crontab <<CRON
$CRON_SCHEDULE bash -c 'URL="\${PMTILES_SOURCE_URL:-https://build.protomaps.com/\$(date -d @\$((\$(date +%s) - 86400)) +%Y%m%d).pmtiles}"; aria2c -x $ARIA2C_CONNECTIONS -s $ARIA2C_CONNECTIONS -c --max-tries=$ARIA2C_MAX_TRIES --retry-wait=$ARIA2C_RETRY_WAIT --console-log-level=$ARIA2C_LOG_LEVEL "\$URL" -o "$TMP_OUTPUT" && mv "$TMP_OUTPUT" "$PMTILES_OUTPUT"'
CRON

echo "Starting pmtiles-updater"
echo "  Schedule:  $CRON_SCHEDULE"
echo "  URL:       $PMTILES_SOURCE_URL"
echo "  Output:    $PMTILES_OUTPUT"

echo "Validating URL..."
http_code=$(curl -s -o /dev/null -w "%{http_code}" --head "$PMTILES_SOURCE_URL") || true
if [ "$http_code" != "200" ]; then
  echo "ERROR: URL returned HTTP $http_code — check PMTILES_SOURCE_URL"
  exit 1
fi
echo "  URL OK (HTTP $http_code)"

exec supercronic /etc/crontab
