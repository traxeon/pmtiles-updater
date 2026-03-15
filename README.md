# pmtiles-updater

A lightweight Docker container that downloads and keeps a [PMTiles](https://protomaps.com/docs/pmtiles) file up to date on a cron schedule.

## How it works

On startup, the container validates the source URL is reachable, then hands off to [supercronic](https://github.com/aptible/supercronic) which runs `aria2c` on the configured schedule. Downloads go to a `.tmp` file first and are atomically renamed into place on completion, so a tile server reading the file never sees a partially-written result. Interrupted downloads are resumed automatically on the next run via aria2c's `-c` flag.

## Usage

```bash
docker run -d \
  -e PMTILES_SOURCE_URL="https://build.protomaps.com/20260314.pmtiles" \
  -v /data/tiles:/data \
  pmtiles-updater
```

Mount a volume at `/data` to persist the downloaded file.

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `PMTILES_SOURCE_URL` | Yesterday's Protomaps planet build | URL to download the PMTiles file from |
| `PMTILES_DATA_PATH` | `/data` | Directory where the PMTiles file is stored. Mount a volume here. |
| `PMTILES_FILENAME` | `world.pmtiles` | Output filename for the downloaded PMTiles file |
| `CRON_SCHEDULE` | `0 3 * * 1` | Cron schedule for updates (every Monday at 3am by default) |
| `TZ` | `UTC` | Timezone for cron schedule interpretation |
| `ARIA2C_CONNECTIONS` | `8` | Number of parallel connections for aria2c |
| `ARIA2C_MAX_TRIES` | `5` | Maximum retry attempts on download failure |
| `ARIA2C_RETRY_WAIT` | `60` | Seconds to wait between retry attempts |
| `ARIA2C_LOG_LEVEL` | `notice` | aria2c log level (`debug`, `info`, `notice`, `warn`, `error`) |

## Timezone

The cron schedule is interpreted in the timezone set by `TZ`. For example, to run at 3am Eastern:

```bash
docker run -d \
  -e TZ=America/New_York \
  -e CRON_SCHEDULE="0 3 * * 1" \
  -v /data/tiles:/data \
  pmtiles-updater
```

## Default URL

If `PMTILES_SOURCE_URL` is not set, the container will attempt to download the previous day's [Protomaps](https://protomaps.com) planet build (~100GB). Set `PMTILES_SOURCE_URL` explicitly if you want a specific file or a different source.

The container will exit on startup with an error if the URL is not reachable.
