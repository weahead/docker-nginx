# We ahead's dockerized Nginx

[![Nginx 1.9.11](https://img.shields.io/badge/nginx-1.9.11-green.svg)](https://github.com/nginx/nginx/releases/tag/release-1.9.11)

This is We ahead's dockerized Nginx.


## Features

- Compiled from source on Alpine.
- A few global default configuration options
- Runs nginx unprivileged via user `nobody` and group `nobody`.
  - Exposes 8080 and 8443
- Includes additional configuration files form `/etc/nginx/conf.d/*.conf`


## Configuration options used during compilation

```sh
nginx -V
nginx version: nginx/1.9.11
built by gcc 5.3.0 (Alpine 5.3.0)
built with OpenSSL 1.0.2g  1 Mar 2016
TLS SNI support enabled
configure arguments:
	--prefix=/etc/nginx 
	--sbin-path=/usr/sbin/nginx 
	--conf-path=/usr/local/etc/nginx/nginx.conf 
	--error-log-path=stderr 
	--http-log-path=/dev/stdout 
	--pid-path=/tmp/nginx.pid 
	--lock-path=/tmp/nginx.lock 
	--http-client-body-temp-path=/tmp/client_body_temp 
	--http-proxy-temp-path=/tmp/proxy_temp 
	--http-fastcgi-temp-path=/tmp/fastcgi_temp 
	--http-uwsgi-temp-path=/tmp/uwsgi_temp 
	--http-scgi-temp-path=/tmp/scgi_temp 
	--user=nobody 
	--group=nobody 
	--with-http_ssl_module 
	--with-http_realip_module 
	--with-http_addition_module 
	--with-http_sub_module 
	--with-http_gunzip_module 
	--with-http_gzip_static_module 
	--with-http_stub_status_module 
	--with-http_auth_request_module 
	--with-ipv6 
	--with-threads 
	--with-stream 
	--with-stream_ssl_module 
	--with-http_slice_module 
	--with-http_v2_module 
	--without-http_memcached_module 
	--without-mail_pop3_module 
	--without-mail_imap_module 
	--without-mail_smtp_module
/usr/local/etc/nginx $
```
