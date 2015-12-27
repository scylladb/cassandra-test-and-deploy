#!/bin/sh

./inventories/ec2/ec2.py --refresh-cache
ansible-playbook -i inventories/ec2/ --limit "tag_user_`echo $ANSIBLE_EC2_PREFIX`" start_server.yaml "$@"
