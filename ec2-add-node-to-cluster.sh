#!/bin/sh

ansible-playbook -i inventories/ec2/ ec2-add-node.yaml "$@"
