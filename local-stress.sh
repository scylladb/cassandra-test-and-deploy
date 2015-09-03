#!/bin/sh

ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory --private-key=~/.vagrant.d/insecure_private_key -U vagrant stress.yaml -k -e "login_user=vagrant" -e "ip_list='192.168.10.11'" -e "index=0" "$@"
