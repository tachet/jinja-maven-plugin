#!/bin/sh

#Import commons functions
[ -f /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh ] && . /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters, Usage : deploy-config.sh \"<version>\", exemple : deploy-config.sh \"2.0.0-SNAPSHOT\" "
	exit 0
fi

echo "[FLASH ECM CONFIG] Deploiement de la config sur l'environnement d'integration"


WHERE_TO_WORK="/usr/share/INTEG/flash-1.1/config"

echo "[FLASH ECM CONFIG] on se positionne ici $WHERE_TO_WORK"

cd $WHERE_TO_WORK

echo "Backup of config"
cp -f *.properties backup
cp -f *.yml backup
cp -rf editor backup

rm -rf *.properties
rm -rf *.yml
rm -rf editor

echo "Downloading Flash-CONFIG..."
downloadArtifactSnapShot "eu/els/sie/flash" "flash-config" $1 "zip"

#Used to manually deploy package.
#cp /usr/share/INTEG/flash-1.1/apps/flash-config-$1.zip flash-config.zip

unzip *.zip -d flash-config

mv flash-config/generated/properties/* .

echo "Copying editor config"
mv flash-config/editor . 

echo "Deleting temporary files"
rm -rf flash-config
rm -f *.zip
echo "[FLASH ECM CONFIG] Deployed."


