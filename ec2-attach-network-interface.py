#!/usr/bin/python

import boto.ec2
import os
import argparse


def attach_network_interface(ec2region,instance):
   conn = boto.ec2.connect_to_region(ec2region,
       aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
       aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'))

   instance = conn.get_only_instances(instance_ids=[instance])[0]

   network_interface = conn.create_network_interface(instance.subnet_id,description="internal",groups=[ group.id for group in instance.groups])

   print 'created network interface: ',network_interface.id
   if network_interface.attach(instance.id,1)== False:
      raise Exception('could not attach network interface to instance');

   network_interface = conn.get_all_network_interfaces(network_interface_ids=[network_interface.id])[0]

   if conn.modify_network_interface_attribute(network_interface.id,'deleteOnTermination',True, attachment_id=network_interface.attachment.id) == False:
      raise Exception('could not update network interface delete on instance');

if __name__ == "__main__":
    parser = argparse.ArgumentParser('ec2-attach-network-interface')
    parser.add_argument('ec2region', action='store',nargs=1, help='ec2 region')
    parser.add_argument('ec2instance', action='store',nargs=1, help='ec2 instance id')
    args = parser.parse_args()
    attach_network_interface(args.ec2region[0],args.ec2instance[0])
