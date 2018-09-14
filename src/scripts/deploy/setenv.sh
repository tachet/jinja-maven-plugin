#!/bin/sh
export UMASK=0002
JAVA_HOME=/usr/java/jdk1.8.0_65
JRE_HOME=/usr/java/jdk1.8.0_65/jre
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8 -Dspring.profiles.active=prod -Dspring.config.location=file:/usr/share/INTEG/flash-1.1/conf/flash-admin.properties,file:/usr/share/INTEG/flash-1.1/conf/flash-ecm-core.properties,file:/usr/share/INTEG/flash-1.1/conf/flash-ecm-user.properties"
JAVA_OPTS=" -Dhttp.proxyHost=fr000-proxy001 -Dhttp.proxyPort=8080  $JAVA_OPTS"
JAVA_OPTS=" -Dhttps.proxySet=true -Dhttps.proxyHost=fr000-proxy001 -Dhttps.proxyPort=8070 -Dhttp.nonProxyHosts='10.16.14.*' $JAVA_OPTS"
JAVA_OPTS=" -server -XX:MaxMetaspaceSize=3g -Xmx3g -Xms1g $JAVA_OPTS"
#JAVA_OPTS=" -Xdebug -Xrunjdwp:transport=dt_socket,address=8978,server=y,suspend=n $JAVA_OPTS"
#JAVA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=10005 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false $JAVA_OPTS"
echo $JAVA_OPTS
export JAVA_OPTS
