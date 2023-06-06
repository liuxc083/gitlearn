#!/bin/sh
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
sleep 1
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all 
sleep 5
yum makecache fast
sleep 3

setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

grep SELINUX=disabled /etc/selinux/config
getenforce

systemctl stop firewalld
systemctl disable firewalld
sleep 2

iptables -F
iptables -L -n
sleep 2

echo $LANG
sleep 3

sed -i 's@#UseDNS yes@UseDNS no@g;s@^GSSAPIAuthentication yes@GSSAPIAuthentication no@g' /etc/ssh/sshd_config
systemctl restart sshd
sleep 3

yum install -y ntpdate
echo '#time sync' >>/var/spool/cron/root
echo '*/5 * * * * /usr/sbin/ntpdate ntp1.aliyun.com >/dev/null 2>&1' >>/var/spool/cron/root
crontab -l
sleep 1

yum install -y lrzsz nmap tree dos2unix nc telnet wget lsof ntpdate bash-completion bash-completion-extras
sleep 5
yum install -y psmisc net-tools bash-completion vim-enhanced route
sleep 5

systemctl list-unit-files |grep enable|egrep -v "sshd.service|crond.service|sysstat|rsyslog|^NetworkManager.service|irqbalance.service"|awk '{print "systemctl disable",$1}'|bash
systemctl list-unit-files |grep enable
sleep 2

systemctl set-default multi-user.target
rm -fr /etc/systemd/system/default.target
ln -sf /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
ln -sf /lib/systemd/system/runlevel3.target /etc/systemd/system/default.target
systemctl get-default
sleep 2
