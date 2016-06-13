#!/bin/bash
#set -x
# initialize variables
#MONGO_LOG="/var/log/mongodb/mongod.log"
#MONGO="/usr/bin/mongo"
#MONGOD="/usr/bin/mongod"
#STACK_NAME=$(echo $HOSTNAME | cut -f1 -d_)
#SERVICE_NAME=$(echo $HOSTNAME | cut -f2 -d_)
#MONGO_MASTER=${STACK_NAME}_${MONGO_MASTER_NAME}_${MONGO_MASTER_ID}
#DBNAME=$STACK_NAME
#DBAUTH="-u clusterAdmin -p ${CLUSTER_ADMIN_PASS} --authenticationDatabase admin"
#BACKGROUND="--fork --logpath $MONGO_LOG" 



echo " upstream_url: $API_UPSTREAM_URL"
#extract the ip
API_UPSTREAM_IP=$(nslookup ${API_UPSTREAM_HOST}|sed 's/[^0-9. ]//g'|tail -n 1|awk -F " " '{print $2}')
#build the UPSTREAM_URL with ip
API_UPSTREAM_URL="http://${API_UPSTREAM_IP}:${API_UPSTREAM_PORT}/${API_UPSTREAM_PATH}"
echo " upstream_url: $API_UPSTREAM_URL"

# function: wait for service. waits for TCP service 
# param 1: Host
# param 2: Port
waitFor(){
  WAIT_HOST=$1
  WAIT_PORT=$2
  echo "waiting for $WAIT_HOST:$WAIT_PORT to come up .. "
  while ! echo exit | /usr/bin/nc -zv $WAIT_HOST $WAIT_PORT; do sleep 5; done
  echo "Service $WAIT_HOST:$WAIT_PORT reached !"
}

echo "waiting for kong to come up .."
waitFor ${KONG_HOST} ${KONG_ADMIN_PORT}
echo "creating kong api .."
curl -X POST -d "request_path=${API_PATH}" -d "upstream_url=${API_UPSTREAM_URL}" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/
