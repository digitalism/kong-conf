FROM progrium/busybox
RUN opkg-install curl bash
ADD createApi.sh /opt/createApi.sh
ENV KONG_HOST 172.17.8.102
ENV KONG_PORT 8000
ENV API_PATH /test
ENV API_UPSTREAM_URL http://172.17.8.102:4040/
