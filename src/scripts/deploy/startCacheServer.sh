VM_ARGS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=1098 "
JAVA_OPTS="-Xmx4g -Xms2g -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -XX:+UnlockDiagnosticVMOptions -XX:+DebugNonSafepoints -XX:-OmitStackTraceInFastThrow"
cd /opt/cacheserver/
nohup /usr/java/jdk1.8.0_73/bin/java $JAVA_OPTS $VM_ARGS -jar ./cacheserver.jar > /dev/null 2>&1 & echo $! > ./app.pid 

