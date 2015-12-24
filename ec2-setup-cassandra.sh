#!/bin/sh

ansible-playbook setup-ec2-cassandra.yaml -e "@inventories/ec2/group_vars/all.yaml" "$@"
