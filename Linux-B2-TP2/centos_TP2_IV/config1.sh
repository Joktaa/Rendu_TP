# Hosts
echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.1.1 node1.tp2.b2
192.168.1.12 node2.tp2.b2" > "/etc/hosts"

# User
useradd joris -m
usermod -aG wheel joris

#Firewall
systemctl start firewalld
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --reload

# Selinux
sudo setenforce 0
echo "SELINUX=permissive\nSELINUXTYPE=targeted" > /etc/selinux/config

## Web
# install
yum update -y
yum install -y epel-release
yum install -y nginx

# user
useradd nginx -M -s /sbin/nologin

# clé
echo "-----BEGIN CERTIFICATE-----
MIIDrTCCApWgAwIBAgIJALvKrPmyDL9HMA0GCSqGSIb3DQEBCwUAMG0xCzAJBgNV
BAYTAkZSMREwDwYDVQQIDAhCb3JkZWF1eDERMA8GA1UEBwwIQm9yZGVhdXgxDDAK
BgNVBAoMA01PSTETMBEGA1UECwwKbWEgY2hhbWJyZTEVMBMGA1UEAwwMbm9kZTEu
dHAxLmIyMB4XDTIwMTAwNDE2MjQwM1oXDTIxMTAwNDE2MjQwM1owbTELMAkGA1UE
BhMCRlIxETAPBgNVBAgMCEJvcmRlYXV4MREwDwYDVQQHDAhCb3JkZWF1eDEMMAoG
A1UECgwDTU9JMRMwEQYDVQQLDAptYSBjaGFtYnJlMRUwEwYDVQQDDAxub2RlMS50
cDEuYjIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC3R5gKafS0QqBD
gzdqLiSp9U36NzDSWBTFFXBODmSQOaEcTInwOwFgB2aileM2+7wfpwo23BNvCopP
iI8h7y5GAvh7luXTC+KB6uMBbrVp8cVF+hK7xVYsUBNnOq8CDO1XEp44yLqQlBKU
6itfuqStij5ccJIhNfgdG7LoNsP163ipCWYFcKboy1n8VEs7/jYidfwRKFsPtnGJ
n6hyYymmamJ2GdIyc9opgRlfjrl/8H5G7j+shPvNlS/JlJsDQiiitstA8hcGrFU7
Mkthcu9wA2lgqY+0uL0SxxccIblbqUYQHHn8SIl6xSaqb8PtYNlZyltvYXFVEIV/
h7OsBRq/AgMBAAGjUDBOMB0GA1UdDgQWBBRnjgA+kst2sbNjYJHV44YCz6o0RjAf
BgNVHSMEGDAWgBRnjgA+kst2sbNjYJHV44YCz6o0RjAMBgNVHRMEBTADAQH/MA0G
CSqGSIb3DQEBCwUAA4IBAQBHtiGJtEQ2lSnoqCjCMDlyRgfyvaaS1VZDdHJz30Xs
QijiGkRR03caY+eYnwh4QBEbWP12MO9MfXLkaxR4WHJj6f/a/1QgtWU0uvYdO6pW
zdjuoXht2sTlD3Xy1bnZdxzddCwOCHS47p+Azvy6sJIaB3IOeJL2hmV8ehZX+qQa
e/BLdfbMddSlZ5t3u/ePB+TMiHwtNK+ka3C5lWDpznS1SnbWcyBz04zcvo2rYiPy
QMlDZWE/BvVCd0Cu74mErvaKdohUsD1zY8h+VYxfvhVQcKX19hxLwgwfMWLU/x39
EPYQPWma8kbzx1CZggfbC/LNe8y93g75NbapQhAdkEHR
-----END CERTIFICATE-----" > server.crt

echo "-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC3R5gKafS0QqBD
gzdqLiSp9U36NzDSWBTFFXBODmSQOaEcTInwOwFgB2aileM2+7wfpwo23BNvCopP
iI8h7y5GAvh7luXTC+KB6uMBbrVp8cVF+hK7xVYsUBNnOq8CDO1XEp44yLqQlBKU
6itfuqStij5ccJIhNfgdG7LoNsP163ipCWYFcKboy1n8VEs7/jYidfwRKFsPtnGJ
n6hyYymmamJ2GdIyc9opgRlfjrl/8H5G7j+shPvNlS/JlJsDQiiitstA8hcGrFU7
Mkthcu9wA2lgqY+0uL0SxxccIblbqUYQHHn8SIl6xSaqb8PtYNlZyltvYXFVEIV/
h7OsBRq/AgMBAAECggEAQ07jo09uMpUVTjXuL+xqQpB35qBGKbl3RzmsWL4oaF8B
r+bb8YF5685L/wGUxCiG2gj6U1NXP7xbNwIrroasM8H7h0fPd0YyFQwx+eCydwn3
LM+9+X9rOjLeLVb71oDw2L1Zpfjxqw72FAI7k5hzydevNzuQLuonCGmXtngGV1VX
VDogLlAoKMpfVMcdDeE9r/quvrHaJ0egv2Q77kRuFngPKraPPJ4CAzznENK/W5Ip
/lHQX/6f1uS0uot6jcVnxsn26TYL/ih+QhowCOkC4KPVC9lRfI8yaMAJSa9cKfAC
wJUbQ5H97yEYbJr1GRE/0WqLWvwsgNzJnYe84MYdwQKBgQDkYhikXfTpOBDG87nV
PnBui87SHa4rvVU4S2vKQl1xXRu+WN4dvNSnTx8QsD4JCToAh232XZaQyGDUxH4Q
bzi8HOTPa00zxfk2GFtV7xG2ojRHfPhdFjICRBGnzLSFIpfKZsb+bDCFBRiaiQ70
cvIG+Hmo4olJqfKsURAQpX/j5wKBgQDNcUIkkb0bqiZXpfSYvXR4JFPfRJs78in/
mnmF65q2bRDN3XAvo6S+hMqsQZysvNALdsq2ofMOrdn92hJcMJB9y11Yw5gnUwgq
uTxH6ShMJRW9slsnwAC4bOlnjG5KYCqT8vCxSppHEzCoZ8xvHGxuBy1rJDp8Br9I
1yX3F1Y3aQKBgEJ4Enf0KI2gFbHxyYo4y/xAkIcywDhWuHDT8qFBQ3T1BlgWAT9i
b/np2z6+LK/wkYMJ54Umo+WrjBMgxRf/ZuHI/wcnUabZ3bhSynJuTBd9if2sb5SY
GyHxsbnGqFt/P/JWi2ANGOn+G7UOYt3efnZs5uuyUwavgcOJLEXMBTbNAoGBAJnI
GsvG7/iiX/sh9brTrjg0cTfiYhT4S6nSVv8BApllgLuo804lv68BNbjFkGLZHx5F
uK4HAirNxiy4LSAnFjGjpedI2j8tbyKT7+SgShLde624sXVKyv9CP2DMhM5Vt+lx
Y+xCPMPRQI3+zM+rRhsCcmQOBV1Lq6n5qqiQJnBpAoGAMYDVKBZ1SBw+0QFMQkdK
5ndoEE6fD0P5rufJO9lPdBZEQbv1udzYkIMMupexqoBitdpW4ZqKm6ApRwoxAZ8t
GBxtiGENubrKMxhVZ7pFUEG+XAVtfKyHZ3/GyAbq+F3RdK2bohg6JuZD/Litw8UH
1M7hKxcRbIYA6Qerj8jzqU0=
-----END PRIVATE KEY-----" > server.key


mv ./server.key /etc/pki/tls/private/node1.tp2.b2.key
chmod 400 /etc/pki/tls/private/node1.tp2.b2.key
chown nginx:nginx /etc/pki/tls/private/node1.tp2.b2.key

mv ./server.crt /etc/pki/tls/certs/node1.tp2.b2.crt
chmod 444 /etc/pki/tls/certs/node1.tp2.b2.crt
chown nginx:nginx /etc/pki/tls/certs/node1.tp2.b2.crt

# Site
mkdir /srv/site1
mkdir /srv/site2
echo "<h1>CECI EST LE SITE 1</h1>" > /srv/site1/index.html
echo "<h1>CECI EST LE SITE 2</h1>" > /srv/site2/index.html

chown nginx:nginx /srv/site1 -R
chown nginx:nginx /srv/site2 -R
sudo chmod 700 /srv/site1 /srv/site2
sudo chmod 400 /srv/site1/index.html /srv/site2/index.html

# Conf
echo "worker_processes 1;
error_log nginx_error.log;
pid /run/nginx.pid;
user nginx;

events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name node1.tp2.b2;
        
        location / {
              return 301 /site1;
        }

        location /site1 {
            alias /srv/site1;
        }

        location /site2 {
            alias /srv/site2;
        }
    }
    server {
        listen 443 ssl;

        server_name node1.tp2.b2;
        ssl_certificate /etc/pki/tls/certs/node1.tp2.b2.crt;
        ssl_certificate_key /etc/pki/tls/private/node1.tp2.b2.key;
        
        location / {
              return 301 /site1;
        }

        location /site1 {
            alias /srv/site1;
        }

        location /site2 {
            alias /srv/site2;
        }
    }
}" > /etc/nginx/nginx.conf
systemctl restart nginx
