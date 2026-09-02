#!/bin/sh
set -e

mkdir -p /data /resources /audio-cache /plugin-cache /plugins /temp /.secrets

chown pipebomb:pipebomb /data /resources /audio-cache /plugin-cache /plugins /temp /.secrets
chmod 750 /data /resources /audio-cache
chmod 777 /plugins /plugin-cache /temp
chmod 700 /.secrets

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/pipe-bomb.conf
