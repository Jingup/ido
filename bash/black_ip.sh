#!/bin/bash
export LANG=en_US.UTF-8

blkip()
	{
		awk '{split($4,array,"[");if(array[2]>="'$b'" && array[2]<="'$a'"){print $0}}' /usr/local/nginx/logs/$1.log | awk '/POST \/Front\/Login/ || /POST \/Home\/Login_U/ {ip[$1]++} END{for(i in ip) if(ip[i]>3) print i}' > $1.txt
		awk 'NR==FNR {ip[$1]} NR>FNR {if(!($1 in ip)) print $1,2"'\;'"}' /usr/local/nginx/conf/ip_whitelist.conf $1.txt >> /usr/local/nginx/conf/ip_whitelist.conf
	}

while :
do
	for i in $(cat /usr/local/nginx/logs/customer.txt) #将客户写入此文件
	do
		a=$(date +%d/%b/%Y:%H:%M:%S)
		b=$(date -d '-20sec' +%d/%b/%Y:%H:%M:%S)
		blkip $i
	done
	#rm -f /usr/local/nginx/conf/blackip/$(date -d '-1hour' +%m%d%H).conf

	#/usr/local/sbin/nginx -s reload
	/usr/local/nginx/sbin/nginx -s reload
	sleep 20
done


