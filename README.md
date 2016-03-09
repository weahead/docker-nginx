# We ahead's dockerized Nginx

[![Nginx 1.9.11](https://img.shields.io/badge/nginx-1.9.11-green.svg)]()

This is We ahead's dockerized Nginx.

## Features

- Compiled from source on Alpine.

- Redirects all HTTP traffic to HTTPS.

- All traffic for `${SERVER_FQDN}` is proxied to `${TARGET_HOST}:${TARGET_PORT}`.
- Runs nginx unprivileged via user `nobody` and group `nobody`.
- Generates configuration values based on environment values with
[`envplate`](https://github.com/kreuzwerker/envplate).
- Uses best practice configuration for security found around the web:
  - http://vincent.bernat.im/en/blog/2011-ssl-session-reuse-rfc5077.html
  - http://blog.ivanristic.com/2013/09/is-beast-still-a-threat.html
  - http://en.wikipedia.org/wiki/Secure_Sockets_Layer#SSL_3.0
  - https://cipherli.st/
  - https://developer.mozilla.org/en-US/docs/Security/HTTP_Strict_Transport_Security
  - https://en.wikipedia.org/wiki/SSL_stripping#SSL_stripping
  - https://developer.mozilla.org/en-US/docs/HTTP/X-Frame-Options


## Configuration options used during compilation

```sh
nginx -V
nginx version: nginx/1.9.11
built by gcc 5.3.0 (Alpine 5.3.0)
built with OpenSSL 1.0.2f  28 Jan 2016
TLS SNI support enabled
configure arguments:
  --prefix=/etc/nginx
  --sbin-path=/usr/sbin/nginx
  --conf-path=/etc/nginx/nginx.conf
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
```


## Environment variables

| Name            | Default value        | Description                                  |
|-----------------|----------------------|----------------------------------------------|
| TARGET_HOST     | *none*               | Required, Host for target                    |
| TARGET_PORT     | *none*               | Required, Port for target                    |
| SERVER_FQDN (*) | *none*               | Required, FQDN for server                    |
| SSL_CERTIFICATE | /certs/fullchain.pem | Full chain certificate for Registry          |
| SSL_PRIVKEY     | /certs/privkey.pem   | Private SSL key for certificate for Registry |
| SSL_DHPARAM     | /certs/dhparams.pem  | DH params file                               |


## Noteworthy files inside container

- Main configuration file: `/etc/nginx/nginx.conf`
- HTTP configuration file: `/etc/nginx/conf.d/default.conf`
- HTTPS configuration file: `/etc/nginx/conf.d/ssl.conf`
- Upstreams configuration file: `/etc/nginx/conf.d/upstream.conf`
- Directory for additional configuration files that are automatically included:
`/etc/nginx/conf.d/`
