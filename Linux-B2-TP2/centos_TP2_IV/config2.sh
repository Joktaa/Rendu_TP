# Hosts
echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.1.1 node2.tp2.b2
192.168.1.11 node1.tp2.b2" >> "/etc/hosts"

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


yum update -y

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
-----END CERTIFICATE-----" > /usr/share/pki/ca-trust-source/node1.crt
update-ca-trust
