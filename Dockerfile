FROM alpine:3.3

MAINTAINER We ahead <docker@weahead.se>

# Enable when Docker Hub supports build args.
# ARG NGINX_VERSION
ENV NGINX_VERSION=1.9.15\
    S6_VERSION=1.17.2.0\
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN build_pkgs="gnupg build-base linux-headers openssl-dev pcre-dev curl zlib-dev" \
    && runtime_pkgs="ca-certificates openssl pcre zlib" \
    && apk --no-cache add ${build_pkgs} ${runtime_pkgs} \
    && cd /tmp \
    && curl -OL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz" \
    && curl -OL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz.sig" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver pgp.mit.edu --recv-key 0x337EE704693C17EF \
    && gpg --batch --verify /tmp/s6-overlay-amd64.tar.gz.sig /tmp/s6-overlay-amd64.tar.gz \
    && tar -xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    && curl -OL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
    && curl -OL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc" \
    && gpg --keyserver pgpkeys.mit.edu --recv-key A1C052F8 \
    && gpg --batch --verify /tmp/nginx-${NGINX_VERSION}.tar.gz.asc nginx-${NGINX_VERSION}.tar.gz \
    && tar -xzf nginx-${NGINX_VERSION}.tar.gz \
    && cd /tmp/nginx-${NGINX_VERSION} \
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
    && rm -rf "$GNUPGHOME" /tmp/* \
    && apk del ${build_pkgs}

ADD root /

RUN ln -sf /dev/stdout /tmp/access.log \
    && ln -sf /dev/stderr /tmp/error.log

RUN chown -R nobody:nobody /etc/nginx /usr/local/etc/nginx /tmp/access.log /tmp/error.log

EXPOSE 8080 8443

WORKDIR /usr/local/etc/nginx

ENTRYPOINT [ "/init" ]
