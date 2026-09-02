<h1>
    <img src="https://raw.githubusercontent.com/Pipe-Bomb/.github/refs/heads/master/assets/logos/Pipe%20Bomb%20no%20background%20w%20outline.png" width="40" />
    Pipe Bomb Docker
</h1>

Docker Compose setup for running [Pipe Bomb](https://github.com/Pipe-Bomb/server). Includes the API server, frontend, and an Nginx reverse proxy that ties them together under a single port.

## Getting Started

### Docker Compose (recommended)

Suitable for Linux servers or any platform with Docker Compose support.

Download [docker-compose.yml](https://raw.githubusercontent.com/Pipe-Bomb/docker/master/docker-compose.yml):

```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/Pipe-Bomb/docker/master/docker-compose.yml
```

And run it!

```bash
docker compose up -d
```

That's it. Pipe Bomb will be available by default on port 9193. You can configure Pipe Bomb under Docker Compose using the following environment variables:

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

### Single container

Suitable for Unraid, Portainer, and platforms without Docker Compose support.

```bash
docker run -d \
  --name pipe-bomb \
  -p 9193:80 \
  -v /path/to/data:/data \
  -v /path/to/resources:/resources \
  -v /path/to/cache:/audio-cache \
  -v /path/to/plugin-cache:/plugin-cache \
  -v /path/to/plugins:/plugins \
  -v /path/to/temp:/temp \
  -v /path/to/music:/music:ro \
  ghcr.io/pipe-bomb/pipe-bomb:latest
```

## Data Storage

Each volume path can be configured independently regardless of how you install your Pipe Bomb. Here's what each one stores:

| Volume         | Persistent | Description                                                                                                                    |
| :------------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `data`         | ✅         | The SQLite database. Contains all users, tracks, artists, albums, playlists, etc. Deleting this effectively resets the server. |
| `resources`    | ✅         | Stores buffer attribute data such as cover art. Clearing this causes all images to disappear until re-fetched.                 |
| `audio-cache`  | 🔶         | Caches processed audio streams. Safe to clear, but audio may be slower to serve until rebuilt.                                 |
| `plugin-cache` | 🔶         | Stores plugin-specific cached data (e.g. API responses). Safe to clear, but responses will be slower until warmed up again.    |
| `plugins`      | ✅         | Plugin code. Clearing this removes all installed plugins.                                                                      |
| `temp`         | ❌         | Temporary files used by plugins during processing. Cleared on server start - does not need to be persisted.                    |
| `secrets`      | ✅         | Sensitive files used by the server. Should not be cleared.                                                                     |
| `music`        | ✅         | Example volume for passing through local music files. Should not be cleared.                                                   |

## Local Music Library

To expose a local music directory to Pipe Bomb, set `MUSIC_PATH` in your `.env` to the path of your music folder. The [Local Library plugin](https://github.com/Pipe-Bomb/local-library-plugin) will then be able to scan `/music` inside the container.

## Credits & Contributing

Pipe Bomb is conceptualised and developed by [eyezah](https://github.com/eyezahhhh), but contributions are welcome!
