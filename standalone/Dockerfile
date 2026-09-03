ARG SERVER_TAG=latest
ARG FRONTEND_TAG=latest

FROM ghcr.io/pipe-bomb/server:${SERVER_TAG} AS server-stage
FROM ghcr.io/pipe-bomb/frontend:${FRONTEND_TAG} AS frontend-stage

FROM node:24-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
		ffmpeg git ca-certificates nginx supervisor \
	&& rm -rf /var/lib/apt/lists/*

RUN groupadd --system pipebomb \
	&& useradd --system --gid pipebomb --no-create-home pipebomb

COPY --from=server-stage --chown=pipebomb:pipebomb /app /srv/api
COPY --from=frontend-stage --chown=pipebomb:pipebomb /app /srv/frontend

RUN rm -f /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/sites-enabled/pipe-bomb.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY supervisord.conf /etc/supervisor/conf.d/pipe-bomb.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV NODE_ENV=production \
	DB_FILE=/data/pipe-bomb.sqlite \
	PLUGIN_DIRECTORY=/plugins \
	BASE_PATH=/api \
	CORS=""

VOLUME ["/data", "/srv/api/resources", "/srv/api/audio-cache", "/srv/api/plugin-cache", "/srv/api/plugins", "/srv/api/temp", "/srv/api/.secrets", "/music"]

EXPOSE 9193

ENTRYPOINT ["/entrypoint.sh"]
