#!/bin/sh


#Import commons functions
[ -f /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh ] && . /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters, Usage : deploy-cache.sh \"<version>\", exemple : deploy-cache.sh \"2.0.0-SNAPSHOT\" "
	exit 0
fi


echo "[CACHE] Deploiement sur l'environnement d'integration"


WHERE_TO_WORK="/var/tmp"
CACHE="cache"
cd $WHERE_TO_WORK
echo "Create temp directory $CACHE"
mkdir $CACHE
echo "[CACHE] on se positionne ici $WHERE_TO_WORK/$CACHE"
cd $CACHE


# Flash-BATCH-SOLR
PACKAGE_NAME="cacheserver-1.1.jar"
echo "Downloading Flash-Cache..."
downloadArtifactSnapShot "eu/els/sie/flash" "flash-cache-server" $1 "jar"
mv *.jar $PACKAGE_NAME

#Used to manually deploy package.
#cp /usr/share/INTEG/flash-1.1/apps/flash-cache-server-$1.jar $PACKAGE_NAME

# Copying the jar to target the host

###################### REMOTE VARS #####################
CACHE_SERVER_HOST="FR000-TSTAPP006"
USER="objectware"
CACHE_SERVER_DIRECTORY="/opt/cacheserver-1.1"
STOP_CACHE_SCRIPT="stopCacheServer.sh $ENV"
START_CACHE_SCRIPT="startCacheServer.sh $ENV"
########################################################
echo "Stoping cache on the host $CACHE_SERVER_HOST ..."
ssh $USER@$CACHE_SERVER_HOST "$CACHE_SERVER_DIRECTORY/$STOP_CACHE_SCRIPT"

echo "Copying cache server jar to the target host $CACHE_SERVER_HOST"
scp $PACKAGE_NAME $USER@$CACHE_SERVER_HOST:$CACHE_SERVER_DIRECTORY

# Starting cache on remote host
echo "Starting cache on remote host $CACHE_SERVER_HOST"
ssh $USER@$CACHE_SERVER_HOST $CACHE_SERVER_DIRECTORY/$START_CACHE_SCRIPT

echo "Removing temp directory $CACHE"
cd ..
rm -rf $CACHE
