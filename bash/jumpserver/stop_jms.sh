#!/bin/bash
set -e

# 项目安装位置,默认是/opt
Project=/opt

source $Project/py3/bin/activate
cd $Project/coco && ./cocod stop
/etc/init.d/guacd stop
cd /config/tomcat8/bin && ./shutdown.sh
cd $Project/jumpserver && ./jms stop

exit 0
