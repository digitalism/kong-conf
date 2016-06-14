#FROM progrium/busybox
#RUN opkg-install netcat curl bash
FROM alpine:3.3
RUN apk add --no-cache curl
ADD createApi.sh /opt/createApi.sh
ENV KONG_HOST kong.kong
ENV KONG_ADMIN_PORT 8001
ENV API_NAME test
ENV API_PATH /test
ENV API_UPSTREAM_HOST parse-dashboard.openparse
ENV API_UPSTREAM_PORT 4040
ENV API_UPSTREAM_PATH /
