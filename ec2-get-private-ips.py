#!/usr/bin/python

import boto.ec2
import os
import argparse


def private_ips(ec2region,user,name,server):
   conn = boto.ec2.connect_to_region(ec2region,
       aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
       aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'))

   instances = conn.get_only_instances(filters={'tag:user':user, 'tag-value':name, 'tag:stopped':'false', 'tag:server':server})
   for instance in instances:
       if (instance.state == "running"):
          print (instance.id),
          for interface in reversed(instance.interfaces):
             print (interface.private_ip_address),
          print

if __name__ == "__main__":
    parser = argparse.ArgumentParser('ec2-attach-network-interface')
    parser.add_argument('ec2region', action='store',nargs=1, help='ec2 region')
    parser.add_argument('ec2user', action='store',nargs=1, help='ec2 user tag')
    parser.add_argument('ec2instance', action='store',nargs=1, help='ec2 instance name')
    parser.add_argument('ec2server', action='store',nargs=1, help='ec2 server type: scylla or cassandra')

    args = parser.parse_args()
    private_ips(args.ec2region[0],args.ec2user[0],args.ec2instance[0],args.ec2server[0])
