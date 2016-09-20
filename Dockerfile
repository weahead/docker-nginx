FROM alpine:3.4

MAINTAINER We ahead <docker@weahead.se>

# Enable when Docker Hub supports build args.
# ARG NGINX_VERSION
ENV NGINX_VERSION=1.11.3\
    S6_VERSION=1.18.1.5\
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN apk --no-cache add dnsmasq \
    && apk --no-cache add --virtual build-pkgs libcap \
    && setcap cap_net_admin,cap_net_bind_service+ep /usr/sbin/dnsmasq \
    && apk del build-pkgs

RUN apk --no-cache add --virtual build-pkgs curl gnupg \
    && curl -OL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz" \
    && curl -OL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz.sig" \
    && export GNUPGHOME="$(mktemp -d)" \
    && curl https://keybase.io/justcontainers/key.asc | gpg --import \
    && gpg --verify s6-overlay-amd64.tar.gz.sig s6-overlay-amd64.tar.gz \
    && tar -xzf s6-overlay-amd64.tar.gz -C / \
    && rm -rf "$GNUPGHOME" "s6-overlay-amd64.tar.gz" "s6-overlay-amd64.tar.gz.sig" \
    && apk del build-pkgs

RUN apk --no-cache add --virtual build-pkgs \
      curl \
      gnupg \
      build-base \
      linux-headers \
      openssl-dev \
      pcre-dev \
      zlib-dev \
    && apk --no-cache add --virtual runtime-pkgs \
      ca-certificates \
      openssl \
      pcre \
      zlib \
    && curl -OL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
    && curl -OL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "B0F4253373F8F6F510D42178520A9993A1C052F8" \
    && gpg --batch --verify nginx-${NGINX_VERSION}.tar.gz.asc nginx-${NGINX_VERSION}.tar.gz \
    && tar -xzf nginx-${NGINX_VERSION}.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && ./configure \
      --prefix=/etc/nginx \
      --sbin-path=/usr/sbin/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --error-log-path=/tmp/error.log \
      --http-log-path=/tmp/access.log \
      --pid-path=/tmp/nginx.pid \
      --lock-path=/tmp/nginx.lock \
      --http-client-body-temp-path=/tmp/client_body_temp \
      --http-proxy-temp-path=/tmp/proxy_temp \
      --http-fastcgi-temp-path=/tmp/fastcgi_temp \
      --http-uwsgi-temp-path=/tmp/uwsgi_temp \
      --http-scgi-temp-path=/tmp/scgi_temp \
      --user=nobody \
      --group=nobody \
      --with-http_ssl_module \
      --with-http_realip_module \
      --with-http_addition_module \
      --with-http_sub_module \
      --with-http_gunzip_module \
      --with-http_gzip_static_module \
      --with-http_stub_status_module \
      --with-http_auth_request_module \
      --with-ipv6 \
      --with-threads \
      --with-stream \
      --with-stream_ssl_module \
      --with-http_slice_module \
      --with-http_v2_module \
      --without-http_memcached_module \
      --without-mail_pop3_module \
      --without-mail_imap_module \
      --without-mail_smtp_module \
    && make \
    && make install \
    && cd - \
    && rm -rf "$GNUPGHOME" "nginx-${NGINX_VERSION}.tar.gz" "nginx-${NGINX_VERSION}.tar.gz.asc" "nginx-${NGINX_VERSION}" \
    && apk del build-pkgs \
    && ln -sf /dev/stdout /tmp/access.log \
    && ln -sf /dev/stderr /tmp/error.log

ADD root /

RUN chown -R nobody:nobody /etc/nginx /usr/local/etc/nginx /tmp/access.log /tmp/error.log

EXPOSE 8080 8443

WORKDIR /usr/local/etc/nginx

ENTRYPOINT [ "/init" ]
