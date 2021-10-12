#! /bin/bash

ifpath=/etc/sysconfig/network-scripts

function ip
{
    sed -i "/IPADDR/ c\IPADDR=$1" $ifpath/ifcfg-$int
    echo "===== Successfully changed ! ====="
    service network restart
    cat $ifpath/ifcfg-$int | grep IPADDR
}
function gw
{
    sed -i "/GATEWAY/ c\GATEWAY=$1" $ifpath/ifcfg-$int
    echo "===== Successfully changed ! ====="
    service network restart
    cat $ifpath/ifcfg-$int | grep GATEWAY
}
function dns
{
    sed -i "/DNS1/ c\DNS1=$1" $ifpath/ifcfg-$int
    echo "===== Successfully changed ! ====="
    service network restart
    cat $ifpath/ifcfg-$int | grep DNS1
}
function hw
{
    sed -i "/HWADDR/ c\HWADDR=$1" $ifpath/ifcfg-$int
    echo "===== Successfully changed ! ====="
    service network restart
    cat $ifpath/ifcfg-$int | grep HWADDR
}




echo -n "Enter the Interface Name You Want to Change (ex.eth0)"
read int

echo "=====   The Current status of int   ====="
cat $ifpath/ifcfg-$int

echo "=====      ====="
#BOOTPROTO=none

while [ 1 ]
do
    echo ""
    echo "===== Enter What You Want to Change ====="
    echo "1.  IP"
    echo "2.  GATEWAY"
    echo "3.  HWADDR"
    echo "4.  DNS"
    echo "5.  EXIT"
    echo -n "Command >> "
    read command
    if [ $command = '5' ]
    then 
    exit;
    fi

    case "$command" in

        1)
        echo "=====      The Current IP       ====="
        cat $ifpath/ifcfg-$int | grep IPADDR
        echo ""
        echo -n " Change IP : " ;   read ip
        ip $ip ;  ;;
        
        2)
        echo "=====      The Current GW       ====="
        cat $ifpath/ifcfg-$int | grep GATEWAY
        echo ""
        echo -n " Change GW : " ;   read gw
        gw $gw ;  ;;
        
        3)
        echo "=====      The Current HW       ====="
        cat $ifpath/ifcfg-$int | grep HWADDR
        echo ""
        echo -n " Change HW : " ;   read hw
        hw $hw ;  ;;

        4)
        echo "=====      The Current DNS       ====="
        cat $ifpath/ifcfg-$int | grep DNS
        echo ""
        echo -n " Change DNS : " ;   read dns
        dns $dns ;  ;;
        
        *)
        echo "Try Again"
        ;;
    
    esac
done
