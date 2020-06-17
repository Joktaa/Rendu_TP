# Préparation de l'environnement
## client1.net1.tp3
- `ss -ltn`
```
State       Recv-Q Send-Q       Local Address:Port                      Peer Address:Port              
LISTEN      0      100              127.0.0.1:25                                   *:*                  
LISTEN      0      128                      *:7777                                 *:*                  
LISTEN      0      100                  [::1]:25                                [::]:*                  
LISTEN      0      128                   [::]:7777                              [::]:*
```

- `sudo firewall-cmd --list-all`

`ports: 7777/tcp`

- `hostname`

`client1.net1.tp3`

- `cat /etc/hosts`
```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 client1.net1.tp3
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6 client1.net1.tp3
```

- `ip a`
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:d2:c5:71 brd ff:ff:ff:ff:ff:ff
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:7e:c1:34 brd ff:ff:ff:ff:ff:ff
    inet 10.3.1.11/24 brd 10.3.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe7e:c134/64 scope link 
       valid_lft forever preferred_lft forever
```

- `ping -c 2 10.3.1.254`
```
PING 10.3.1.254 (10.3.1.254) 56(84) bytes of data.
64 bytes from 10.3.1.254: icmp_seq=1 ttl=64 time=0.201 ms
64 bytes from 10.3.1.254: icmp_seq=2 ttl=64 time=0.754 ms

--- 10.3.1.254 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.201/0.477/0.754/0.277 ms
```

## router.tp3
- `ping -c 2 10.3.1.11`
```
PING 10.3.1.11 (10.3.1.11) 56(84) bytes of data.
64 bytes from 10.3.1.11: icmp_seq=1 ttl=64 time=0.890 ms
64 bytes from 10.3.1.11: icmp_seq=2 ttl=64 time=0.729 ms

--- 10.3.1.11 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1003ms
rtt min/avg/max/mdev = 0.729/0.809/0.890/0.085 ms
```

- `ping -c 2 10.3.2.11`
```
PING 10.3.2.11 (10.3.2.11) 56(84) bytes of data.
64 bytes from 10.3.2.11: icmp_seq=1 ttl=64 time=0.461 ms
64 bytes from 10.3.2.11: icmp_seq=2 ttl=64 time=0.714 ms

--- 10.3.2.11 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1005ms
rtt min/avg/max/mdev = 0.461/0.587/0.714/0.128 ms
```

## server1.net2.tp3
- `ping -c 2 10.3.2.254`
```
PING 10.3.2.254 (10.3.2.254) 56(84) bytes of data.
64 bytes from 10.3.2.254: icmp_seq=1 ttl=64 time=0.260 ms
64 bytes from 10.3.2.254: icmp_seq=2 ttl=64 time=0.796 ms

--- 10.3.2.254 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 999ms
rtt min/avg/max/mdev = 0.260/0.528/0.796/0.268 ms
```

# I. Mise en place du routage
## 1. Configuration du routage sur router
- `sudo sysctl -w net.ipv4.conf.all.forwarding=1`

`net.ipv4.conf.all.forwarding = 1`

## 2. Ajouter les routes statiques
- client1 :
`echo "10.3.2.0/24 via 10.3.1.254 dev enp0s8" >> /etc/sysconfig/network-scripts/route-enp0s8; sudo systemctl restart network`
```
[joris@client1 ~]$ ip r s
10.3.1.0/24 dev enp0s8 proto kernel scope link src 10.3.1.11 metric 101 
10.3.2.0/24 via 10.3.1.254 dev enp0s8 proto static metric 101
```

- server1 :
`echo "10.3.1.0/24 via 10.3.2.254 dev enp0s8" >> /etc/sysconfig/network-scripts/route-enp0s8; sudo systemctl restart network`
```
[joris@server1 ~]$ ip r s
10.3.1.0/24 via 10.3.2.254 dev enp0s8 proto static metric 101 
10.3.2.0/24 dev enp0s8 proto kernel scope link src 10.3.2.11 metric 101
```

- vérifications
```
[joris@client1 ~]$ ping -c 2 10.3.2.11
PING 10.3.2.11 (10.3.2.11) 56(84) bytes of data.
64 bytes from 10.3.2.11: icmp_seq=1 ttl=63 time=0.501 ms
64 bytes from 10.3.2.11: icmp_seq=2 ttl=63 time=1.37 ms

--- 10.3.2.11 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1008ms
rtt min/avg/max/mdev = 0.501/0.937/1.373/0.436 ms
[joris@client1 ~]$ traceroute 10.3.2.11
traceroute to 10.3.2.11 (10.3.2.11), 30 hops max, 60 byte packets
 1  10.3.1.254 (10.3.1.254)  0.689 ms  0.354 ms  0.616 ms
 2  10.3.1.254 (10.3.1.254)  0.250 ms !X  0.413 ms !X  0.324 ms !X
```

## 3. Comprendre le routage
|       | MAC src | MAC dst | IP src | IP dst |
|-------|---------|---------|--------|--------|
| net1 | 08:00:27:7e:c1:34 | 08:00:27:9e:d0:6d | 10.3.1.11 | 10.3.2.11 |
| net2 | 08:00:27:89:54:b7 | 08:00:27:5b:6c:6b | 10.3.2.11 | 10.3.1.11 |

# II. ARP
## 1. Tables ARP
- client1.net.tp3
```
10.3.1.254 dev enp0s8 lladdr 08:00:27:9e:d0:6d REACHABLE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:02 REACHABLE
```
=> client1 connait la MAC du pc hôte et de son routeur sur la carte enp0s8

- server1.net1.tp3
```
10.3.2.1 dev enp0s8 lladdr 0a:00:27:00:00:03 DELAY
10.3.2.254 dev enp0s8 lladdr 08:00:27:89:54:b7 REACHABLE
```
=> server1 connait la MAC du pc hôte et de son routeur sur la carte enp0s8

- router.tp3
```
10.3.1.11 dev enp0s8 lladdr 08:00:27:7e:c1:34 DELAY
10.3.2.1 dev enp0s9 lladdr 0a:00:27:00:00:03 DELAY
10.3.2.11 dev enp0s9 lladdr 08:00:27:5b:6c:6b DELAY
```
=> router router connait client1 sur enp0s8, server1 sur enp0s9 et pc hôte sur enp0s9 (dû au ssh sur cette carte)

## 2. Requêtes ARP
### A. Table ARP 1
- avant le ping
```
[joris@client1 ~]$ ip neigh show
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:02 DELAY
```
- apres le ping
```
[joris@client1 ~]$ ip neigh show
10.3.1.254 dev enp0s8 lladdr 08:00:27:9e:d0:6d REACHABLE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:02 REACHABLE
```

### B. Table ARP 2
- avant le ping
```
[joris@server1 ~]$ ip neigh show
10.3.2.1 dev enp0s8 lladdr 0a:00:27:00:00:03 REACHABLE
```

- apres le ping
```
[joris@server1 ~]$ ip neigh show
10.3.2.1 dev enp0s8 lladdr 0a:00:27:00:00:03 REACHABLE
10.3.2.254 dev enp0s8 lladdr 08:00:27:89:54:b7 REACHABLE
```

### C. tcpdump 1
`sudo  tcpdump -i enp0s8`

```
14:50:18.832484 ARP, Request who-has router.tp3 tell 10.3.1.11, length 46
14:50:18.832855 ARP, Reply router.tp3 is-at 08:00:27:9e:d0:6d (oui Unknown), length 28
```
=> requête 1 : 10.3.1.11 demande qui a 10.3.1.254
=> requête 2 : 10.3.1.254 repond que cette IP est à 08:00:27:9e:d0:6d

### D. tcpdump 2
`sudo  tcpdump -i enp0s9 dst 10.3.2.11 or src 10.3.2.11`

```
14:38:06.580123 ARP, Request who-has 10.3.2.11 tell router.tp3, length 28
14:38:06.580682 ARP, Reply 10.3.2.11 is-at 08:00:27:5b:6c:6b (oui Unknown), length 46
```
=> requête 1 : router demande qui a 10.3.2.11
=> requête 2 : 10.3.2.11 repond que cette IP est à 08:00:27:5b:6c:6b

### E. u okay bro ?
10.3.1.11 demande qui a 10.3.1.254 => 10.3.1.254 donne son adresse MAC => 10.3.2.254 demande qui a 10.3.2.11 => 10.3.2.11 donne son adresse MAC

# Entracte : Donner un accès internet aux VMs
- router
`sudo ifup enp0s3`
`sudo firewall-cmd --add-masquerade --permanent`
`firewall-cmd --reload`

- client 1
`sudo echo "GATEWAY=10.3.1.254" >> /etc/sysconfig/network`
`sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf`
`sudo systemctl restart network`

- vérification
```
[joris@client1 ~]$ ping -c 1 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=61 time=12.6 ms

--- 8.8.8.8 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 12.684/12.684/12.684/0.000 ms
```

```
[joris@client1 ~]$ dig google.com

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 54881
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		128	IN	A	216.58.198.206

;; Query time: 17 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: lun. mars 16 16:01:59 CET 2020
;; MSG SIZE  rcvd: 55

```

# III. Plus de tcpdump
## 1. TCP et UDP
### B. Analyse de trames
- TCP
```
16:49:15.003955 IP 10.3.1.11.54412 > 10.3.2.11.distinct: Flags [S], seq 963407032, win 29200, options [mss 1460,sackOK,TS val 5105676 ecr 0,nop,wscale 6], length 0
16:49:15.004885 IP 10.3.2.11.distinct > 10.3.1.11.54412: Flags [S.], seq 3543794901, ack 963407033, win 28960, options [mss 1460,sackOK,TS val 10667151 ecr 5105676,nop,wscale 6], length 0
16:49:15.005405 IP 10.3.1.11.54412 > 10.3.2.11.distinct: Flags [.], ack 1, win 457, options [nop,nop,TS val 5105680 ecr 10667151], length 0
16:49:17.627542 IP 10.3.1.11.54412 > 10.3.2.11.distinct: Flags [P.], seq 1:7, ack 1, win 457, options [nop,nop,TS val 5108302 ecr 10667151], length 6
16:49:17.628267 IP 10.3.2.11.distinct > 10.3.1.11.54412: Flags [.], ack 7, win 453, options [nop,nop,TS val 10669774 ecr 5108302], length 0
16:49:19.606636 IP 10.3.1.11.54412 > 10.3.2.11.distinct: Flags [F.], seq 7, ack 1, win 457, options [nop,nop,TS val 5110281 ecr 10669774], length 0
16:49:19.607411 IP 10.3.2.11.distinct > 10.3.1.11.54412: Flags [F.], seq 1, ack 8, win 453, options [nop,nop,TS val 10671753 ecr 5110281], length 0
16:49:19.608288 IP 10.3.1.11.54412 > 10.3.2.11.distinct: Flags [.], ack 2, win 457, options [nop,nop,TS val 5110283 ecr 10671753], length 0
```
=> Les trois premiers messages sont le 3-way-handshake
=> Les deux suivants représentent un message envoyé + ack
=> Les deux derniers sont le message de fin + ack

- udp
```
16:56:20.726151 IP 10.3.1.11.40881 > 10.3.2.11.distinct: UDP, length 6
16:56:20.727274 IP 10.3.2.11.distinct > 10.3.1.11.40881: UDP, length 6
```
=> Les deux paquets sont des messages, il n'y a pas d'ack, pas d'initialisation de la connexion et pas de fin de connexion

## 2. SSH
```
17:00:31.224228 IP 10.3.1.11.46168 > 10.3.2.11.cbt: Flags [S], seq 3662403746, win 29200, options [mss 1460,sackOK,TS val 5781896 ecr 0,nop,wscale 6], length 0
17:00:31.225156 IP 10.3.2.11.cbt > 10.3.1.11.46168: Flags [S.], seq 2303616313, ack 3662403747, win 28960, options [mss 1460,sackOK,TS val 11343371 ecr 5781896,nop,wscale 6], length 0
17:00:31.225740 IP 10.3.1.11.46168 > 10.3.2.11.cbt: Flags [.], ack 1, win 457, options [nop,nop,TS val 5781901 ecr 11343371], length 0
.
.
.
17:00:34.283022 IP 10.3.1.11.46168 > 10.3.2.11.cbt: Flags [.], ack 2758, win 582, options [nop,nop,TS val 5784958 ecr 11346427], length 0
17:00:34.286062 IP 10.3.2.11.cbt > 10.3.1.11.46168: Flags [P.], seq 2758:2834, ack 3094, win 545, options [nop,nop,TS val 11346431 ecr 5784958], length 76
17:00:34.286429 IP 10.3.1.11.46168 > 10.3.2.11.cbt: Flags [.], ack 2834, win 582, options [nop,nop,TS val 5784961 ecr 11346431], length 0
```
=> on peut voir des ack, c'est donc une connexion tcp