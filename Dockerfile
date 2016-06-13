FROM progrium/busybox
RUN opkg-install netcat curl bash
ADD createApi.sh /opt/createApi.sh
ENV KONG_HOST 172.17.8.102
ENV KONG_ADMIN_PORT 8001
ENV API_PATH /test
ENV API_UPSTREAM_URL http://172.17.8.102:4040/
