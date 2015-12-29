#!/bin/sh

ansible-playbook -i inventories/ec2/ ec2-add-node.yaml -e "setup_name=`echo $ANSIBLE_EC2_PREFIX`" "$@"
