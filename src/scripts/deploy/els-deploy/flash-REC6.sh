
VERSION=$1
CURRENTVERSION=$2
LOCALCONFPATH=//rbfrp1230/ELS/FLASH/CONF/REC6
LOCALSAVEPATH=//rbfrp1230/ELS/FLASH/Deploiement/livrables/archives
REMOTEHOMEPATH=/home/ELS-EU/andao
REMOTEDEPLOYPATH=$REMOTEHOMEPATH/deploy

# Sauvegarde de la configuration actuelle
if ! [ -d "$LOCALCONFPATH/$VERSION/" ]; then mkdir $LOCALCONFPATH/$CURRENTVERSION/; fi
scp 10.16.84.5:/Async/APP/conf/*.properties $LOCALCONFPATH/$CURRENTVERSION/
scp 10.16.84.7:/CacheServer/config/application.yml $LOCALCONFPATH/$CURRENTVERSION/
scp 10.16.84.13:/Tomcat/APP/apache-tomcat-8.5.11/conf/flash/*.properties $LOCALCONFPATH/$CURRENTVERSION/
#---------------------------------------------------------------

# Le dossier $LOCALSAVEPATH/$VERSION/
# a été créé par la commande flash-install.sh REC[12345] tag $VERSION allmods real
scp $LOCALSAVEPATH/$VERSION/{async,erm,batch-solr}.jar 10.16.84.5:$REMOTEDEPLOYPATH/
scp $LOCALSAVEPATH/$VERSION/{async,erm,batch-solr}.jar 10.16.84.6:$REMOTEDEPLOYPATH/
scp $LOCALSAVEPATH/$VERSION/cacheserver.jar 10.16.84.7:$REMOTEDEPLOYPATH/CacheServer.jar
scp $LOCALSAVEPATH/$VERSION/{xfadmin,ecm-core}.war 10.16.84.13:$REMOTEDEPLOYPATH/
scp $LOCALSAVEPATH/$VERSION/ROOT.war 10.16.84.13:$REMOTEDEPLOYPATH/ecm-user.war
#---------------------------------------------------------------


# ASYNC1 (ASYNC/ERM/BATCH)
ssh 10.16.84.5 ls -l $REMOTEDEPLOYPATH
ssh -t 10.16.84.5 sudo chmod 644 $REMOTEDEPLOYPATH/*.jar
ssh -t 10.16.84.5 sudo chown async:async $REMOTEDEPLOYPATH/*.jar
ssh -t 10.16.84.5 ls -l $REMOTEDEPLOYPATH

ssh -t 10.16.84.5 sudo service async stop
ssh -t 10.16.84.5 sudo service erm stop
ssh -t 10.16.84.5 sudo batch stop

ssh 10.16.84.5 ls -l /Async/APP/{async,erm,batch}/*.jar
ssh -t 10.16.84.5 sudo mv /Async/APP/{async,erm,batch}/*.jar $REMOTEHOMEPATH/
ssh 10.16.84.5 ls -lr $REMOTEHOMEPATH/*.jar

ssh -t 10.16.84.5 sudo mv $REMOTEDEPLOYPATH/async.jar /Async/APP/async/
ssh -t 10.16.84.5 sudo mv $REMOTEDEPLOYPATH/batch-solr.jar /Async/APP/batch/batch.jar
ssh -t 10.16.84.5 sudo mv $REMOTEDEPLOYPATH/erm.jar /Async/APP/erm/
ssh 10.16.84.5 ls -lr {$REMOTEHOMEPATH/,/Async/APP/{async,erm,batch}/}*.jar

ssh -t 10.16.84.5 sudo service erm start
ssh -t 10.16.84.5 sudo service async start
#---------------------------------------------------------------


# ASYNC2 (ASYNC/ERM/BATCH)
ssh 10.16.84.6 ls -l $REMOTEDEPLOYPATH
ssh -t 10.16.84.6 sudo chmod 644 $REMOTEDEPLOYPATH/*.jar
ssh -t 10.16.84.6 sudo chown async:async $REMOTEDEPLOYPATH/*.jar
ssh -t 10.16.84.6 ls -l $REMOTEDEPLOYPATH

ssh -t 10.16.84.6 sudo service async stop
ssh -t 10.16.84.6 sudo service erm stop
ssh -t 10.16.84.6 sudo batch stop

ssh 10.16.84.6 ls -l /Async/APP/{async,erm,batch}/*.jar
ssh -t 10.16.84.6 sudo mv /Async/APP/{async,erm,batch}/*.jar $REMOTEHOMEPATH/
ssh 10.16.84.6 ls -lr $REMOTEHOMEPATH/*.jar

ssh -t 10.16.84.6 sudo mv $REMOTEDEPLOYPATH/async.jar /Async/APP/async/
ssh -t 10.16.84.6 sudo mv $REMOTEDEPLOYPATH/batch-solr.jar /Async/APP/batch/batch.jar
ssh -t 10.16.84.6 sudo mv $REMOTEDEPLOYPATH/erm.jar /Async/APP/erm/
ssh 10.16.84.6 ls -lr {$REMOTEHOMEPATH/,/Async/APP/{async,erm,batch}/}*.jar

ssh -t 10.16.84.6 sudo service erm start
ssh -t 10.16.84.6 sudo service async start
#---------------------------------------------------------------


# CACHE (10.16.84.7)
ssh 10.16.84.7 ls -l $REMOTEDEPLOYPATH
ssh -t 10.16.84.7 sudo chmod 644 $REMOTEDEPLOYPATH/*.jar
ssh -t 10.16.84.7 sudo chown hazelcast:hazelcast $REMOTEDEPLOYPATH/*.jar
ssh 10.16.84.7 ls -l $REMOTEDEPLOYPATH

ssh -t 10.16.84.7 sudo service hazelcast stop
ssh 10.16.84.7 ls -l /CacheServer/CacheServer.jar
ssh 10.16.84.7 -t sudo mv /CacheServer/CacheServer.jar $REMOTEHOMEPATH/
ssh 10.16.84.7 -t sudo mv $REMOTEDEPLOYPATH/CacheServer.jar /CacheServer/
ssh 10.16.84.7 ls -l /CacheServer/CacheServer.jar

ssh -t 10.16.84.7 sudo service hazelcast start
#---------------------------------------------------------------


# TOMCAT (10.16.84.13)
ssh -t 10.16.84.13 sudo chmod 644 $REMOTEDEPLOYPATH/*.war
ssh -t 10.16.84.13 sudo chown tomcat:tomcat $REMOTEDEPLOYPATH/*.war
ssh 10.16.84.13 ls -lr $REMOTEHOMEPATH{/,/deploy/}*.war

ssh -t 10.16.84.13 sudo service tomcat stop
ssh -t 10.16.84.13 ls -l /Tomcat/APP/apache-tomcat-8.5.11/webapps/
ssh -t 10.16.84.13 sudo mv /Tomcat/APP/apache-tomcat-8.5.11/webapps/*.war $REMOTEHOMEPATH/
ssh 10.16.84.13 ls -lr $REMOTEHOMEPATH{/,/deploy/}*.war
ssh -t 10.16.84.13 sudo rm -rf /Tomcat/APP/apache-tomcat-8.5.11/webapps/*
ssh -t 10.16.84.13 ls -l /Tomcat/APP/apache-tomcat-8.5.11/webapps/
ssh -t 10.16.84.13 sudo mv $REMOTEDEPLOYPATH/*.war /Tomcat/APP/apache-tomcat-8.5.11/webapps/
ssh -t 10.16.84.13 ls -l /Tomcat/APP/apache-tomcat-8.5.11/webapps/

ssh -t 10.16.84.13 sudo service tomcat start
ssh -t 10.16.84.13 sudo tail -f /Tomcat/Logs/catalina.out
#---------------------------------------------------------------


#ROLLBACK ASYNC1
ssh -t 10.16.84.5 sudo service erm stop
ssh -t 10.16.84.5 sudo service async stop

ssh -t 10.16.84.5 sudo mv /Async/APP/async/async.jar $REMOTEDEPLOYPATH/
ssh -t 10.16.84.5 sudo mv /Async/APP/erm/erm.jar $REMOTEDEPLOYPATH/
ssh -t 10.16.84.5 sudo mv /Async/APP/batch/batch.jar $REMOTEDEPLOYPATH/
ssh -t 10.16.84.5 sudo mv $REMOTEHOMEPATH/async.jar /Async/APP/async/
ssh -t 10.16.84.5 sudo mv $REMOTEHOMEPATH/batch.jar /Async/APP/batch/
ssh -t 10.16.84.5 sudo mv $REMOTEHOMEPATH/erm.jar /Async/APP/erm/

ssh -t 10.16.84.5 sudo service erm start
ssh -t 10.16.84.5 sudo service async start
#---------------------------------------------------------------


#ROLLBACK ASYNC2
ssh -t 10.16.84.6 sudo service erm stop
ssh -t 10.16.84.6 sudo service async stop

ssh -t 10.16.84.6 sudo mv /Async/APP/async/async.jar $REMOTEDEPLOYPATH/
ssh -t 10.16.84.6 sudo mv /Async/APP/erm/erm.jar $REMOTEDEPLOYPATH/
ssh -t 10.16.84.6 sudo mv /Async/APP/batch/batch.jar $REMOTEDEPLOYPATH/
ssh -t 10.16.84.6 sudo mv $REMOTEHOMEPATH/async.jar /Async/APP/async/
ssh -t 10.16.84.6 sudo mv $REMOTEHOMEPATH/batch.jar /Async/APP/batch/
ssh -t 10.16.84.6 sudo mv $REMOTEHOMEPATH/erm.jar /Async/APP/erm/

ssh -t 10.16.84.6 sudo service erm start
ssh -t 10.16.84.6 sudo service async start
#---------------------------------------------------------------


#ROLLBACK TOMCAT
ssh -t 10.16.84.13 sudo service tomcat stop

ssh -t 10.16.84.13 sudo mv /Tomcat/APP/apache-tomcat-8.5.11/webapps/{xfadmin,ecm-{core,user}}.war $REMOTEDEPLOYPATH/
ssh -t 10.16.84.13 sudo rm -f /Tomcat/APP/apache-tomcat-8.5.11/webapps/*
ssh -t 10.16.84.13 sudo mv $REMOTEHOMEPATH/{xfadmin,ecm-{core,user}}.war /Tomcat/APP/apache-tomcat-8.5.11/webapps/

ssh -t 10.16.84.13 sudo service tomcat start
#---------------------------------------------------------------

#ROLLBACK HAZELCAST
ssh -t 10.16.84.7 sudo service hazelcast stop

ssh 10.16.84.7 -t sudo mv /CacheServer/CacheServer.jar $REMOTEDEPLOYPATH/
ssh 10.16.84.7 -t sudo mv $REMOTEHOMEPATH/CacheServer.jar /CacheServer/

ssh -t 10.16.84.7 sudo service hazelcast start
