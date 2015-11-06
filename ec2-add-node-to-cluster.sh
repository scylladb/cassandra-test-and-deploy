#!/bin/sh

ansible-playbook -i inventories/ec2/ setup-ec2-cassandra.yaml -e "add_node=true" -e "use_reflector=false" "$@"
