#!/bin/sh

#Import commons functions
[ -f /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh ] && . /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters, Usage : deploy-async.sh \"<version>\", exemple : deploy-async.sh \"2.0.0-SNAPSHOT\" "
	exit 0
fi

echo "[FLASH ECM ASYNC] Deploiement sur l'environnement d'integration"


WHERE_TO_WORK="/usr/share/INTEG/flash-1.1/async"


cd $WHERE_TO_WORK

echo "[ASYNC] On arrete Spring boot de l'integration"
kill -9 `cat ./app.pid`
echo "[FLASH ECM ASYNC] Spring boot stopped"
echo "[FLASH ECM ASYNC] Clean ALL"
rm -rf *


# Flash-ASYNC
echo "Downloading Flash-ASYNC..."
downloadArtifactSnapShot "eu/els/sie/flash" "flash-ecm-async" $1 "jar"
mv *.jar async.jar

#Used to manually deploy package.
#cp /usr/share/INTEG/flash-1.1/apps/flash-ecm-async-$1.jar async.jar


# On démarre ASYNC
echo "[ASYNC] Starting Spring boot..."
JAVA_OPTS=" -server -XX:MaxMetaspaceSize=1g -Xmx1g -Xms512m -XX:-OmitStackTraceInFastThrow"
VMARGS="-Dlogging.file=./spring.log -Dspring.profiles.active=prod -Dspring.config.location=file:/usr/share/INTEG/flash-1.1/conf/flash-ecm-async.properties"
nohup /usr/java/jdk1.8.0_65/bin/java $JAVA_OPTS -jar $VMARGS async.jar > /dev/null 2>&1 & echo $! >>./app.pid
echo "Waiting 1 minute for application deployement ..."
sleep 1m