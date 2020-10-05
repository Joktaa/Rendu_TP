# TP3 : systemd
## 0. Prérequis
La configuration de la VM utilisée se trouve dans le dossier Used_Box. Elle inclus un update, l'installation de plusieurs logiciel (vim, epel-release, nginx), la désactivation de selinux, et l'ouverture des ports 22, 80, 443
## I. Services systemd
### 1. Intro
* Nombre de services disponibles
```
[vagrant@localhost ~]$ systemctl list-unit-files --type=service | tail -1 | cut -d " " -f 1
156
```
* Nombre de services actifs
```
[vagrant@localhost ~]$ systemctl -t service --all | grep running | wc -l
17
```
* Nombre de service failed ou inactif
```
[vagrant@localhost ~]$ systemctl -t service --all | grep -E 'inactive|failed' | wc -l
73
```
* Nombre de service enabled
```
[vagrant@localhost ~]$ systemctl list-unit-files --type=service | grep enabled | wc -l
32
```

### 2. Analyse d'un service
#### Path de l'unité nginx.service
```
[vagrant@localhost ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
```
Cette unité se situe donc ici : `/usr/lib/systemd/system/nginx.service`

#### Analyse du code
```
[vagrant@localhost ~]$ systemctl cat nginx
# /usr/lib/systemd/system/nginx.service
[Unit]
Description=The nginx HTTP and reverse proxy server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
# Nginx will fail to start if /run/nginx.pid already exists but has the wrong
# SELinux context. This might happen when running `nginx -t` from the cmdline.
# https://bugzilla.redhat.com/show_bug.cgi?id=1268621
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx 
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=process
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

* ExecStart
`ExecStart=/usr/sbin/nginx ` => commande à lancer lors de `systemctl start nginx`

* ExecStartPre
```
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
```
=> Commande à lance en amont de la commande ExecStart. Ici, on supprime le PID actuel de nginx (s'il existe), et on vérifie la conf de nginx.

* PIDFile
`PIDFile=/run/nginx.pid` => chemin absolu vers le fichier contenant le PID, actuellement, nginx à le PID 26127
```
[vagrant@localhost ~]$ cat /run/nginx.pid
26127
```

* Type
`Type=forking` => cela signifie que ce processus va créer d'autres processus enfant par duplication via la fonction fork()

* ExecReload
`ExecReload=/bin/kill -s HUP $MAINPID` => commande à lancer lors de `systemctl reload nginx`

* Description
`Description=The nginx HTTP and reverse proxy server` => courte description du service

* After
`After=network.target remote-fs.target nss-lookup.target` => vérifie que les services dont dépendent nginx ont fini d'être exéctuté

#### Liste des services utilisant `WantedBy=multi-user.target`
```
[vagrant@localhost system]$ grep 'WantedBy=multi-user.target' -r . | grep 'service' | cut -d ":" -f 1 | cut -d "/" -f 2
rpcbind.service
rdisc.service
tcsd.service
sshd.service
rhel-configure.service
rsyslog.service
irqbalance.service
cpupower.service
crond.service
rpc-rquotad.service
wpa_supplicant.service
chrony-wait.service
chronyd.service
NetworkManager.service
ebtables.service
gssproxy.service
tuned.service
firewalld.service
nfs-server.service
vboxadd-service.service
rsyncd.service
nginx.service
vmtoolsd.service
postfix.service
auditd.service
vboxadd.service
```

### 3. Création d'un service