#!/bin/bash
rpm -q wget > /dev/null
[ $? -ne 0 ] && yum -y install wget 
rpm -q net-tools > /dev/null
[ $? -ne 0 ] && yum -y install net-tools
basedir=./deployrepository
opradir=/usr/local
while :
do
if [ ! -d $basedir/nginx/base ] ;then
#############################################################部署基础包
echo '下载基础包...'
sleep 1
wget -r -nH ftp://******/deployrepository/nginx/ --ftp-user=test01 --ftp-password=butterfly	#根据具体修改
tar xf $basedir/nginx/base.tar.xz -C $basedir/nginx/
cp -p $basedir/nginx/base/bin/* $opradir/bin/
cp -p $basedir/nginx/base/etc/* $opradir/etc/
cp -p $basedir/nginx/base/include/* $opradir/include/
cp -p $basedir/nginx/base/lib/* $opradir/lib/
cp -r -p $basedir/nginx/base/GeoIP $opradir/share/
cp -r -p $basedir/nginx/base/luajit $opradir/
cp -r -p $basedir/nginx/base/nginx $opradir/
ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx
else
break
fi
done
###########################################################部署配置文件
while :
do
read -p '请输入codekey(大写)：' codekey
read -p '请确认你的codekey：  ' codekey2
if [ "$codekey" != "$codekey2" ] ;then
echo '您两次输入的不一致，请确认。(按Ctrl+C结束)'
else
break
fi
done
echo "下载codekey:$codekey配置文件..."
sleep 1
wget -r -nH ftp://******/deployrepository/vhost/${codekey}\.conf --ftp-user=test01 --ftp-password=butterfly      #根据具体修改
if [ $? -eq 0 ] ;then
cp $basedir/vhost/${codekey}\.conf $opradir/nginx/conf/vhost/
else
echo "错误：找不到配置文件，请确认已将codekey:$codekey的配置文件上传到服务器。"
exit 2
fi
################################################################部署证书文件
echo '下载证书文件...'
sleep 1
wget -r -nH ftp://******/deployrepository/keys/$codekey/ --ftp-user=test01 --ftp-password=butterfly       #根据具体修改
if [ $? -eq 0 ] ;then
cp -r $basedir/keys/$codekey/ $opradir/nginx/conf/keys/
else
echo "没有找到codekey:$codekey的证书"
echo "注意：如果codekey:$codekey有证书，但没有导入到服务器上也按 n ;如果没有证书，则按 y 。"
fi
####################################################################

while :
do
read -p '是否继续？y/n' an
case $an in
y)
$opradir/nginx/sbin/nginx -t
if [ $? -eq 0 ] ;then
if [ -f $opradir/nginx/logs/nginx.pid ] ;then
rm -f $opradir/nginx/logs/nginx.pid
pkill -9 nginx
$opradir/nginx/sbin/nginx ;break
else
$opradir/nginx/sbin/nginx ;break
fi
else
echo "出现错误，请稍后自行启动服务"
exit 3
fi
;;
n)
echo '请稍后自行启动服务'
exit 4
;;
*)
echo '请输入 y 或 n '
;;
esac
done
netstat -antpu | grep nginx

