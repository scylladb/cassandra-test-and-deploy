#!/bin/sh

ansible-playbook setup-ec2-scylla.yaml -e "@inventories/ec2/group_vars/all.yaml" -e "setup_name=`echo $ANSIBLE_EC2_PREFIX`" "$@"
