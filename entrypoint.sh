#!/usr/bin/env bash
set -e

if [ -z "$PMTILES_URL" ]; then
  PMTILES_URL="https://build.protomaps.com/$(date -d yesterday +%Y%m%d).pmtiles"
fi

TMP_OUTPUT="${PMTILES_OUTPUT}.tmp"

cat > /etc/crontab <<CRON
$CRON_SCHEDULE aria2c -x $ARIA2C_CONNECTIONS -s $ARIA2C_CONNECTIONS -c --max-tries=$ARIA2C_MAX_TRIES --retry-wait=$ARIA2C_RETRY_WAIT "$PMTILES_URL" -o "$TMP_OUTPUT" && mv "$TMP_OUTPUT" "$PMTILES_OUTPUT"
CRON

echo "Starting pmtiles-updater"
echo "  Schedule:  $CRON_SCHEDULE"
echo "  URL:       $PMTILES_URL"
echo "  Output:    $PMTILES_OUTPUT"

exec supercronic /etc/crontab
