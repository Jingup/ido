#!/bin/bash
mysqldump -uroot -p'***' crane > /data/backup/db/crane.sql
sleep 1
cd /data/backup/
D=`date +%Y%m%d`
DM=`date -d "a month ago" +%Y%m%d`
ls crane-$DM.tar.gz >&2 /dev/null
[ $? -eq 0 ] && rm -f crane-$DM.tar.gz
tar -czf crane-$D.tar.gz crane/ db/
expect <<EOF
set timeout -1
spawn ftp *.*.*.* *
expect "Name" { send "rsync\r" }
expect "Password:" { send "***\r" }
expect "ftp>" { send "put crane-$D.tar.gz\r" }
expect "ftp>" { send "exit\r" }
EOF
