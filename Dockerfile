FROM alpine:3.3

MAINTAINER Michael Lopez <michael@weahead.se>

ARG NGINX_VERSION

RUN \
  build_pkgs="gnupg build-base linux-headers openssl-dev pcre-dev wget zlib-dev" && \
  runtime_pkgs="ca-certificates openssl pcre zlib" && \
  apk --no-cache add ${build_pkgs} ${runtime_pkgs} && \
  cd /tmp && \
  wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
  wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc && \
  gpg --keyserver pgpkeys.mit.edu --recv-key A1C052F8 && \
  gpg nginx-${NGINX_VERSION}.tar.gz.asc && \
  tar xzf nginx-${NGINX_VERSION}.tar.gz && \
  cd /tmp/nginx-${NGINX_VERSION} && \
  ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=stderr \
    --http-log-path=/dev/stdout \
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
		--without-mail_smtp_module && \
  make && \
  make install && \
  rm -rf /tmp/* && \
  apk del ${build_pkgs} && \
  rm -rf /var/cache/apk/*

ADD root /

RUN chown -R nobody:nobody /etc/nginx /usr/local/etc/nginx

EXPOSE 8080 8443

USER nobody

WORKDIR /usr/local/etc/nginx

CMD [ "/usr/sbin/nginx" ]
