#!/bin/sh

ansible-playbook -i inventories/ec2/ setup-graphite-ec2.yaml
curl -X POST --header "Content-Type: application/json" -d @roles/tessera/files/cassandra-dashboard.json http://`./ec2-graphite-external-ip`/api/dashboard/
curl -X POST --header "Content-Type: application/json" -d @roles/tessera/files/server-dashboard.json http://`./ec2-graphite-external-ip`/api/dashboard/


