#!/bin/sh

## Extract IPs list from EC2

usage="$(basename "$0") [-h] [-p yes] -- list DB servers, with '-p yes' for prometheus.yml format"

while getopts ':hp:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    p) PROM_FORMAT=1
       ;;
  esac
done

IPS=$(ansible DB -i inventories/ec2/ --limit "tag_user_`echo $ANSIBLE_EC2_PREFIX`" --list-hosts | tail -n +2 | sed '/^$/d;s/[[:blank:]]//g')

if [ -z $PROM_FORMAT ]
then
    echo $IPS
else
    echo $IPS | sed -r 's/(.*)/"\1:9103\"/' | paste -d, -s
fi
