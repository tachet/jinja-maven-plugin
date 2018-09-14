#!/bin/sh

#Import commons functions
[ -f /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh ] && . /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters, Usage : deploy-batch.sh \"<version>\", exemple : deploy-batch.sh \"2.0.0-SNAPSHOT\" "
	exit 0
fi

echo "[FLASH ECM BATCH] Deploiement sur l'environnement d'integration"


WHERE_TO_WORK="/usr/share/INTEG/flash-1.1/batch"

echo "[FLASH ECM BATCH] on se positionne ici $WHERE_TO_WORK"

cd $WHERE_TO_WORK

echo "[FLASH ECM BATCH] On arrete Spring boot de l'integration"
sudo kill -9 `cat ./app.pid`
echo "[FLASH ECM BATCH] Spring boot stopped"
echo "[FLASH ECM BATCH] Clean ALL"
rm -rf *.jar


# Flash-BATCH-SOLR
echo "Downloading Flash-BATCH..."
downloadArtifactSnapShot "eu/els/sie/flash" "flash-ecm-batch" $1 "jar"
mv *.jar flash-batch.jar

#Used to manually deploy package.
#cp /usr/share/INTEG/flash-1.1/apps/flash-ecm-batch-$1.jar flash-batch.jar

# On démarre BATCH
#echo "[BATCH] Starting Spring boot..."
export CLASSPATH=./lib/*.jar
JAVA_OPTS=" -server -XX:MaxMetaspaceSize=1g -Xmx1g -Xms512m -XX:-OmitStackTraceInFastThrow"
VMARGS="-Dlogging.file=./spring.log -Dspring.profiles.active=prod -Dspring.config.location=file:/usr/share/INTEG/flash-1.1/conf/flash-ecm-batch.properties"
/usr/java/jdk1.8.0_65/bin/java $JAVA_OPTS -jar  $VMARGS flash-batch.jar > /dev/null 2>&1 & echo $! >>./app.pid
echo "Waiting 1 minute for application deployement ..."
sleep 1m


