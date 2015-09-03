#!/bin/sh
ansible-playbook -i inventories/ec2/ terminate.yaml --limit "tag_user_`echo $ANSIBLE_EC2_PREFIX`"
