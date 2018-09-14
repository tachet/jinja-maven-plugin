#!/bin/sh

#Import commons functions
[ -f /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh ] && . /usr/share/INTEG/flash-1.1/scripts/common/get-artifact-from-nexus.sh

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters, Usage : deploy-tomcat-webapps.sh \"<version>\", exemple : deploy-tomcat-webapps.sh \"2.0.0-SNAPSHOT\" "
	exit 0
fi

echo "Deploiement sur l'environnement d'integration"


TOMCAT_PATH="/usr/share/INTEG/flash-1.1/apache-tomcat-8.5.15"
EXPORT_CONFIG_LOCK_DIR="/var/flash-1.1/export"

echo "Deploying version $VERSION"

echo "On arrete le tomcat de flash 1.1"
sudo kill -9 $(ps aux | grep $TOMCAT_PATH | awk '{print $2}')
echo "Tomcat stopped"

# On supprime les wars existans et leurs folders
echo "On supprime les wars existans et leurs folders"
sudo rm -rf $TOMCAT_PATH/webapps/*
echo "Clean all log and temp file"
sudo rm -rf $TOMCAT_PATH/temp/*
sudo rm -rf $TOMCAT_PATH/logs/*



cd $TOMCAT_PATH/webapps
echo "cd $TOMCAT_PATH/webapps"

# On t�l�charge les nouveaux wars

# Flash-Ecm-Core
echo "Downloading Flash-Ecm-Core..."
downloadArtifactSnapShot "eu/els/sie/flash" "flash-ecm-core-rest" $1 "war"
mv flash-ecm-core-rest*.war ecm-core.war

#Used to manually deploy package.
#cp /usr/share/INTEG/flash-1.1/apps/flash-ecm-core-rest-$1.war ecm-core.war

# Flash-Ecm-User
echo "Downloading Flash-Ecm-User..."
downloadArtifactSnapShot "eu/els/sie/flash" "flash-ecm-user" $1 "war"
mv flash-ecm-user*.war ROOT.war

#Used to manually deploy package.
#cp /usr/share/INTEG/flash-1.1/apps/flash-ecm-user-$1.war ROOT.war

# Flash-Ecm-Admin
echo "Downloading Flash-Admin..."
downloadArtifactSnapShot "eu/els/sie/flash" "flash-admin" $1 "war"
mv flash-admin*.war xfadmin.war

#Used to manually deploy package.
#cp /usr/share/INTEG/flash-1.1/apps/flash-admin-$1.war xfadmin.war

echo "Removing export configuration lock file ..."
sudo rm -f $EXPORT_CONFIG_LOCK_DIR/*.lock
# On d�marre Tomcat
echo "Restarting Tomcat"
TOMCAT_SHELL="sudo $TOMCAT_PATH/bin/startup.sh"
$TOMCAT_SHELL
echo "Waiting 1 minute for application deployement ..."
sleep 1m


