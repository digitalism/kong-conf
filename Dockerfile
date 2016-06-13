FROM progrium/busybox
RUN opkg-install netcat curl bash
ADD createApi.sh /opt/createApi.sh
ENV KONG_HOST 172.17.8.101
ENV KONG_ADMIN_PORT 8001
ENV API_PATH /test
ENV API_UPSTREAM_HOST parse-server.openparse
ENV API_UPSTREAM_PORT 4001
ENV API_UPSTREAM_PATH /
