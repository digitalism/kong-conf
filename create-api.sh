#!/bin/sh

source /opt/bin/shared.sh

echo "adding kong api endpoint: ${API_PATH} -> ${API_UPSTREAM_URL}"
curl -X POST -s -d "request_path=${API_PATH}" -d "upstream_url=${API_UPSTREAM_URL}" -d "name=${API_NAME}" -d "strip_request_path=${API_STRIP_REQ_PATH}" -d "preserve_host=${API_PRESERVE_HOST}" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/

# in case kong api endpoint already exists, update it
curl -X PATCH -s -d "request_path=${API_PATH}" -d "upstream_url=${API_UPSTREAM_URL}" -d "name=${API_NAME}" -d "strip_request_path=${API_STRIP_REQ_PATH}" -d "preserve_host=${API_PRESERVE_HOST}" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}

if [ ! -z "$API_PIWIK_ENDPOINT" ]; then
		echo "adding piwik plugin: {$API_PIWIK_ENDPOINT}"
    curl -X PUT -H 'Accept: application/json, text/plain, */*' --data-binary '{"name":"piwik-log","config":{"piwik_endpoint":"'${API_PIWIK_ENDPOINT}'","timeout":10000,"keepalive":60000}}' --compressed ${KONG_HOST}:${KONG_ADMIN_PORT}/${API_NAME}/plugins
fi
echo "added kong api endpoint: ${API_PATH} -> ${API_UPSTREAM_URL}"


if [ ! -z "$API_AUTH_USERNAME" ]; then
    curl -X POST -s -d "username=${API_AUTH_USERNAME}" ${KONG_HOST}:${KONG_ADMIN_PORT}/consumers
    curl -X PUT -s -d "username=${API_AUTH_USERNAME}" -d"password=${API_AUTH_PASSWORD}" ${KONG_HOST}:${KONG_ADMIN_PORT}/consumers/${API_AUTH_USERAME}/basic-auth
    curl -X POST -s -d "name=basic-auth" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}/plugins/
