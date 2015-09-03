#!/bin/sh

iterations=$1
shift

for i in `seq 1 $iterations`;
do
    echo "iteration $i"
    ansible-playbook -i inventories/ec2/ stress.yaml --limit "tag_user_`echo $ANSIBLE_EC2_PREFIX`"  -e "iteration=$i" -e "setup_name=`echo $ANSIBLE_EC2_PREFIX`" "$@"
done
ansible-playbook -i inventories/ec2/ collect-stress.yaml "$@"
