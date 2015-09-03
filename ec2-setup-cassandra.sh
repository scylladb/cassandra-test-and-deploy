#!/bin/sh

ansible-playbook -i inventories/ec2/ setup-ec2-cassandra.yaml -e "collect_server_ip=`./ec2-graphite-ip`" "$@"
