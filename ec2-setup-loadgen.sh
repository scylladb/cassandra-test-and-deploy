#!/bin/sh

ansible-playbook setup-ec2-loadgen.yaml -e "@inventories/ec2/group_vars/all.yaml" "$@"
