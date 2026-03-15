# Test command — runs every minute. Press Ctrl+C to exit.
docker run --rm \
  -e CRON_SCHEDULE="* * * * *" \
  -e PMTILES_SOURCE_URL="https://raw.githubusercontent.com/traxeon/pmtiles-updater/630531226d8878880b724fa9b808eeaaeaf887fc/dc.pmtiles" \
  -e ARIA2C_LOG_LEVEL=notice \
  -v /tmp/pmtiles-test:/data \
  pmtiles-updater
