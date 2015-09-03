#!/bin/sh

external_ip=$1
shift

ansible-playbook -i inventories/ec2/ --limit $external_ip stop_server.yaml "$@"
