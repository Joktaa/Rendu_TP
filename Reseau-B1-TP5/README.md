# I. Toplogie 1 - intro VLAN
## 2. Setup clients
* admin1 -> admin2
```
admin1> ping 10.5.10.12
84 bytes from 10.5.10.12 icmp_seq=1 ttl=64 time=0.798 ms
```

* admin2 -> admin1
```
admin2> ping 10.5.10.11
84 bytes from 10.5.10.11 icmp_seq=1 ttl=64 time=0.890 ms
```

* guest1 -> guest2
```
guest1> ping 10.5.20.12
84 bytes from 10.5.20.12 icmp_seq=1 ttl=64 time=0.623 ms
```

* guest2 -> guest1
```
guest2> ping 10.5.20.11
84 bytes from 10.5.20.11 icmp_seq=1 ttl=64 time=1.270 ms
```

## 3. Setup VLANs
### Mise en place
- VLAN
```
IOU1#show vlan            
--------------------------------------------------------------------------
VLAN Name                             Status    Ports
1    default                          active    Et0/1, Et0/2, Et0/3, Et1/0
                                                Et1/3, Et2/0, Et2/1, Et2/2
                                                Et2/3, Et3/0, Et3/1, Et3/2
                                                Et3/3
10   admins                           active    Et1/1
20   guests                           active    Et1/2
1002 fddi-default                     act/unsup 
1003 token-ring-default               act/unsup 
1004 fddinet-default                  act/unsup 
1005 trnet-default                    act/unsup 
.
.
.
```

- TRUNK
```
IOU1#show interface trunk 
Port        Mode             Encapsulation  Status        Native vlan
Et0/0       on               802.1q         trunking      1
Port        Vlans allowed on trunk
Et0/0       10,20
Port        Vlans allowed and active in management domain
Et0/0       10,20
Port        Vlans in spanning tree forwarding state and not pruned
Et0/0       10,20
```

### Vérification
* admin1 -> admin2
```
admin1> ping 10.5.10.12
84 bytes from 10.5.10.12 icmp_seq=1 ttl=64 time=0.669 ms
```

* guest1 -> guest2
```
guest1> ping 10.5.20.12
84 bytes from 10.5.20.12 icmp_seq=1 ttl=64 time=0.795 ms
```

* Changement de réseau d'un guest
```
guest1> ip 10.5.10.13 255.255.255.0
Checking for duplicate address...
PC1 : 10.5.10.13 255.255.255.0
guest1> ping 10.5.10.11
host (10.5.10.11) not reachable
```

# II. Topologie 2 - VLAN, sous-interface, NAT
## 2. Adressage
admin3 -> admin1
```
admin3> ping 10.5.10.11
84 bytes from 10.5.10.11 icmp_seq=1 ttl=64 time=0.809 ms
```

guest3 -> guest1
```
guest3> ping 10.5.20.11
84 bytes from 10.5.20.11 icmp_seq=1 ttl=64 time=0.430 ms
```

## 3. VLAN
* VLAN
```
IOU3#show vlan
VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Et0/1, Et0/2, Et0/3, Et1/0
                                                Et1/3, Et2/0, Et2/1, Et2/2
                                                Et2/3, Et3/0, Et3/1, Et3/2
                                                Et3/3
10   admins                           active    Et1/1
20   guests                           active    Et1/2
1002 fddi-default                     act/unsup 
1003 token-ring-default               act/unsup 
1004 fddinet-default                  act/unsup 
1005 trnet-default                    act/unsup 
.
.
.
```

* TRUNK
```
IOU3#show interfaces trunk 
Port        Mode             Encapsulation  Status        Native vlan
Et0/0       on               802.1q         trunking      1
Port        Vlans allowed on trunk
Et0/0       1-4094
Port        Vlans allowed and active in management domain
Et0/0       1,10,20
Port        Vlans in spanning tree forwarding state and not pruned
Et0/0       1,10,20
```

* Changement de réseau d'un guest
```
guest3> ip 10.5.10.14
Checking for duplicate address...
PC1 : 10.5.10.14 255.255.255.0
guest3> ping 10.5.10.11
host (10.5.10.11) not reachable
guest3> ping 10.5.20.11
No gateway found
```

## 4. Sous-interfaces
* Configuration
```
R1#show ip interface brief 
Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            unassigned      YES unset  up                    up      
FastEthernet0/0.10         10.5.10.254     YES manual up                    up      
FastEthernet0/0.20         10.5.20.254     YES manual up                    up      
FastEthernet1/0            unassigned      YES unset  administratively down down    
FastEthernet2/0            unassigned      YES unset  administratively down down
```

* admin1 -> R1
```
admin1> ping 10.5.10.254
84 bytes from 10.5.10.254 icmp_seq=1 ttl=255 time=9.230 ms
```

* guest1 -> R1
```
guest1> ping 10.5.20.254
84 bytes from 10.5.20.254 icmp_seq=1 ttl=255 time=9.472 ms
```

## 5. NAT
* Configuration
```
R1#show ip int br
Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            unassigned      YES unset  up                    up      
FastEthernet0/0.10         10.5.10.254     YES manual up                    up      
FastEthernet0/0.20         10.5.20.254     YES manual up                    up      
FastEthernet1/0            192.168.122.58  YES DHCP   up                    up      
FastEthernet2/0            unassigned      YES unset  administratively down down    
NVI0                       unassigned      NO  unset  up                    up
```

* admin1 -> 8.8.8.8
```
admin1> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=59 time=28.106 ms
```

* guest1 -> 8.8.8.8
```
guest1> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=59 time=29.658 ms
```

# III. Topologie 3 - Ajouter des services
## 3. Serveur DHCP
```
guest3> ip dhcp
DDORA IP 10.5.20.101/24 GW 10.5.20.254
```

## 4. Serveur Web
```
[joris@localhost ~]$ curl localhost:80
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Welcome to CentOS</title>
  <style rel="stylesheet" type="text/css"> 
	html {
	background-image:url(img/html-background.png);
	background-color: white;
	font-family: "DejaVu Sans", "Liberation Sans", sans-serif;
	font-size: 0.85em;
	line-height: 1.25em;
	margin: 0 4% 0 4%;
	}
.
.
.
</body>
</html>
```