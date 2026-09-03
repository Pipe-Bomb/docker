#!/bin/sh
set -e

mkdir -p /data /srv/api/resources /srv/api/audio-cache /srv/api/plugin-cache /srv/api/plugins /srv/api/temp /srv/api/.secrets

chown pipebomb:pipebomb /data /srv/api/resources /srv/api/audio-cache /srv/api/plugin-cache /srv/api/plugins /srv/api/temp /srv/api/.secrets
chmod 750 /data /srv/api/resources /srv/api/audio-cache
chmod 777 /srv/api/plugins /srv/api/plugin-cache /srv/api/temp
chmod 700 /srv/api/.secrets

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/pipe-bomb.conf
