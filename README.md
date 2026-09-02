<h1>
    <img src="https://raw.githubusercontent.com/Pipe-Bomb/.github/refs/heads/master/assets/logos/Pipe%20Bomb%20no%20background%20w%20outline.png" width="40" />
    Pipe Bomb Docker
</h1>

Docker Compose setup for running [Pipe Bomb](https://github.com/Pipe-Bomb/server). Includes the API server, frontend, and an Nginx reverse proxy that ties them together under a single port.

## Getting Started

```bash
docker compose up -d
```

That's it. Pipe Bomb will be available on port 9193.

## Configuration

All configuration is done through the `.env` file.

| Variable            | Default               | Description                                                                                                            |
| :------------------ | --------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `PUBLIC_URL`        | _(unset)_             | Only needed if CORS is causing issues. Set to the exact URL you use to access Pipe Bomb (e.g. `http://192.168.1.100`). |
| `HTTP_PORT`         | `9193`                | The port nginx listens on.                                                                                             |
| `DATA_PATH`         | `./data/data`         | Where Pipe Bomb stores its database and core data.                                                                     |
| `RESOURCES_PATH`    | `./data/resources`    | Where Pipe Bomb stores resources such as cover art and thumbnails.                                                     |
| `AUDIO_CACHE_PATH`  | `./data/cache`        | Where Pipe Bomb caches audio streams. Safe to clear; audio will be slower to serve until rebuilt.                      |
| `PLUGIN_CACHE_PATH` | `./data/plugin-cache` | Where Pipe Bomb stores plugin-specific cached data. Safe to clear.                                                     |
| `PLUGINS_PATH`      | `./data/plugins`      | Where Pipe Bomb loads plugins from.                                                                                    |
| `TEMP_PATH`         | `./data/temp`         | Temporary files used during processing. Does not need to be persisted.                                                 |
| `SECRETS_PATH`      | `./data/secrets`      | JWT signing key and other secrets. Must be kept on persistent storage.                                                 |
| `MUSIC_PATH`        | `./data/music`        | Path to a local music directory. See [Local Music Library](#local-music-library).                                      |

## Data Storage

Each data path can be configured independently via the variables above. Here's what each one stores:

| Variable            | Persistent | Description                                                                                                                    |
| :------------------ | ---------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `DATA_PATH`         | ✅         | The SQLite database. Contains all users, tracks, artists, albums, playlists, etc. Deleting this effectively resets the server. |
| `RESOURCES_PATH`    | ✅         | Stores buffer attribute data such as cover art. Clearing this causes all images to disappear until re-fetched.                 |
| `AUDIO_CACHE_PATH`  | 🔶         | Caches processed audio streams. Safe to clear, but audio may be slower to serve until rebuilt.                                 |
| `PLUGIN_CACHE_PATH` | 🔶         | Stores plugin-specific cached data (e.g. API responses). Safe to clear, but responses will be slower until warmed up again.    |
| `PLUGINS_PATH`      | ✅         | Plugin code. Clearing this removes all installed plugins.                                                                      |
| `TEMP_PATH`         | ❌         | Temporary files used by plugins during processing. Cleared on server start - does not need to be persisted.                    |
| `SECRETS_PATH`      | ✅         | Sensitive files used by the server. Should not be cleared.                                                                     |

## Local Music Library

To expose a local music directory to Pipe Bomb, set `MUSIC_PATH` in your `.env` to the path of your music folder. The [Local Library plugin](https://github.com/Pipe-Bomb/local-library-plugin) will then be able to scan `/music` inside the container.

## Credits & Contributing

Pipe Bomb is conceptualised and developed by [eyezah](https://github.com/eyezahhhh), but contributions are welcome!
