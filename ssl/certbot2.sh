#!/bin/bash

for domain in $@; do
    # 域名非法，退出进入下一个循环
    if ! echo ${domain} | egrep '^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$' &> /dev/null; then
        echo -e "${domain} ---->请确认是否正确域名"
        continua
    fi
    #判读二级域名，如果匹配www,说明要生成顶级域名+www二级域名的证书
    if [[ `echo $domain | fgrep -o .  | wc -l` -eq 2 ]] && [[ `echo $domain | fgrep -o "www."`  ]]; then
        topDomain=${domain#*.}  #获取顶级域名
        domains="-d $topDomain -d $domain "
        domain="${topDomain}"
        wwwdomain="www.${topDomain}"
    else
        domains="-d $domain"
    fi
    if [ "$wwwdomain" ]; then
        sudo rm -rf /etc/letsencrypt/renewal/$wwwdomain.conf
        sudo rm -rf /etc/letsencrypt/archive/$wwwdomain
        sudo rm -rf /etc/letsencrypt/live/$wwwdomain
        echo "删除"$wwwdomain"成功"
    fi
    if [ "$domain" ]; then
        sudo rm -rf /etc/letsencrypt/renewal/$domain.conf
        sudo rm -rf /etc/letsencrypt/archive/$domain
        sudo rm -rf /etc/letsencrypt/live/$domain
        echo "删除"$domain"成功"
    fi

    certbot-auto certonly --agree-tos --webroot \
        -w /usr/local/nginx/html/ $domains \
        --register-unsafely-without-email <<EOF
1
EOF

    # 成功生成证书，则目录不为空
    if [ -f /etc/letsencrypt/archive/${domain}/cert1.pem ]; then
        cp -rf /etc/letsencrypt/archive/${domain} /etc/letsencrypt/ssl
        if [[ $? == "0" ]]; then
        echo "
            ${domain}:  success !
        "
        fi
    fi
done
