#!/bin/sh
set -x
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

API_UPSTREAM_HOST=$(echo $API_UPSTREAM_URL | cut -d ':' -f1)
API_UPSTREAM_PORT=$(echo $API_UPSTREAM_URL | cut -d ':' -f2 | cut -d '/' -f1)
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
waitFor ${API_UPSTREAM_HOST} ${API_UPSTREAM_PORT}

#echo " upstream_url: $API_UPSTREAM_URL"
##extract the ip
#API_UPSTREAM_IP=$(getent hosts ${API_UPSTREAM_HOST} | cut -d ' ' -f1)
##build the UPSTREAM_URL with ip
#API_UPSTREAM_URL="http://${API_UPSTREAM_IP}:${API_UPSTREAM_PORT}${API_UPSTREAM_PATH}"
#echo " upstream_url: $API_UPSTREAM_URL"

echo "creating kong api .."
curl -X POST -d "request_path=${API_PATH}" -d "upstream_url=${API_UPSTREAM_URL}" -d "name=${API_NAME}" -d "strip_request_path=${API_STRIP_REQ_PATH}" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/
#in case it already exists. update it
curl -X PATCH -d "request_path=${API_PATH}" -d "upstream_url=${API_UPSTREAM_URL}" -d "name=${API_NAME}" -d "strip_request_path=${API_STRIP_REQ_PATH}" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}
