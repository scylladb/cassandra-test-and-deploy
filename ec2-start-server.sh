#!/bin/sh

number=$1 # number of server to start
shift

ansible-playbook -i inventories/ec2/ --limit "tag_user_`echo $ANSIBLE_EC2_PREFIX`" start_server.yaml "$@"
