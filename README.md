<h1>
    <img src="https://raw.githubusercontent.com/Pipe-Bomb/.github/refs/heads/master/assets/logos/Pipe%20Bomb%20no%20background%20w%20outline.png" width="40" />
    Pipe Bomb Docker
</h1>

Docker Compose setup for running [Pipe Bomb](https://github.com/Pipe-Bomb/server). Includes the API server, frontend, and an Nginx reverse proxy that ties them together under a single port.

## Getting Started

```bash
docker compose up -d
```

That's it. Pipe Bomb will be available on port 80.

## Configuration

All configuration is done through the `.env` file.

| Variable       | Default              | Description                                                                                         |
| :------------- | -------------------- | --------------------------------------------------------------------------------------------------- |
| `PUBLIC_URL`   | _(unset)_            | Only needed if CORS is causing issues. Set to the exact URL you use to access Pipe Bomb (e.g. `http://192.168.1.100`). |
| `HTTP_PORT`    | `80`                 | The port nginx listens on.                                                                          |
| `APPDATA_PATH` | `./data`             | Where Pipe Bomb stores its database, plugins, cache, and other persistent data.                     |
| `MUSIC_PATH`   | _(unset)_            | Path to a local music directory. See [Local Music Library](#local-music-library).                   |
| `COOKIE_DOMAIN`| _(unset)_            | Set to your hostname (e.g. `mynas.local`) if accessing via a domain so auth cookies scope correctly. |

## Data Storage

All persistent data lives under `APPDATA_PATH` (defaults to `./data`):

| Directory       | Persistent | Description                                                                                                                  |
| :-------------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `database`      | ✅         | The SQLite database. Contains all users, tracks, artists, albums, playlists, etc. Deleting this effectively resets the server. |
| `resources`     | ✅         | Stores buffer attribute data such as cover art. Clearing this causes all images to disappear until re-fetched.               |
| `cache`         | 🔶         | Caches processed audio streams. Safe to clear, but audio may be slower to serve until rebuilt.                               |
| `plugin-cache`  | 🔶         | Stores plugin-specific cached data (e.g. API responses). Safe to clear, but responses will be slower until warmed up again.  |
| `plugins`       | ✅         | Plugin code. Clearing this removes all installed plugins.                                                                    |
| `temp`          | ❌         | Temporary files used by plugins during processing. Cleared on server start — does not need to be persisted.                  |
| `secrets`       | ✅         | Sensitive files used by the server. Should not be cleared.                                                                   |

## Local Music Library

To expose a local music directory to Pipe Bomb, set `MUSIC_PATH` in your `.env` and uncomment the corresponding volume line in `docker-compose.yml`:

```yaml
# Bind-mount your music library for the local-library plugin:
- ${MUSIC_PATH:-/path/to/music}:/music:ro
```

The [Local Library plugin](https://github.com/Pipe-Bomb/local-library-plugin) will then be able to scan `/music` inside the container.

## Plugins

Plugins are placed in the `plugins` subdirectory of `APPDATA_PATH`. The easiest way to install them automatically is with the provided plugin installer override:

```bash
docker compose -f docker-compose.yml -f docker-compose.plugins.yml up -d
```

This runs a one-time installer that clones and builds the following plugins before the server starts:

| Plugin | Purpose |
| :--- | --- |
| [Local Library](https://github.com/Pipe-Bomb/local-library-plugin) | Scans a local directory for audio files |
| [Chromaprint](https://github.com/Pipe-Bomb/chromaprint-plugin) | Generates AcoustID fingerprints for track identification |
| [MusicBrainz](https://github.com/Pipe-Bomb/musicbrainz-plugin) | Retrieves track, artist & album metadata from MusicBrainz |
| [Discogs](https://github.com/Pipe-Bomb/discogs-plugin) | Retrieves artist metadata from Discogs |
| [Fanart.tv](https://github.com/Pipe-Bomb/fanart-tv-plugin) | Retrieves artist images from Fanart.tv |
| [Format](https://github.com/Pipe-Bomb/format-plugin) | Reads audio codec, bitrate, and sample rate using FFprobe |

Already-installed plugins are skipped on subsequent runs, so it's safe to always include the override.

To install additional plugins, you can either add them to a copy of `docker-compose.plugins.yml` or install them manually by cloning into `APPDATA_PATH/plugins` and running `npm ci && npm run build` inside.

The [Pipe Bomb Community](https://github.com/pipe-bomb-community) organisation maintains a [list of official and community plugins](https://github.com/Pipe-Bomb-Community#plugins).

## Unraid

A Compose Manager template is available at `unraid.xml`. You can submit it to [Community Apps](https://unraid.net/community/apps) or load it directly via the Compose Manager plugin.

## Credits & Contributing

Pipe Bomb is conceptualised and developed by [eyezah](https://github.com/eyezahhhh), but contributions are welcome!
