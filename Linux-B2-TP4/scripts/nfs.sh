#!/bin/sh

echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.1.1 node4.nfs node4
192.168.10.11 node1.gitea node1
192.168.10.12 node2.db node2
192.168.10.13 node3.rproxy node3" > /etc/hosts

yum install -y nfs-utils

systemctl start nfs-server rpcbind
systemctl enable nfs-server rpcbind

mkdir gitea
mkdir db
mkdir nginx

chmod 777 ./gitea
chmod 777 ./db
chmod 777 ./nginx

echo "/home/vagrant/gitea 192.168.10.11(rw,sync,no_root_squash)
/home/vagrant/db 192.168.10.12(rw,sync,no_root_squash)
/home/vagrant/nginx 192.168.10.13(rw,sync,no_root_squash)" > /etc/exports

exportfs -r

firewall-cmd --permanent --add-service mountd
firewall-cmd --permanent --add-service rpc-bind
firewall-cmd --permanent --add-service nfs
firewall-cmd --reload
chmod 777 ./gitea

bash <(curl -Ss https://my-netdata.io/kickstart.sh)
echo 'SEND_DISCORD="YES"
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/759798426551451699/GRDMN87WJuEPqI20wMEuFjTSWcb58TrMGmcYf5mMcHrhk3T-8dGHqy5ADgUwKwy0KGHu"
DEFAULT_RECIPIENT_DISCORD="alarms"' > /etc/netdata/health_alarm_notify.conf

