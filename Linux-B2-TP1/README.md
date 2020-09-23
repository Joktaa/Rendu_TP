# 0. Prérequis
## Partitionnement
```
pvcreate /dev/sdb
vgcreate data /dev/sdb
lvcreate -L 2G data -n SRV
lvcreate -L 2.5G data -n HOME
mkfs -t ext4 /dev/data/SRV
mkfs -t ext4 /dev/data/HOME
mkdir /srv/data1
mkdir /srv/data2
mount /dev/data/SRV /srv/data1
mount /dev/data/HOME /srv/data2
```
```
[root@localhost ~]# cat /etc/fstab 
[...]
/dev/data/SRV /srv/data1 ext4 defaults 0 0
/dev/data/HOME /srv/data2 ext4 defaults 0 0

[root@localhost ~]# lvs
[...]                                                  
  HOME data   -wi-ao----  2.50g                                                    
  SRV  data   -wi-ao----  2.00g

[root@localhost ~]# mount -av
[...]
/srv/data1               : already mounted
/srv/data2               : already mounted
```

## Internet
```
[root@localhost ~]# ip a
[...]
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:4b:8f:05 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic enp0s3
       valid_lft 85453sec preferred_lft 85453sec
    inet6 fe80::a00:27ff:fe4b:8f05/64 scope link 
       valid_lft forever preferred_lft forever
[...]

[root@localhost ~]# ip r s
default via 10.0.2.2 dev enp0s3 proto dhcp metric 100 
[...]
```

## Réseau local
```
[root@localhost ~]# ping -c 2 192.168.1.12
PING 192.168.1.12 (192.168.1.12) 56(84) bytes of data.
64 bytes from 192.168.1.12: icmp_seq=1 ttl=64 time=0.905 ms
64 bytes from 192.168.1.12: icmp_seq=2 ttl=64 time=1.00 ms

--- 192.168.1.12 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.905/0.955/1.005/0.050 ms

[root@localhost ~]# ip a
[...]
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:a5:63:90 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.11/24 brd 192.168.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fea5:6390/64 scope link 
       valid_lft forever preferred_lft forever

[root@localhost ~]# ip r s
[...]
192.168.1.0/24 dev enp0s8 proto kernel scope link src 192.168.1.11 metric 101
```

## Hostname
```
[root@localhost ~]# hostname node1

[root@localhost ~]# echo "192.168.1.12 node2" >> /ect/hosts

[root@localhost ~]# ping -c 2 node2
PING node2 (192.168.1.12) 56(84) bytes of data.
64 bytes from node2 (192.168.1.12): icmp_seq=1 ttl=64 time=0.960 ms
64 bytes from node2 (192.168.1.12): icmp_seq=2 ttl=64 time=1.00 ms

--- node2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 0.960/0.982/1.004/0.022 ms
```

## Utilisateur
```
[root@localhost ~]# useradd joris
```
Taper visudo puis mettre "%joris ALL=(ALL) ALL".

## SSH
```
[joris@manjaro-dell ~]$ ssh-keygen -f TP1
[joris@manjaro-dell .ssh]$ ssh-copy-id -i TP1 root@192.168.1.11
[joris@manjaro-dell .ssh]$ ssh-copy-id -i TP1 root@192.168.1.12
```

## Pare-feu
```
[root@localhost ~]# firewall-cmd --add-port=22/tcp --permanent
[root@localhost ~]# firewall-cmd --reload
[root@localhost ~]# systemctl start firewalld
```

# I. Setup serveur Web
## Installation
```
[root@localhost ~]# yum install epel-release
[root@localhost ~]# yum install nginx
```