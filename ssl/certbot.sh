#!/bin/bash
domainlist='***'

for domain in $domainlist;do


domains="-d $domain"


certbot-auto  certonly --agree-tos --webroot \
        -w /usr/local/nginx/html/ $domains \
        --register-unsafely-without-email <<EOF
1
EOF
if [ -f /etc/letsencrypt/archive/${domain}/cert1.pem ]; then
        cp -rf /etc/letsencrypt/archive/${domain} /etc/letsencrypt/

if [[ $? == "0" ]]; then
echo "
        ${domain}: success !
"
fi
fi
done

