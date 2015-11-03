#!/bin/sh

ansible-playbook -i inventories/ec2/ setup-ec2-scylla.yaml -e "login_user=fedora" "$@"
