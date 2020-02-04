#/usr/bin bash

SSH_FILES="/var/log/secure"
IPDIR=(192.168.0.33 192.168.0.199 192.168.0.1)
TIME=$(TZ=Asia/Shanghai date +%F" "%X"  CST")
tailf $SSH_FILES | while read LINE; do
    if echo $LINE | egrep -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" &> /dev/null; then
        IP=$(echo $LINE | egrep -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
        PID=$(who | grep "$IP" |awk '{print $2}')
        if ! echo ${IPDIR[@]} | egrep -o $IP &>/dev/null ; then
            firewall-cmd --zone=trusted --add-rich-rule="rule family="ipv4" source address="$IP" service name="ssh" reject" &>/dev/null
            echo  "$TIME This $IP has already Deny" 
            if [[ -n  $PID ]];then
               （  #开启子进程
                   sleep 0.1
                   pkill -kill -t $PID
                   echo "$TIME User has been kicked out !!"
                ）
            fi
        fi
    fi
done
          











