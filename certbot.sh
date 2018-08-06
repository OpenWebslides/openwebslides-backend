#!/usr/bin/env bash
#
# certbot.sh - Run CertBot to renew Let's Encrypt certificates
#

function renew() {
  docker-compose -f docker-compose.yml -f docker-compose.certbot.yml run --rm certbot \
    certonly --agree-tos --email florian@floriandejonckheere.be \
    --renew-by-default -n --text --webroot -w /data/letsencrypt/ \
    -d $1
}

# Renew certificates
for HOST in $@; do
  renew ${HOST}
done

# Reload NGINX configuration
docker-compose exec nginx nginx -s reload
