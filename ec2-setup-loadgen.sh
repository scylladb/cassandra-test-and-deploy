#!/bin/sh

ansible-playbook -i inventories/ec2/ setup-ec2-loadgen.yaml -e "login_user=fedora" "$@"
