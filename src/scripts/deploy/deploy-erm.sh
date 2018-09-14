#!/bin/sh

#Import commons functions
[ -f /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh ] && . /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters, Usage : deploy-erm.sh \"<version>\", exemple : deploy-erm.sh \"2.0.0-SNAPSHOT\" "
	exit 0
fi

echo "[FLASH ERM] Deploiement sur l'environnement d'integration"


WHERE_TO_WORK="/usr/share/INTEG/flash-1.1/erm"
echo "[FLASH ERM] on se positionne ici $WHERE_TO_WORK"

cd $WHERE_TO_WORK

# echo "[FLASH ERM] On arrete Spring boot de l'integration"
kill -9 `cat ./app.pid`
echo "[FLASH ERM] Spring boot stopped"
echo "[FLASH ERM] Clean files"
rm -rf app.pid
rm -rf spring.log*
rm -rf *.jar

echo "Downloading erm with version $1"
downloadArtifactSnapShot "eu/els/sie/flash" "flash-erm" $1 "jar"
mv *.jar erm.jar

#Used to manually deploy package.
#cp /usr/share/INTEG/flash-1.1/apps/flash-erm-$1.jar erm.jar

# On démarre FLASH ERM
JAVA_OPTS=" -server -XX:MaxMetaspaceSize=2g -Xmx2g -Xms512m -XX:-OmitStackTraceInFastThrow"

VMARGS="-Dlogging.file=./spring.log -Dspring.profiles.active=prod -Dspring.config.location=file:/usr/share/INTEG/flash-1.1/conf/flash-erm.properties"
nohup /usr/java/jdk1.8.0_65/bin/java $JAVA_OPTS -jar $VMARGS erm.jar > /dev/null 2>&1 & echo $! >>./app.pid
echo "[FLASH ERM] Starting Spring boot..."
echo "Waiting 1 minute for application deployement ..."
sleep 1m




