#!/bin/bash
#add for debug by zqb


echo " 开始执行操作. ... "
get_char()
{
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
} 

var="hello_world_icbc_cib"
#
echo ${#var}
#
echo ${var#*_}
#
echo ${var##*_}
#
echo ${var%_*}
#
echo ${var%%_*}
#
echo ${var:0:2}
#
echo ${var:2}
#
echo ${var:0-4:3}
#
echo ${var:0-4}
#
echo ${var/ic*_/ccb_}
#
echo ${var/i/I}
#
echo ${var//i/I}

#
filename="/home/test/str.sh"
echo "replace at the beginning: "${filename/#\/home/\/begin}
echo "replace at the ending: "${filename/%.*/.txt}

echo "bye..."
echo "Press any key to continue 。。。"
echo " CTRL+C break command bash ..." # 组合键 CTRL+C 终止命令!
char=`get_char`

