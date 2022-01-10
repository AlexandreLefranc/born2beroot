#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo 'Too many/few arguments, expecting one' >&2
    exit 1
fi

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

PASS_MAX_DAYS=$(cat /etc/login.defs | grep ^PASS_MAX_DAYS | awk '{print $2}')
PASS_MIN_DAYS=$(cat /etc/login.defs | grep ^PASS_MIN_DAYS | awk '{print $2}')
PASS_WARN_AGE=$(cat /etc/login.defs | grep ^PASS_WARN_AGE | awk '{print $2}')

echo Setting PASS_MAX_DAYS of user $1 to $PASS_MAX_DAYS
sudo chage -M $PASS_MAX_DAYS $1

echo Setting PASS_MIN_DAYS of user $1 to $PASS_MIN_DAYS
sudo chage -m $PASS_MIN_DAYS $1

echo Setting PASS_WARN_AGE of user $1 to $PASS_WARN_AGE
sudo chage -W $PASS_WARN_AGE $1
