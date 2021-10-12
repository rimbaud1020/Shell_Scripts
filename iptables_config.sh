#!/bin/bash
# chkconfig: 345 50 50
# description: iptables config

#iptables
iptables -t filter -F
iptables -t nat -F
# route forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl net.ipv4.ip_forward

############## NAT TABLE ##############
## MASQUERADE ##
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

## DNAT ##
# dns 192.168.0.201
ifconfig eth0:1 192.168.0.201 netmask 255.255.255.0
iptables -t nat -A PREROUTING -p tcp -s 119.197.155.219 --dport 2222 -d 192.168.0.201 -j DNAT --to-destination 172.16.100.40:22
# web1 192.168.0.202
ifconfig eth0:2 192.168.0.202 netmask 255.255.255.0
iptables -t nat -A PREROUTING -d 192.168.0.202 -j DNAT --to-destination 172.16.100.10
# web2 192.168.0.203
ifconfig eth0:3 192.168.0.203 netmask 255.255.255.0
iptables -t nat -A PREROUTING -d 192.168.0.203 -j DNAT --to-destination 172.16.100.20
