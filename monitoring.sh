#!/bin/bash

VAR=Hello
ARCHI=$(uname -a)

PCPU=$(cat /proc/cpuinfo | grep cpu\ cores | uniq | awk '{print $4}')

VCPU=$(cat /proc/cpuinfo | grep processor | uniq | wc -l)

MEMTOT=$(free -m | grep Mem | awk '{print $2}')
MEMUSE=$(free -m | grep Mem | awk '{print $3}')
MEMPCT=$(awk -v use=$MEMUSE -v tot=$MEMTOT 'BEGIN {printf "%.2f", use/tot*100}')

DSKTOT=$(df --total -h / /home | grep total | tr -d 'G' | awk '{print $2}')
DSKUSE=$(df --total -h / /home | grep total | tr -d 'G' | awk '{print $3}')
DSKPCT=$(df --total -h / /home | grep total | tr -d 'G' | awk '{print $5}')

CPULOAD=$(cat /proc/loadavg | awk '{print $1}')

LASTBOOT=$(uptime --since)

LVMUSE=$(/sbin/lvdisplay | grep "Logical volume" | wc -l | awk '{if ($1 > 0) {print "yes"} else {print "no"}}')

TCPCON=$(cat /proc/net/sockstat | awk '$1 == "TCP:" {print $3}')

USERLOG=$(users | xargs -n1 | sort | uniq | wc -l)

IPADDR=$(hostname -I | awk '{print $1}')
MACADDR=$(ip a | awk '$1 == "link/ether" {print $2}')

SUDO=$(cat /var/log/sudo/sudo.log | grep -a COMMAND | wc -l)

echo "#Architecture: $ARCHI"
echo "#CPU physical: $PCPU"
echo "#vCPU: $VCPU"
echo "#Memory Usage: $MEMUSE/$MEMTOT MB ($MEMPCT%)"
echo "#Disk Usage: $DSKUSE/$DSKTOT GB ($DSKPCT)"
echo "#CPU load: $CPULOAD"
echo "#Last boot: $LASTBOOT"
echo "#LVM use: $LVMUSE"
echo "#Connexions TCP: $TCPCON ESTABLISHED"
echo "#User log: $USERLOG"
echo "#Network: IP $IPADDR ($MACADDR)"
echo "#Sudo: $SUDO"
