#!/bin/bash
watch_dir=/data/fs/crane
sync_dir=/data/backup
 
# First to do is initial sync
rsync -az --delete --exclude="file/common/" $watch_dir $sync_dir
 
inotifywait -mrq -e delete,close_write,moved_to,moved_from,isdir --timefmt '%Y-%m-%d %H:%M:%S' --format '%w%f:%e:%T' $watch_dir \
--exclude="./file/common/*" >>/data/backup/inotifywait.log &
 
while true;do
     if [ -s "/data/backup/inotifywait.log" ];then
        grep -i -E "delete|moved_from" /data/backup/inotifywait.log >> /data/backup/inotify_away.log
        rsync -az --delete --exclude="file/common/" $watch_dir $sync_dir
        if [ $? -ne 0 ];then
           echo "$watch_dir sync to $sync_dir failed at `date +"%F %T"`,please check it by manual" |\
           mail -s "inotify+Rsync error has occurred" root@localhost
        fi
        cat /dev/null > /data/backup/inotifywait.log
        rsync -az --delete --exclude="file/common/" $watch_dir $sync_dir
    else
        sleep 30
    fi
done
