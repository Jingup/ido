#!/bin/bash
#rpm -q expect > /dev/null
#[ $? -ne 0 ] && yum -y install expect
#rpm -q ftp > /dev/null
#[ $? -ne 0 ] && yum -y install ftp
mysqldump -uroot -p'***' test > /data/backup/db/test.sql
sleep 1
cd /data/backup/
D=`date +%Y%m%d`
DM=`date -d "a month ago" +%Y%m%d`
ls test-$DM.tar.gz > /dev/null 2>&1
[ $? -eq 0 ] && rm -f test-$DM.tar.gz
tar -czf test-$D.tar.gz test/ db/
expect <<EOF
set timeout -1
spawn ftp *.*.*.* *
expect "Name" { send "rsync\r" }
expect "Password:" { send "***\r" }
expect "ftp>" { send "put test-$D.tar.gz\r" }
expect "ftp>" { send "exit\r" }
EOF

