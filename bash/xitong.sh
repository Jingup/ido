#!/bin/bash
firewall-cmd --permanent --add-port=222/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=9999/tcp
firewall-cmd --reload
sed -i '7s/enforcing/disabled/' /etc/selinux/config
setenforce 0
sed -i '17c Port 222' /etc/ssh/sshd_config
systemctl restart sshd
ulimit -Hn 65535
ulimit -Sn 65535
sed -i 's/4096/65535/' /etc/security/limits.d/20-nproc.conf
cp /etc/security/limits.conf /etc/security/limits.conf.default
cat >/etc/security/limits.conf<<EOF
*               soft    nofile          65535
*               hard    nofile          65535
*               soft    nproc           65535
*               hard    nproc           65535
EOF