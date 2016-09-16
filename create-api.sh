#!/bin/sh

source /opt/bin/shared.sh

echo "adding kong api endpoint: ${API_PATH} -> ${API_UPSTREAM_URL}"
curl -X POST -s -d "request_path=${API_PATH}" -d "upstream_url=${API_UPSTREAM_URL}" -d "name=${API_NAME}" -d "strip_request_path=${API_STRIP_REQ_PATH}" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/

# in case kong api endpoint already exists, update it
curl -X PATCH -s -d "request_path=${API_PATH}" -d "upstream_url=${API_UPSTREAM_URL}" -d "name=${API_NAME}" -d "strip_request_path=${API_STRIP_REQ_PATH}" ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}

echo "added kong api endpoint: ${API_PATH} -> ${API_UPSTREAM_URL}"
