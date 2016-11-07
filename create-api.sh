#!/bin/sh -x 

source /opt/bin/shared.sh

echo "adding kong api endpoint: ${API_PATH} -> ${API_UPSTREAM_URL}"
curl -X POST -s -d "request_path=${API_PATH}" -d "upstream_url=${API_UPSTREAM_URL}" -d "name=${API_NAME}" -d "strip_request_path=${API_STRIP_REQ_PATH}" -d "preserve_host=${API_PRESERVE_HOST}" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/

# in case kong api endpoint already exists, update it
curl -X PATCH -s -d "request_path=${API_PATH}" -d "upstream_url=${API_UPSTREAM_URL}" -d "name=${API_NAME}" -d "strip_request_path=${API_STRIP_REQ_PATH}" -d "preserve_host=${API_PRESERVE_HOST}" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}

if [ ! -z "$API_PIWIK_ENDPOINT" ]; then
    echo "adding piwik plugin: {$API_PIWIK_ENDPOINT}"
    curl -X PUT --data "name=piwik-log" --data "config.piwik_endpoint=${API_PIWIK_ENDPOINT}" --data "config.timeout=10000" --data "config.keepalive=60000" "${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}/plugins"
fi
echo "added kong api endpoint: ${API_PATH} -> ${API_UPSTREAM_URL}"


if [ ! -z "$API_AUTH_USERNAME" ]; then
    echo "adding user: ${API_AUTH_USERNAME} to api: ${API_NAME}"
    curl -X POST -s -d "username=${API_AUTH_USERNAME}" ${KONG_HOST}:${KONG_ADMIN_PORT}/consumers
    curl -X PUT -s -d "username=${API_AUTH_USERNAME}" -d"password=${API_AUTH_PASSWORD}" ${KONG_HOST}:${KONG_ADMIN_PORT}/consumers/${API_AUTH_USERNAME}/basic-auth
    curl -X POST -s -d "name=basic-auth" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}/plugins/
fi


if [ ! -z "$API_RATE_LIMIT" ]; then
    echo "adding rate-limit to ${API_RATE_LIMIT} per sec"
    curl -X POST -s -d "name=rate-limiting" -d "config.limit_by=consumer" -d "config.policy=cluster" -d "config.second=$API_RATE_LIMIT" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}/plugins
    curl -X POST -s -d "name=response-ratelimiting" -d "config.limit_by=consumer" -d "config.policy=cluster" -d "config.limits.calls.second=$API_RATE_LIMIT" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}/plugins
fi

if [ ! -z "$API_LIMIT_REQUEST_SIZE" ]; then
  echo "limiting the request-size to ${API_LIMIT_REQUEST_SIZE} MB"
    curl -X POST -s -d "name=request-size-limiting" -d "config.allowed_payload_size=${API_LIMIT_REQUEST_SIZE}" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}/plugins

fi

sleep 3000
