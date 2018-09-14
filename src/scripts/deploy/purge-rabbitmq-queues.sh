#!/bin/sh

if [ "$#" -ne "4" ]
  then
    echo "Usage purge-rabbitmq-queues.sh <HOSTNAME> <PORT> <USER> <PASSWD>"
    exit 1
fi

RABBIT_MQ_HOSTNAME_IP=$1
RABBIT_MQ_PORT=$2
RABBIT_MQ_USER=$3
RABBIT_MQ_PASSWD=$4

echo "[RABBIT MQ] Purge all queues on $RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT ..."

curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/batch-process-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/batch-process-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/batch-process-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/bulk-operation-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/bulk-operation-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/bulk-operation-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/cache-preview-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/cache-preview-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/cache-preview-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/export-media-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/export-media-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/export-media-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/export-xml-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/export-xml-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/export-xml-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/notification-push-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/notification-push-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/notification-push-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/notification-treatment-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/notification-treatment-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/notification-treatment-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/publish-xml-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/publish-xml-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/publish-xml-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/solr-import-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/solr-import-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/solr-import-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/solr-live-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/solr-live-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/solr-live-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/tree-update-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/tree-update-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/tree-update-log-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/upload-xml-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/upload-xml-error-int-develop.queue/contents
curl -i -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWD -XDELETE http://$RABBIT_MQ_HOSTNAME_IP:$RABBIT_MQ_PORT/api/queues/%2F/upload-xml-log-int-develop.queue/contents
