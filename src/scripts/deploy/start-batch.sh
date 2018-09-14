#!/bin/sh

echo "[BATCH] START BATCH FOR DEVELOP"

WHERE_TO_WORK="/usr/share/INTEG/flash-1.1/batch"

echo "[BATCH] $WHERE_TO_WORK"

cd $WHERE_TO_WORK

echo "[BATCH] Stop spring boot"
kill -9 `cat ./app.pid`
echo "[BATCH] Spring boot stopped"

# On démarre Batch
echo "[BATCH] Starting Spring boot..."
JAVA_OPTS="-Xmx2g -Xms1g -XX:-OmitStackTraceInFastThrow"
VMARGS="-Dlogging.file=./spring.log -Dspring.profiles.active=prod -Dspring.config.location=file:/usr/share/INTEG/flash-1.1/conf/sie-batch.properties"
nohup /usr/java/jdk1.8.0_65/bin/java $JAVA_OPTS -jar $VMARGS flash-batch.jar > /dev/null 2>&1 & echo $! >>./app.pid

