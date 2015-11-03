#!/bin/sh

ansible-playbook -i inventories/ec2/ setup-ec2-cassandra.yaml "$@"
