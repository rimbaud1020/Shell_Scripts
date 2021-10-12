#!/usr/bin/expect
# chmod 755 
# BACKUP SERVER 
# DMZ 각 서버의 /var 디렉토리 압축하여 받기
# Compress and receive /var directory of each server in DMZ

spawn rsync -avz root@172.16.100.10:/var/ /var_backup/webserver_1
expect "password:"
sleep 1
send "P@ssw0rd\r"
interact
spawn rsync -avz root@172.16.100.20:/var/ /var_backup/webserver_2
expect "password:"
sleep 1
send "P@ssw0rd\r"
interact
spawn rsync -avz root@172.16.100.30:/var/ /var_backup/nfsserver
expect "password:"
sleep 1
send "P@ssw0rd\r"
interact
spawn rsync -avz root@172.16.100.40:/var/ /var_backup/dnsserver_external
expect "password:"
sleep 1
send "P@ssw0rd\r"
interact
spawn rsync -avz root@172.16.100.50:/var/ /var_backup/dnsserver_internal
expect "password:"
sleep 1
send "P@ssw0rd\r"
interact
spawn rsync -avz root@172.16.100.60:/var/ /var_backup/dbserver
expect "password:"
sleep 1
send "P@ssw0rd\r"
interact
spawn rsync -avz root@172.16.100.70:/var/ /var_backup/mailserver
expect "password:"
sleep 1
send "P@ssw0rd\r"
interact