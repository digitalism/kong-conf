build
-----

    docker build -t kong-conf .


run
---

    docker run -ti kong-conf /opt/bin/create-api.sh

or

    docker run -ti -e API_PATH=/rofl2 -e API_UPSTREAM_URL=http://172.17.8.102:4040/ kong-conf /opt/bin/create-api.sh
