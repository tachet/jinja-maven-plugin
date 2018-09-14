#!/bin/sh
echo "[CACHE] On arrete Spring boot"
kill -9 `cat /opt/cacheserver/app.pid`
