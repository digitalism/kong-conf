#!/bin/sh

source /opt/bin/shared.sh

echo "deleting kong api endpoint: ${API_NAME}}"
curl -X DELETE -s ${KONG_HOST}:${KONG_ADMIN_PORT}/apis/${API_NAME}

echo "delete kong api endpoint: ${API_NAME}"
