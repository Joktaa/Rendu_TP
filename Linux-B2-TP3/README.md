# TP3 : systemd
# 0. Prérequis
La configuration de la VM utilisée se trouve dans le dossier Used_Box. Elle inclus un update, l'installation de plusieurs logiciel (vim, epel-release, nginx), la désactivation de selinux, et l'ouverture des ports 22, 80, 443
# I. Services systemd
## 1. Intro
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

## 2. Analyse d'un service
### Path de l'unité nginx.service
```
[vagrant@localhost ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
```
Cette unité se situe donc ici : `/usr/lib/systemd/system/nginx.service`

### Analyse du code
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

### Liste des services utilisant `WantedBy=multi-user.target`
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

## 3. Création d'un service
### A. Serveur web
* Le code dudit service est à retrouver dans ./systemd/units/server-wer.service
* Tests
```
[vagrant@localhost system]$ sudo systemctl status server-web.service
● server-web.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/etc/systemd/system/server-web.service; enabled; vendor preset: disabled)
   Active: activating (start) since Wed 2020-10-07 10:10:52 UTC; 3s ago
  Control: 5130 (python3)
   CGroup: /system.slice/server-web.service
           └─5130 /usr/bin/python3 -m http.server 35587

Oct 07 10:10:52 localhost.localdomain systemd[1]: Starting The nginx HTTP and reverse proxy server...

[vagrant@localhost system]$ curl http://localhost:35587
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
[...]
</body>
</html>
```

### B. Sauvegarde
* Les unités sont à retrouver dans ./systemd/units/backup.*
* Les scripts de backup sont à retrouver dans ./systemd/scripts/

# II. Autres features
## 1. Gestion de boot
```
[vagrant@localhost ~]$ systemd-analyze plot | grep -G '[^(]..ms'
<text x="20" y="50">Startup finished in 386ms (kernel) + 1.240s (initrd) + 3.202s (userspace) = 4.830s
  <text class="left" x="218.036" y="314.000">systemd-udev-trigger.service (224ms)</text>
  <text class="left" x="225.343" y="554.000">systemd-hwdb-update.service (521ms)</text>
  <text class="left" x="236.916" y="754.000">import-state.service (112ms)</text>
  <text class="left" x="236.970" y="774.000">ldconfig.service (197ms)</text>
  <text class="left" x="273.867" y="874.000">systemd-update-utmp.service (9ms)</text>
  <text class="left" x="282.024" y="1034.000">sshd-keygen@ed25519.service (232ms)</text>
  <text class="left" x="283.191" y="1074.000">sshd-keygen@ecdsa.service (222ms)</text>
  <text class="left" x="284.894" y="1094.000">sshd-keygen@rsa.service (683ms)</text>
  <text class="left" x="289.204" y="1134.000">NetworkManager.service (373ms)</text>
  <text class="left" x="326.687" y="1214.000">NetworkManager-wait-online.service (520ms)</text>
  <text class="left" x="374.218" y="1274.000">systemd-logind.service (301ms)</text>
  <text class="left" x="378.985" y="1334.000">kdump.service (137ms)</text>
```
On filtre les services ayant une centaine dans les milisecondes. On trouve donc les trois plus lents services : `sshd-keygen@rsa.service`, `systemd-hwdb-update.service`, et `NetworkManager-wait-online.service`
  
## 2. Gestion de l'heure
```
[vagrant@localhost ~]$ timedatectl
               Local time: Wed 2020-10-07 16:21:29 UTC
           Universal time: Wed 2020-10-07 16:21:29 UTC
                 RTC time: Wed 2020-10-07 16:21:20
                Time zone: UTC (UTC, +0000)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```
On peut voir que je suis sur le fuseau horaire UTC +0, et que je suis synchronisé au serveur NTP.
Pour changer de fuseau horaire, je fais :
```
[vagrant@localhost ~]$ timedatectl list-timezones | grep Paris
Europe/Paris

[vagrant@localhost ~]$ timedatectl set-timezone "Europe/Paris"

[vagrant@localhost ~]$ timedatectl 
               Local time: Wed 2020-10-07 18:37:28 CEST
           Universal time: Wed 2020-10-07 16:37:28 UTC
                 RTC time: Wed 2020-10-07 16:37:19
                Time zone: Europe/Paris (CEST, +0200)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no

```

## 3. Gestion des noms et de la résolution de noms
```
[vagrant@localhost ~]$ hostnamectl 
   Static hostname: localhost.localdomain
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 35f923f3e65348e891597dff8e12e0c8
           Boot ID: 252745dae53b44359f04b0fe2d3a40c4
    Virtualization: oracle
  Operating System: CentOS Linux 8 (Core)
       CPE OS Name: cpe:/o:centos:centos:8
            Kernel: Linux 4.18.0-80.el8.x86_64
      Architecture: x86-64
```
Mon hostname est `localhost.localdomain`

Pour changer de hostname, un petit tour sur le man avec `/change`, et on trouve la commande `hostnamectl set-hostname NAME`
```
[vagrant@localhost ~]$ sudo hostnamectl set-hostname centos8_TP3
[vagrant@localhost ~]$ hostnamectl 
   Static hostname: centos8_TP3
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 35f923f3e65348e891597dff8e12e0c8
           Boot ID: 252745dae53b44359f04b0fe2d3a40c4
    Virtualization: oracle
  Operating System: CentOS Linux 8 (Core)
       CPE OS Name: cpe:/o:centos:centos:8
            Kernel: Linux 4.18.0-80.el8.x86_64
      Architecture: x86-64
```