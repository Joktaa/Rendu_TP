# Self-footprinting
## Host OS
* Nom de la machine
```
joris@ubuntu-dell:~$ hostname
ubuntu-dell
```

* OS et version
```
joris@ubuntu-dell:~$ lsb_release -d
Description:	Ubuntu 18.04.4 LTS
```

* Architecture processeur
```
joris@ubuntu-dell:~$ lscpu | grep Architecture
Architecture:        x86_64
```

* Modèle du processeur
```
joris@ubuntu-dell:~$ lscpu | grep "Model name"
Model name:          Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
```

* Quantité RAM et modèle de la RAM
```
joris@ubuntu-dell:~$ sudo dmidecode --type memory | grep Size
	Size: 16384 MB
joris@ubuntu-dell:~$ sudo dmidecode --type memory | grep Type:
    Type: DDR4
```

## Devices
* Marque et modèle du processeur
```
joris@ubuntu-dell:~$ lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
CPU(s):              12
Thread(s) per core:  2
Core(s) per socket:  6
Socket(s):           1
Model name:          Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
```
Il y a un processeur à 6 coeurs.
C'est un processeur intel de type core i7 de 9ème génération avec une fréquence de base de 2.60GHz.

* Marque et modèle du touchpad
```
joris@ubuntu-dell:~$ xinput list | grep Touchpad
⎜   ↳ DELL0922:00 04F3:30E3 Touchpad          	id=14	[slave  pointer  (2)]
```

* Marque et modèle des enceintes
```
joris@ubuntu-dell:~$ lspci | grep audio
00:1f.3 Multimedia audio controller: Intel Corporation Cannon Lake PCH cAVS (rev 10)
```

* Marque et modèle du disque dur
Dans l'application 'disks' à `/dev/nvme0n1`: `KBG40ZNS512G NVMe TOSHIBA 512GB`

* Partitions du disque dur
Toujours dans disks : 
`/dev/nvme0n1p1` est une partition en FAT32 de 537MB de type EFI, elle permet donc le boot.
`/dev/nvme0n1p2` est une partition en Ext4 de 512GB de type Linux Filesystem, elle perrmet donc le stockage des fichiers linux et utilisateurs.

## Network
* Cartes réseau
```
joris@ubuntu-dell:~$ ip a
1: lo
...
2: wlo1
...
```
lo correspond à loopback, c'est l'interface permettant à l'ordinateur d'envoyer des messages à lui-même.
wlo1 correspond à l'interface sans-fil, c'est elle qui est relié à ma box.

* Ports
```
joris@ubuntu-dell:~$ sudo ss -ltpun
[sudo] password for joris: 
Netid  State    Recv-Q   Send-Q      Local Address:Port      Peer Address:Port                                                                                  
udp    UNCONN   0        0                 0.0.0.0:47164          0.0.0.0:*      users:(("avahi-daemon",pid=864,fd=14))                                         
udp    UNCONN   0        0           127.0.0.53%lo:53             0.0.0.0:*      users:(("systemd-resolve",pid=696,fd=12))                                      
udp    UNCONN   0        0                 0.0.0.0:68             0.0.0.0:*      users:(("dhclient",pid=1459,fd=6))                                             
udp    UNCONN   0        0                 0.0.0.0:57621          0.0.0.0:*      users:(("spotify",pid=7716,fd=84))                                             
udp    UNCONN   0        0                 0.0.0.0:34658          0.0.0.0:*      users:(("spotify",pid=7716,fd=110))                                            
udp    UNCONN   0        0             224.0.0.251:5353           0.0.0.0:*      users:(("chrome",pid=3836,fd=30))                                              
udp    UNCONN   0        0             224.0.0.251:5353           0.0.0.0:*      users:(("chrome",pid=3663,fd=107))                                             
udp    UNCONN   0        0                 0.0.0.0:5353           0.0.0.0:*      users:(("spotify",pid=7716,fd=111))                                            
udp    UNCONN   0        0                 0.0.0.0:5353           0.0.0.0:*      users:(("avahi-daemon",pid=864,fd=12))                                         
udp    UNCONN   0        0                    [::]:55994             [::]:*      users:(("avahi-daemon",pid=864,fd=15))                                         
udp    UNCONN   0        0                    [::]:5353              [::]:*      users:(("avahi-daemon",pid=864,fd=13))                                         
tcp    LISTEN   0        128               0.0.0.0:45433          0.0.0.0:*      users:(("spotify",pid=7716,fd=95))                                             
tcp    LISTEN   0        128             127.0.0.1:6463           0.0.0.0:*      users:(("Discord",pid=11430,fd=94))                                            
tcp    LISTEN   0        10                0.0.0.0:57621          0.0.0.0:*      users:(("spotify",pid=7716,fd=85))                                             
tcp    LISTEN   0        128         127.0.0.53%lo:53             0.0.0.0:*      users:(("systemd-resolve",pid=696,fd=13))                                      
tcp    LISTEN   0        5               127.0.0.1:631            0.0.0.0:*      users:(("cupsd",pid=10917,fd=7))                                               
tcp    LISTEN   0        5                   [::1]:631               [::]:*      users:(("cupsd",pid=10917,fd=6))
```
- avahi-daemon est un service qui permet de découvrir des services et des hôtes sur un réseau local.
- systemd-resolve est un service permettant la résolution de nom sur les applications locales
- spotify est mon logiciel de streaming musical
- dhcplient est le client dhcp qui me permet d'avoir une ip sur mon réseau
- chrome est le service chromium qui est mon navigateur
- discord est mon logiciel de tchat
- cupsd est un serveur d'imprimante

## Users
```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
...
joris:x:1000:1000:joris,,,:/home/joris:/bin/bash
nvidia-persistenced:x:122:129:NVIDIA Persistence Daemon,,,:/nonexistent:/sbin/nologin
```
L'utilisateur full admin est root

## Processus
```
joris@ubuntu-dell:~$ pstree
systemd─┬─ModemManager───2*[{ModemManager}]
        ├─NetworkManager─┬─dhclient
        │                └─2*[{NetworkManager}]
        ├─accounts-daemon───2*[{accounts-daemon}]
        ├─acpid
        ├─avahi-daemon───avahi-daemon
        ├─bluetoothd
        ├─boltd───2*[{boltd}]
        ├─colord───2*[{colord}]
        ├─cron
        ├─cupsd───3*[dbus]
        ├─dbus-daemon
        ├─fwupd───4*[{fwupd}]
        ├─gdm3─┬─gdm-session-wor─┬─gdm-wayland-ses─┬─gnome-session-b─┬─gnome-sh+
        │      │                 │                 │                 ├─gsd-a11y+
        │      │                 │                 │                 ├─gsd-clip+
        │      │                 │                 │                 ├─gsd-colo+
        │      │                 │                 │                 ├─gsd-date+
        │      │                 │                 │                 ├─gsd-hous+
        │      │                 │                 │                 ├─gsd-keyb+
        │      │                 │                 │                 ├─gsd-medi+
        │      │                 │                 │                 ├─gsd-mous+
        │      │                 │                 │                 ├─gsd-powe+
        │      │                 │                 │                 ├─gsd-prin+
        │      │                 │                 │                 ├─gsd-rfki+
        │      │                 │                 │                 ├─gsd-scre+
        │      │                 │                 │                 ├─gsd-shar+
        │      │                 │                 │                 ├─gsd-smar+
        │      │                 │                 │                 ├─gsd-soun+
        │      │                 │                 │                 ├─gsd-waco+
        │      │                 │                 │                 ├─gsd-xset+
        │      │                 │                 │                 └─3*[{gnom+
        │      │                 │                 └─2*[{gdm-wayland-ses}]
        │      │                 └─2*[{gdm-session-wor}]
        │      ├─gdm-session-wor─┬─gdm-x-session─┬─Xorg───{Xorg}
        │      │                 │               ├─gnome-session-b─┬─gnome-shel+
        │      │                 │               │                 ├─gnome-soft+
        │      │                 │               │                 ├─gsd-a11y-s+
        │      │                 │               │                 ├─gsd-clipbo+
        │      │                 │               │                 ├─gsd-color─+++
        │      │                 │               │                 ├─gsd-dateti+
        │      │                 │               │                 ├─gsd-disk-u+
        │      │                 │               │                 ├─gsd-housek+
        │      │                 │               │                 ├─gsd-keyboa+
        │      │                 │               │                 ├─gsd-media-+
        │      │                 │               │                 ├─gsd-mouse─+++
        │      │                 │               │                 ├─gsd-power─+++
        │      │                 │               │                 ├─gsd-print-+
        │      │                 │               │                 ├─gsd-rfkill+++
        │      │                 │               │                 ├─gsd-screen+
        │      │                 │               │                 ├─gsd-sharin+
        │      │                 │               │                 ├─gsd-smartc+
        │      │                 │               │                 ├─gsd-sound─+++
        │      │                 │               │                 ├─gsd-wacom─+++
        │      │                 │               │                 ├─gsd-xsetti+
        │      │                 │               │                 ├─nautilus-d+
        │      │                 │               │                 ├─ssh-agent
        │      │                 │               │                 ├─update-not+
        │      │                 │               │                 └─3*[{gnome-+
        │      │                 │               └─2*[{gdm-x-session}]
        │      │                 └─2*[{gdm-session-wor}]
        │      └─2*[{gdm3}]
        ├─gnome-keyring-d───3*[{gnome-keyring-d}]
        ├─gsd-printer───2*[{gsd-printer}]
        ├─ibus-x11───3*[{ibus-x11}]
        ├─ibus-x11───2*[{ibus-x11}]
        ├─irqbalance───{irqbalance}
        ├─2*[kerneloops]
        ├─networkd-dispat───{networkd-dispat}
        ├─nvidia-persiste
        ├─packagekitd───2*[{packagekitd}]
        ├─polkitd───2*[{polkitd}]
        ├─pulseaudio───3*[{pulseaudio}]
        ├─rsyslogd───3*[{rsyslogd}]
        ├─rtkit-daemon───2*[{rtkit-daemon}]
        ├─snapd───37*[{snapd}]
        ├─systemd─┬─(sd-pam)
        │         ├─at-spi-bus-laun─┬─dbus-daemon
        │         │                 └─3*[{at-spi-bus-laun}]
        │         ├─at-spi2-registr───2*[{at-spi2-registr}]
        │         ├─dbus-daemon
        │         ├─ibus-portal───2*[{ibus-portal}]
        │         ├─pulseaudio───3*[{pulseaudio}]
        │         └─xdg-permission-───2*[{xdg-permission-}]
        ├─systemd─┬─(sd-pam)
        │         ├─XMind─┬─XMind───XMind
        │         │       ├─XMind─┬─XMind
        │         │       │       └─7*[{XMind}]
        │         │       ├─XMind───13*[{XMind}]
        │         │       ├─XMind───17*[{XMind}]
        │         │       └─30*[{XMind}]
        │         ├─at-spi-bus-laun─┬─dbus-daemon
        │         │                 └─3*[{at-spi-bus-laun}]
        │         ├─at-spi2-registr───2*[{at-spi2-registr}]
        │         ├─code─┬─code
        │         │      ├─code───6*[{code}]
        │         │      ├─code───5*[{code}]
        │         │      ├─code─┬─code───16*[{code}]
        │         │      │      ├─code───11*[{code}]
        │         │      │      └─23*[{code}]
        │         │      ├─code───19*[{code}]
        │         │      └─27*[{code}]
        │         ├─dbus-daemon
        │         ├─dconf-service───2*[{dconf-service}]
        │         ├─evolution-addre─┬─evolution-addre───5*[{evolution-addre}]
        │         │                 └─4*[{evolution-addre}]
        │         ├─evolution-calen─┬─evolution-calen───8*[{evolution-calen}]
        │         │                 └─4*[{evolution-calen}]
        │         ├─evolution-sourc───3*[{evolution-sourc}]
        │         ├─gnome-shell-cal───5*[{gnome-shell-cal}]
        │         ├─gnome-terminal-─┬─bash───pstree
        │         │                 └─3*[{gnome-terminal-}]
        │         ├─goa-daemon───3*[{goa-daemon}]
        │         ├─goa-identity-se───3*[{goa-identity-se}]
        │         ├─gvfs-afc-volume───3*[{gvfs-afc-volume}]
        │         ├─gvfs-goa-volume───2*[{gvfs-goa-volume}]
        │         ├─gvfs-gphoto2-vo───2*[{gvfs-gphoto2-vo}]
        │         ├─gvfs-mtp-volume───2*[{gvfs-mtp-volume}]
        │         ├─gvfs-udisks2-vo───2*[{gvfs-udisks2-vo}]
        │         ├─gvfsd─┬─gvfsd-http───3*[{gvfsd-http}]
        │         │       ├─gvfsd-trash───2*[{gvfsd-trash}]
        │         │       └─2*[{gvfsd}]
        │         ├─gvfsd-fuse───5*[{gvfsd-fuse}]
        │         ├─ibus-portal───2*[{ibus-portal}]
        │         ├─obexd
        │         ├─snap───9*[{snap}]
        │         ├─xdg-document-po───5*[{xdg-document-po}]
        │         └─xdg-permission-───2*[{xdg-permission-}]
        ├─systemd-journal
        ├─systemd-logind
        ├─systemd-resolve
        ├─systemd-timesyn───{systemd-timesyn}
        ├─systemd-udevd
        ├─thermald───{thermald}
        ├─udisksd───4*[{udisksd}]
        ├─unattended-upgr───{unattended-upgr}
        ├─upowerd───2*[{upowerd}]
        ├─whoopsie───2*[{whoopsie}]
        └─wpa_supplicant

```

- polkitd : ce processus gére la communication entre les processus ayant des
privilèges et ceux n'en ayant pas.
- pulsaudio : ce processus gére les entrées et sorties audio.
- udisksd : ce processus implemente les interface permettant de questionner et manipuler un systeme de stockage.
- cron : ce processus permet d'executer une action dans un certain délai.
- gdm3 : ce processus gère la connexion en mode graphique et l'authentification des utilisateurs.
- cupsd : ce processus gère le serveur d'impression.
- avahi-daemon : ce processus gère la reconnaissance d'hôte est de services sur le réseau.

Les processus lancées par root:
```
joris@ubuntu-dell:~$ ps -u 0
  PID TTY          TIME CMD
    1 ?        00:00:24 systemd
    2 ?        00:00:00 kthreadd
    3 ?        00:00:00 rcu_gp
    4 ?        00:00:00 rcu_par_gp
    6 ?        00:00:00 kworker/0:0H-kb
    9 ?        00:00:00 mm_percpu_wq
   10 ?        00:00:00 ksoftirqd/0
   11 ?        00:00:01 rcu_sched
   12 ?        00:00:00 migration/0
   13 ?        00:00:00 idle_inject/0
   14 ?        00:00:00 cpuhp/0
   15 ?        00:00:00 cpuhp/1
   16 ?        00:00:00 idle_inject/1
   17 ?        00:00:00 migration/1
   18 ?        00:00:00 ksoftirqd/1
   20 ?        00:00:00 kworker/1:0H-kb
   21 ?        00:00:00 cpuhp/2
   22 ?        00:00:00 idle_inject/2
   23 ?        00:00:00 migration/2
   24 ?        00:00:00 ksoftirqd/2
   26 ?        00:00:00 kworker/2:0H-kb
   27 ?        00:00:00 cpuhp/3
   28 ?        00:00:00 idle_inject/3
   29 ?        00:00:00 migration/3
   30 ?        00:00:00 ksoftirqd/3
   ...
   10916 ?        00:00:00 kworker/u24:0-e
   10917 ?        00:00:00 cupsd
10969 ?        00:00:00 kworker/10:1-cg
11036 ?        00:00:00 kworker/7:0-mm_
11067 ?        00:00:00 kworker/6:1-eve

```

# Scripting
Je vais utiliser le langage bash car il est celui que j'ai vu en cours.

```
joris@ubuntu-dell:~$ cat ./wait_a_minute____who_are_you.sh 
#!/bin/bash
# Ecrit par Joris Rouziere le 28/04/2020
# Ce script donne un aperçu de l'état du PC

# NOM MACHINE
echo -n 'Nom de la machine : '
hostname

# IP PRINCIPALE
echo -n 'IP principale : '
ip -4 address | grep  -A 1 wlo1: | grep inet | cut -d' ' -f6

#OS ET VERSION DE L'OS
echo -n "OS et version de l'OS : "
head -1 /etc/issue

#DATE ET HEURE D'ALLUMAGE
echo -n "Date et heure d'allumage : "
echo -n `who | cut -d' ' -f16`
echo -n ' '
who | cut -d' ' -f17

#OS A JOUR ?
upgradable=`apt-get --simulate upgrade | grep "The following packages have been kept back"`

if [[ -n $upgradable ]]
then
	echo "L'OS n'est pas à jour"
else
	echo "L'OS est à jour"
fi

#RAM
echo -n "Mémoire RAM utilisée : "
echo -n `free -h | grep Mem | cut -d' ' -f21`
echo -n '/'
free -h | grep Mem | cut -d' ' -f13

#DISQUE
echo -n "Mémoire disque utilisée : "
echo -n `df -h | grep /dev/nvme0n1p2 | cut -d' ' -f 5`
echo -n '/'
df -h | grep /dev/nvme0n1p2 | cut -d' ' -f 3

#USERS
echo -n 'Liste des utilisateurs :'
users=`cat /etc/passwd | cut -d: -f1`
for user in $users
do
	echo -n " $user "
done
echo ''

#PING
echo -n "Temps de réponse moyen vers 8.8.8.8 : "
echo -n `ping -c 5 8.8.8.8 | grep avg | cut -d/ -f5`
echo 'ms'
```

```
joris@ubuntu-dell:~$ ./wait_a_minute____who_are_you.sh 
Nom de la machine : ubuntu-dell
IP principale : 192.168.1.23/24
OS et version de l'OS : Ubuntu 18.04.4 LTS \n \l
Date et heure d'allumage : 2020-04-29 08:37
L'OS est à jour
Mémoire RAM utilisée : 3,4G/15G
Mémoire disque utilisée : 290G/468G
Liste des utilisateurs : root  daemon  bin  sys  sync  games  man  lp  mail  news  uucp  proxy  www-data  backup  list  irc  gnats  nobody  systemd-network  systemd-resolve  syslog  messagebus  _apt  uuidd  avahi-autoipd  usbmux  dnsmasq  rtkit  cups-pk-helper  speech-dispatcher  whoopsie  kernoops  saned  pulse  avahi  colord  hplip  geoclue  gnome-initial-setup  gdm  joris  nvidia-persistenced 
Temps de réponse moyen vers 8.8.8.8 : 18.926ms
```

```
joris@ubuntu-dell:~$ cat extinction_des_feux.sh
#!/bin/bash
# Ecrit par Joris Rouziere le 28/04/2020
# Ce script permet de lock ou eteidre le pc de suite ou au bout d'un certain temps

if [[ $1 == "--lock" || $1 == "-l" ]]
then
	if [ $2 > 0 ]
	then
		sleep $2
		gnome-screensaver-command -l
	else
		gnome-screensaver-command -l
	fi
elif [[ $1 == "--shut" || $1 == "-s" ]]
then
	if [ $2 > 0 ]
	then
		sleep $2
		init 0
	else
		init 0
	fi
else 	
	echo "extinction_des_feux.sh ACTION [<temps en seconde>]"
	echo "ACTIONS :"
	echo "  --lock ou -l : lock l'écran"
	echo "  --shut ou -s : éteint le PC"
fi

```

# Gestion des softs
Un gestionaire de paquet est utile au niveau de :
- l'utilisateur car il n'a pas à chercher le logiciel pour l'installation, il a juste besoin du nom du paquet. Le gestionnaire s'occupe aussi des dépendances qui permet d'éviter les bugs, et de ne pas avoir de paquets inutiles. De plus, le gestionnaire est au courant des mis à jour, notre système est donc régulierement à jour.
- l'éditeur car il n'a pas à prévoir de serveurs pour la distribution. Aussi, il est sûr que les utilisateurs auront les paquets nécessaires.
- la sécurité, car on est sûr de la provenance, et les paquets ont été vérifiées. Aussi, le gestionnaire va s'assurer de l'intégrité du téléchargement.

```
joris@ubuntu-dell:~$ apt list
...
zynaddsubfx-data/bionic,bionic 3.0.3-1 all
zynaddsubfx-dssi/bionic 3.0.3-1 amd64
zyne/bionic,bionic 0.1.2-2 all
zziplib-bin/bionic-updates,bionic-security 0.13.62-3.1ubuntu0.18.04.1 amd64
zzuf/bionic 0.15-1 amd64
```

```
joris@ubuntu-dell:~$ apt-cache policy 
Package files:
 100 /var/lib/dpkg/status
     release a=now
...
 500 http://fr.archive.ubuntu.com/ubuntu bionic/main i386 Packages
     release v=18.04,o=Ubuntu,a=bionic,n=bionic,l=Ubuntu,c=main,b=i386
     origin fr.archive.ubuntu.com
 500 http://fr.archive.ubuntu.com/ubuntu bionic/main amd64 Packages
     release v=18.04,o=Ubuntu,a=bionic,n=bionic,l=Ubuntu,c=main,b=amd64
     origin fr.archive.ubuntu.com
Pinned packages:
```

# Partage de fichier
- Preuve du processus actif
```
joris@ubuntu-dell:~$ ps -ef | grep nfs
root     10826     2  0 15:51 ?        00:00:00 [nfsd]
root     10827     2  0 15:51 ?        00:00:00 [nfsd]
root     10828     2  0 15:51 ?        00:00:00 [nfsd]
root     10829     2  0 15:51 ?        00:00:00 [nfsd]
root     10830     2  0 15:51 ?        00:00:00 [nfsd]
root     10831     2  0 15:51 ?        00:00:00 [nfsd]
root     10832     2  0 15:51 ?        00:00:00 [nfsd]
root     10833     2  0 15:51 ?        00:00:00 [nfsd]
joris    11932 11594  0 16:13 pts/2    00:00:00 grep --color=auto nfs
joris@ubuntu-dell:~$ ss -lt | grep nfs
LISTEN   0         64                  0.0.0.0:nfs               0.0.0.0:*      
LISTEN   0         64                     [::]:nfs                  [::]:*
```

- Dans le serveur:
```
joris@ubuntu-dell:/mnt/nfs_share$ ls
joris@ubuntu-dell:/mnt/nfs_share$ echo "J'ai été crée le serveur" > hello_there
joris@ubuntu-dell:/mnt/nfs_share$ ls
hello_there
```

- Dans le client:
```
joris@Ubuntu-Toshiba:/mnt/nfs_clientshare$ ls
joris@Ubuntu-Toshiba:/mnt/nfs_clientshare$ ls
hello_there
joris@Ubuntu-Toshiba:/mnt/nfs_clientshare$ cat hello_there 
J'ai été crée le serveur
```

# Chiffrement et notion de confiance
Le certificat posséde une clé publique vérifié par une autorité de certification. Ainsi, le service client va pouvoir crypté les clés de sessions (symétriques). Ces clés seront utilisées pour la suite de la connection. La connection est chiffré, et le client est sûr de parler à la bonne personne.
Le certificat posséde d'autre information: une date de fin de validité, un hash, l'organisme qui a validé ce certificat.

## Chiffrement de mail

## TLS
HTTPS garantie que l'on envoie nos requêtes à la bonne personne, et que la connexion est chiffrée. Le cadenas vert indique que le site utilise un certificat valide, et que la clé de sessions est utilisé pour crypter les échanges.

```
gitlab.com
Identity: gitlab.com
Verified by: Sectigo RSA Domain Validation Secure Server CA
Expires: 11/05/2020

Subject Name
OU (Organizational Unit):	Domain Control Validated
OU (Organizational Unit):	PositiveSSL Multi-Domain
CN (Common Name):	gitlab.com
Issuer Name
C (Country):	GB
ST (State):	Greater Manchester
L (Locality):	Salford
O (Organization):	Sectigo Limited
CN (Common Name):	Sectigo RSA Domain Validation Secure Server CA
Issued Certificate
Version:	3
Serial Number:	...
Not Valid Before:	2019-06-27
Not Valid After:	2020-05-11
Certificate Fingerprints
SHA1:	...
MD5:	...
Public Key Info
Key Algorithm:	RSA
Key Parameters:	05 00
Key Size:	2048
Key SHA1 Fingerprint:	...
Public Key:	...
Extension
Identifier:	2.5.29.35
Value:	...
Critical:	No
Subject Key Identifier
Key Identifier:	...
Critical:	No
Key Usage
Usages:	Digital signature Key encipherment
Critical:	Yes
Basic Constraints
Certificate Authority:	No
Max Path Length:	Unlimited
Critical:	Yes
Extended Key Usage
Allowed Purposes:	Server Authentication Client Authentication
Critical:	No
Extension
Identifier:	2.5.29.32
Value:	...
Critical:	No
Extension
Identifier:	1.3.6.1.5.5.7.1.1
Value:	...
Critical:	No
Subject Alternative Names
DNS:	gitlab.com
DNS:	auth.gitlab.com
DNS:	gprd.gitlab.com
DNS:	www.gitlab.com
Critical:	No
Extension
Identifier:	1.3.6.1.4.1.11129.2.4.2
Value:	...
Critical:	No
Signature
Signature Algorithm:	1.2.840.113549.1.1.11
Signature Parameters:	05 00
Signature:	...
```
- Subject Name : Infos du site
- Issuer Name : Infos de l'authorité de certification
- Issued Certificate : Infos du certificat
- Certificate Fingerprints : Hashs validants le certificat
- Public key info : Clé publique
- Subject Alternative Names : Noms du serveur

# SSH
## Client
### Les clés
Deux clé sont générées par le client : une clé publique et une clé privée. Les deux sont liées, seul la clé publique peut déchiffrer un message chiffré par la clé privée et inversement. Elles sont crées avec la commande `ssh-keygen`.<br/>
On dépose donc la clé publique grâce à `ssh-copy-id joris@10.6.1.2`. On dépose celle-ci car bien qu'ayant les mêmes propriétés, une seul clé doit être dévoilée pour maintenir la sécurité. Une clé est donc dites publique et c'est la seule qu'on partage.<br/>
Comme dis précédemment, seul notre clé publique peut déchiffrer un message chiffré par notre clé privée. Le serveur ayant notre clé publique, si on envoie un message chiffré, et que le serveur peut le déchiffré, alors il est sûr que le message provient de nous.<br/>
La clé privé est stockée dans le dossier ~/.ssh avec une permission de lecture et d'écriture seulement pour le super-utilisateur.<br/>

### Le fingerprint
Le fingerprint est l'empreinte SSH du serveur auquel on se connecte. Lors de notre connexion, soit notre pc a déjà vu cette IP et regarde si l'empreinte stockée dans known_host est la même; soit il n'a jamais vu cette IP et rajoute l'empreinte à known_host, d'où le yes|no. Cette sécurité permet d'être sûr que l'on se connecte bien à la bonne machine, et pas une machine ayant la même IP que celle qu'on veut joindre.

### ~/.ssh/config
```
joris@ubuntu-dell:~/.ssh$ cat config 
Host vm
	HostName 10.6.1.2
	User joris
	IdentityFile ~/.ssh/id_rsa.pub
```

## SSH tunnels


## SSH jumps
Un jump SSH consiste à passer se connecter à une machine en passant par une ou plusieurs machines. Cela peut-être utile pour passer un pare-feu par exemple.
```
joris@ubuntu-dell:~/.ssh$ cat config 
Host first
	HostName 10.6.1.2

Host second
	HostName 127.0.0.1
	ProxyJump second
joris@ubuntu-dell:~/.ssh$ ssh -J first second
Last login: Fri May  8 17:55:31 2020 from localhost
[joris@localhost ~]$ logout
Connection to 127.0.0.1 closed.
```

## Forwarding de ports at home
### Configuration de la VM
Lorqu'une VM à une IP en bridge, elle est sûr le même réseau que l'hôte, elle peut donc accéder à toutes les machines du réseau local. Chez-moi, l'hôte à l'IP 192.168.1.23/24, et la VM 192.168.1.33/24<br/>
```
[joris@pc-554 ~]$ ping -c 2 192.168.1.23
PING 192.168.1.23 (192.168.1.23) 56(84) bytes of data.
64 bytes from 192.168.1.23: icmp_seq=1 ttl=64 time=0.358 ms
64 bytes from 192.168.1.23: icmp_seq=2 ttl=64 time=0.516 ms

--- 192.168.1.23 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.358/0.437/0.516/0.079 ms
```