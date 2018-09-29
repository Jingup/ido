#/bin/bash
LOG_PATH=/usr/local/nginx/logs/
PID=`cat /usr/local/nginx/logs/nginx.pid`
cd $LOG_PATH
for i in `ls *.log`
do
dir=`ls $i | awk -F. '{print $1}'`
[ ! -d $dir/`date +%F` ] && mkdir -p $dir/`date +%F`
mv $i $dir/`date +%F`/`date +_%H:%M:%S`.log
done
kill -USR1 $PID