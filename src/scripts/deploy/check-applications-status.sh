#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters, Usage : check-ecm-applications-status.sh \"<version>\", exemple : check-ecm-applications-status.sh \"2.0.0-SNAPSHOT\" "
	exit 0
fi

if [ $1 = "1.1.x-SNAPSHOT"  ]; then
  ENV_ADDR="10.16.14.5:8181"
elif [ $1 = "2.0.0-SNAPSHOT"  ]; then
  ENV_ADDR="10.16.14.5:8282"
else
 echo "Unknown environnement $1"
 exit 1
fi

echo "Checking release $1 applications status"
TOKEN=$(curl -d "username=fmessaadi&password=password" -X POST http://${ENV_ADDR}/api/authenticate |  tr ":," "\n" | head -n 2 | tail -n1 | tr -d '"')
RESULT=$(curl http://${ENV_ADDR}/api/monitoring/health -H "x-auth-token: $TOKEN" | grep 'DOWN')
GLOBAL_STATUS=0

if [ -n "$RESULT" ]; then
 GLOBAL_STATUS=1
fi

echo "Global status is KO(1), OK(0): $GLOBAL_STATUS"
exit $GLOBAL_STATUS
