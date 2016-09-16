#!/bin/sh

if [ -z "$API_UPSTREAM_URL" ] || [ -z "$KONG_HOST" ] || [ -z "$KONG_ADMIN_PORT" ];
then
  echo 'Error: API_UPSTREAM_URL, KONG_HOST or KONG_ADMIN_PORT not set'
  exit 1
fi

# expecting schema: http://my-url.domain:port/path
API_UPSTREAM_HOST=$(echo $API_UPSTREAM_URL | cut -d ':' -f2 | cut -d '/' -f3)
API_UPSTREAM_PORT=$(echo $API_UPSTREAM_URL | cut -d ':' -f3 | cut -d '/' -f1)

# function: wait for a tcp service to be available
# param 1: host
# param 2: port
waitFor(){
  WAIT_HOST=$1
  WAIT_PORT=$2
  echo "waiting for $WAIT_HOST:$WAIT_PORT to come up.."
  while ! echo exit | /usr/bin/nc -zv $WAIT_HOST $WAIT_PORT; do sleep 1; done
  echo "service $WAIT_HOST:$WAIT_PORT is available!"
}

waitFor ${KONG_HOST} ${KONG_ADMIN_PORT}
waitFor ${API_UPSTREAM_HOST} ${API_UPSTREAM_PORT}
