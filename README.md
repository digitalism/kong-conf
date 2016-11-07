build
-----

    docker build -t kong-conf .


run
---

    docker run -ti kong-conf /opt/bin/create-api.sh

or

    docker run -ti -e API_PATH=/rofl2 -e API_UPSTREAM_URL=http://172.17.8.102:4040/ kong-conf /opt/bin/create-api.sh

add authentication:
-------------------
    docker run -ti -e API_AUTH_USERNAME=user -e API_AUTH_PASSWORD=user kong-conf

add request limit
-----------------

    docker run -ti -e API_RATE_LIMIT=10 kong-conf

    adds an request limit and an response-limit of 10req/s

add request size limit:
-----------------------
    
    docker run -ti -e API_LIMIT_REQUEST_SIZE=1 kong-conf

    limits the request size to 1mb
