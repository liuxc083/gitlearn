#!/bin/bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache fast

systemctl stop firewalld
systemctl disable firewalld
systemctl stop NetworkManager
systemctl disable NetworkManager
yum install -y iptables iptables-services
service iptables save
iptables -F
iptables -L -n
echo "防火墙关闭和防火墙开机关闭"
sed -i "s/enforcing/disabled/g" /etc/sysconfig/selinux
sed -i "s/enforcing/disabled/g" /etc/selinux/config
echo "关闭selinux"

yum install -y ntpdate
echo '#time sync' >>/var/spool/cron/root
echo '*/5 * * * * /usr/sbin/ntpdate ntp1.aliyun.com >/dev/null 2>&1' >>/var/spool/cron/root
#查看修改：
crontab -l
