#!/usr/bin/execlineb -P

background {
  foreground { s6-echo "Checking for new config files every 5 seconds for 1 minute..." }

  ifelse {
    s6-maximumtime 60000
    loopwhilex -x 0
    foreground { s6-echo "Looking for /usr/local/etc/nginx/conf.d/upstream.conf ..." }
    s6-sleep 5 s6-test -f /usr/local/etc/nginx/conf.d/upstream.conf
  }
  {
    foreground { s6-echo "New config files found, restarting nginx..." }
    if { s6-svok /var/run/s6/services/nginx }
    s6-svc -T 10000 -h /var/run/s6/services/nginx
  }
  s6-echo "No new config files found during 1 minute. Skipping."
}
