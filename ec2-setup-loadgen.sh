#!/bin/sh

ansible-playbook -i inventories/ec2/ setup-ec2-loadgen.yaml -e "collect_server_ip=`./ec2-graphite-ip`" -e "login_user=fedora" "$@"
