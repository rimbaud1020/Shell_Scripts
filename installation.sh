#!/bin/bash
# 프로그램 설치 및 실행
while [ 1 ]
do
echo "######## Installing a Program ########"
echo " "
echo "Database Server : 1 "
echo "Database Client : 2 "
echo "   DNS  Server  : 3 "
echo "  Mail  Server  : 4 "
echo "   NFS  Server  : 5 "
echo "   NFS  Client  : 6 "
echo "   DHCP Server  : 7 "
echo "   FTP  Server  : 8 "
echo "       EXIT     : 10 "
echo -n " Command >> "
read program
  if [ $program = '10' ]
    then 
    exit;
  fi

case "$program" in
    1)
    # Database Server
    #### my.cnf 파일 ftp로 다운받기 (/root에)
        echo -n "Did you download 'my.cnf' file in /root ? [y/n] : "
        read ans
            if [ $ans = y ] ; then
            echo "##### Start to Install Database Server #####"
            yum -y install mysql-server	
            sleep 1
            chkconfig mysqld on
            chkconfig --list | grep mysqld
            cp -f /root/my.cnf /etc/my.cnf  
            echo "##### /root/my.cnf file is moved to /etc/my.cnf #####"
            service mysqld restart
            elif [ $ans = n ] ; then
            echo "##### Please download the file and try again #####"
            else 
            echo "##### Invalid input #####"
            fi
        ;;
    
    2)
    # Database Client
        echo "##### Start to Install Database Client #####"
        yum -y install mysql
        service mysqld restart
        echo "##### Complete ! #####"
    ;;

    3)
    # DNS Server
    echo "##### Start to Install DNS Server #####"
        yum -y install bind*
        sleep 1
    echo "##### Basic setting /etc/named.conf #####"
        sed -i "/listen-on-v6 port 53/ c\//    listen-on-v6 port 53 { ::1;};" /etc/named.conf
        sed -i "/listen-on port 53/ c\  listen-on port 53 { any; };" /etc/named.conf
        sed -i "/allow-query/ c\    allow-query { any; };" /etc/named.conf
        sed -i "/recursion/ c\  recursion no;" /etc/named.conf
        sed -i "/include "/etc/named.root.key";/ c\//include "/etc/named.root.key";" /etc/named.conf
        service named restart
    
    echo -n " Enter a New Domain Name (ex.lit.com) : "
    read domain
    
    echo -e "zone "$domain" IN {" >> /etc/named.rfc1912.zones
    echo " 1. Master "
    echo " 2. Slave "
    echo -n " Command >> "
    read ms
        if [ $ms = 1 ] ; then
            echo -e "\t type master;" >> /etc/named.rfc1912.zones
            echo -e "\t file ""$domain.zone"";" >> /etc/named.rfc1912.zones
            cp -p /var/named/named.localhost /var/named/$domain.zone
            elif [ $ms = 2 ] ; then
            echo -e "\t type slave;" >> /etc/named.rfc1912.zones
            echo -e "\t file "slaves/$domain.zone";" >> /etc/named.rfc1912.zones
            cp -p /var/named/named.localhost /var/named/slaves/$domain.zone
            else 
            echo "##### Invalid input #####"
        fi
    
    echo " ##### Zone File Created in the Name of "$domain.zone" #####"
    echo " #####           You Have to Edit the Zone File        #####"
        service named restart
        ;;

    4)
    # Mail  Server
        echo "##### Start to Install Mail Server #####"
        echo "##### Postfix & Dovecot #####"
            yum -y install postfix
        ;;

    5)
    # NFS Server
        echo "##### Start to Install NFS Server #####"
        yum -y install rpcbind nfs-utils nfs-utils-lib
        sleep 1
        yum -y install nfs-utils-lib-devel nfs4-acl-tools libgssglue-devel
        sleep 1
        echo " "
        echo "##### FTP user edited (enable root login) #####"
        echo " "
        echo  " Enter the Exact Directory Route for Mounting (ex./backup/nfsserver) "
        echo -n "  :  "
        read mr
        echo "##### Creating the directory for mounting ... #####"
        mkdir -p $mr
        echo " "
        echo "##### Done ! #####"
        echo " "
        echo -n "Do you want to set up the Configuration now?(/etc/exports) [y/n] : "
        read nfsconf
            if [ $nfsconf = y ] ; then
                echo -n "Enter IP Address to Allow Mounting : "
                read nfsip
                echo -n "Enter Permissions and Features to Allow (ex.rw,sync) : "
                read nfspf
                echo "$mr $nfsip($nfspf)" >> /etc/exports
                echo "##### Done #####"
            elif [ $ans = n ] ; then
                echo "##### You can set up your preferences at /etc/exports #####"
            else 
                echo "##### Invalid input #####"
            fi
            
        service rpcbind restart
        service nfs restart
        service nfslock restart
        service vsftpd restart
        echo "##### Checking it works #####"
        exportfs 127.0.0.1:$mr
        echo " "
        echo "##### Checking Exporting Information #####"
        exportfs -v	
        echo " "
    ;;

    6)
    # NFS  Client
        echo "##### Start to Install NFS Client #####"
        yum -y install rpcbind nfs-utils nfs-utils-lib
        sleep 1
        echo " Enter the Exact Directory Route for Mounting "
        echo -n " Mounting your Directory (ex./nfsmount) :  "
        read cdr
        echo -n " From .. (Server's Directory) (ex./nfsserver) :  "
        read sdr
        echo -n "Enter IP Address to Mount (Server's) : "
        read mountip     
        mount -t nfs4 $mountip:$sdr $cdr
        echo "##### Check #####"
        ls -al $cdr
        echo "##### Done #####"
    ;;

    7)
    # DHCP  Server
        echo "##### Start to Install DHCP Server #####"
        yum -y install dhcp
        cp /usr/share/doc/dhcp-*/dhcpd.conf.* /etc/dhcp/dhcpd.conf
        echo "##### Basic configuration #####"
        echo -n "Enter N.A : "
        read net
        echo -n "Enter netmask : "
        read netmask
        echo -n " Range from : "
        read from
        echo -n " Range to : "
        read to
        echo -e "subnet $net netmask $netmask {
                range $from $to;
                 }" >> /etc/dhcp/dhcpd.conf
        echo -e "subnet $net netmask $netmask {
                range $from $to;
                }"
        ;;

    8) 
    #FTP Server
    echo "##### Start to Install FTP Server #####"
    yum -y install vsftpd
    sed -i "/root/ c\# root" /etc/vsftpd/ftpusers
    sed -i "/root/ c\# root" /etc/vsftpd/user_list 
    echo "##### Enable root login #####"
    service vsftpd restart
    ;;

    *)
    echo "Try Again"
    ;;
    

esac
done