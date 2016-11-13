#!/bin/sh
####################################################################
## Printing Scylla servers IPs in a prometheus target format
####################################################################

SCYLLA_PORT="9180"
NODE_PORT="9100"

HOSTS=$(ansible -i inventories/ec2/ Scylla --list-hosts --limit "tag_user_`echo $ANSIBLE_EC2_PREFIX`")

function echo_targets {
    TARGETS=$(echo $HOSTS | cut -f2 -d":" | cut -f2- -d" " | sed -e "s/ /\:$1 /g" | sed -r "s/(.*)/\1:$1/" | sed 's/[^ ][^ ]*/"&"/g' | sed 's/ /,/g')
    echo "  - targets: [$TARGETS]"
}

echo_targets $SCYLLA_PORT
echo_targets $NODE_PORT
