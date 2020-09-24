#!/bin/bash
set -e

export LANG=zh_CN.UTF-8

# 项目安装位置,默认是/opt
Project=/opt

pid=`ps -ef | grep -v grep | egrep '(gunicorn|celery|beat|cocod)' | awk '{print $2}'`
if [ "$pid" != "" ]; then
    echo -e "\033[31m 检测到 Jumpserver 进程未退出,结束中 \033[0m"
    cd /opt/jms_scrip && sh stop_jms.sh
    sleep 5s
    pid1=`ps -ef | grep -v grep | egrep '(gunicorn|celery|beat|cocod)' | awk '{print $2}'`
    if [ "$pid1" != "" ]; then
        echo -e "\033[31m 检测到 Jumpserver 进程任未退出,强制结束中 \033[0m"
        kill -9 ${pid1}
    fi
fi

echo -e "\033[31m 正常启动 Jumpserver ... \033[0m"

# jumpserver
source $Project/py3/bin/activate
cd $Project/jumpserver && ./jms start -d

# guacamole
export GUACAMOLE_HOME=/config/guacamole
export JUMPSERVER_KEY_DIR=/config/guacamole/keys
export JUMPSERVER_SERVER=http://127.0.0.1:8080
export BOOTSTRAP_TOKEN='nwv4RdXpM82LtSvmV'
/etc/init.d/guacd start
cd /config/tomcat8/bin && ./startup.sh

# coco
cd $Project/coco && ./cocod start -d

exit 0
