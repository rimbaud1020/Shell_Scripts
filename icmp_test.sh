#!/bin/bash
# BACKUP SERVER
# DMZ 각 서버 응답확인
# Check ICMP reaction from servers in DMZ

echo " " >> /icmp_test/everyday_ping.txt
timestamp=`date "+%Y/%m/%d/ %H:%M"`
echo "========= $timestamp =========" >> /icmp_test/everyday_ping.txt

ping -c 1 172.16.100.51 >> /icmp_test/everyday_ping.txt
    if [ $? -eq 0 ] ; then
    echo "172.16.100.51 : Alive"
    echo "172.16.100.51 : Alive" >> /icmp_test/everyday_ping.txt
    else
    echo "172.16.100.51 : Dead"
    echo "172.16.100.51 : Dead" >> /icmp_test/everyday_ping.txt
    fi
    
ping -c 1 172.16.100.52 >> /icmp_test/everyday_ping.txt
    if [ $? -eq 0 ] ; then
    echo "172.16.100.52 : Alive"
    echo "172.16.100.52 : Alive" >> /icmp_test/everyday_ping.txt
    else
    echo "172.16.100.51 : Dead"
    echo "172.16.100.51 : Dead" >> /icmp_test/everyday_ping.txt
    fi

net=172.16.100.
start=10
end=80

until [ $start -eq $end ]
do
    ping -c 1 $net$start >> /icmp_test/everyday_ping.txt
    if [ $? -eq 0 ] ; then
    echo "$net$start : Alive"
    echo "$net$start : Alive" >> /icmp_test/everyday_ping.txt
    else
    echo "$net$start : Dead"
    echo "$net$start : Dead" >> /icmp_test/everyday_ping.txt
    fi
    start=`expr $start + 10`
done





