#!/bin/sh
####################################################################
## Printing Scylla servers IPs in a prometheus target format
####################################################################

SCYLLA_PORT="9180"
NODE_PORT="9100"
SCYLLA_SERVER_FILE="scylla_servers.yml"
NODE_EXPORTER_FILE="node_exporter_servers.yml"

usage="This script generate target files for Prometheus. $(basename "$0") [-h] [-e] [-d Prometheus directory]"

while getopts ':hd:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    d) PROMETHEUS_DIR=$OPTARG
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done

function echo_targets {
    TARGETS=$(echo $HOSTS | cut -f2 -d":" | cut -f2- -d" " | sed -e "s/ /\:$1 /g" | sed -r "s/(.*)/\1:$1/" | sed 's/[^ ][^ ]*/"&"/g' | sed 's/ /,/g')
    echo "  - targets: [$TARGETS]"
}

HOSTS=$(ansible -i inventories/ec2/ Scylla --list-hosts --limit "tag_user_`echo $ANSIBLE_EC2_PREFIX`")

echo_targets $SCYLLA_PORT > /tmp/$SCYLLA_SERVER_FILE
echo_targets $NODE_PORT > /tmp/$NODE_EXPORTER_FILE

if [ ! -z "$PROMETHEUS_DIR" ]; then
    mv /tmp/$SCYLLA_SERVER_FILE $PROMETHEUS_DIR/$SCYLLA_SERVER_FILE
    mv /tmp/$NODE_EXPORTER_FILE $PROMETHEUS_DIR/$NODE_EXPORTER_FILE
fi
