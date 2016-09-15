#!/usr/bin/execlineb -P

with-contenv

if -t { s6-test -v USE_DNSMASQ }
background {
  foreground { s6-echo "Starting dnsmasq..." }
  s6-setuidgid nobody dnsmasq -k
}
