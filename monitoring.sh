#!/bin/bash

VAR=Hello
ARCHI=$(uname -a)

PCPU=$(cat /proc/cpuinfo | grep cpu\ cores | uniq | awk '{print $4}')

VCPU=$(cat /proc/cpuinfo | grep processor | uniq | wc -l)

MEMTOT=$(free -m | grep Mem | awk '{print $2}')
MEMUSE=$(free -m | grep Mem | awk '{print $3}')
MEMPCT=$(awk -v use=$MEMUSE -v tot=$MEMTOT 'BEGIN {printf "%.2f", use/tot*100}')

DSKTOT=$(df --total --block-size=G | grep total | tr -d 'G' | awk '{print $2}')
DSKUSE=$(df --total --block-size=G | grep total | tr -d 'G' | awk '{print $3}')
DSKPCT=$(df --total --block-size=G | grep total | tr -d 'G' | awk '{print $5}')

CPULOAD=$(cat /proc/loadavg | awk '{print $1}')

echo "#Architecture: $ARCHI"
echo "#CPU physical: $PCPU"
echo "#vCPU: $VCPU"
echo "#Memory Usage: $MEMUSE/$MEMTOT MB ($MEMPCT%)"
echo "#Disk Usage: $DSKUSE/$DSKTOT GB ($DSKPCT)"
echo "#CPU load: "
echo "#LVM use: $VAR"
echo "#Connexions TCP: $VAR"
echo "#User log: $VAR"
echo "#Network: $VAR"
echo "#Sudo: $VAR"
