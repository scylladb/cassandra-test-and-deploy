# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "graphite" do |graphite|
    graphite.vm.box = "ubuntu.cassandra2.1.2.box" # cassandra 2.1.2 on ubuntu 14.04
    graphite.vm.box_url = "https://s3-us-west-2.amazonaws.com/vagrant.virtualbox.box/ubuntu.cassandra2.1.2.box"
    graphite.vm.network :private_network, ip: "192.168.10.100"
    graphite.vm.hostname ="graphite"
    graphite.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1644"]
      vb.cpus = 1
    end

    graphite.vm.provision "ansible" do |ansible|
      ansible.host_key_checking = false
      ansible.groups = {
        "GraphiteServer" => ["graphite"],
        "all_groups:children" => ["GraphiteServer"]
      }
      ansible.extra_vars = {
        login_user: "vagrant",
        graphite_listen_ip: "192.168.10.100"
      }
      ansible.playbook = "prepare-graphite.yaml"
    end
  end

  config.vm.define "cass1" do |cass1|
    # ubuntu.cassandra2.1.2.box is a local box with update packages
    # and Cassandra installed.
    cass1.vm.box = "ubuntu.cassandra2.1.2.box" # cassandra 2.1.2 on ubuntu 14.04
    cass1.vm.box_url = "https://s3-us-west-2.amazonaws.com/vagrant.virtualbox.box/ubuntu.cassandra2.1.2.box"
    cass1.vm.network :private_network, ip: "192.168.10.11"
    cass1.vm.hostname ="cass1"
    cass1.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2572"]
      vb.cpus = 2
    end
    config.vm.provision "ansible" do |ansible|
      ansible.host_key_checking = false
      ansible.groups = {
        "Cassandra" => ["cass1"],
        "NewCassandra" => ["cass1"],
        "tag_Name_local_Cassandra" => ["cass1"]
      }
      ansible.extra_vars = {
        login_user: "vagrant",
        collect_server_ip: "192.168.10.100",
        internal_ip: "192.168.10.11",
        seeds: "192.168.10.11",
      }
      ansible.verbose = 'v'
      ansible.playbook = "prepare-cassandra.yaml"
    end
  end

  config.vm.define "load1" do |load1|
    load1.vm.box = "ubuntu.cassandra2.1.2.box" # cassandra 2.1.2 on ubuntu 14.04
    load1.vm.box_url = "https://s3-us-west-2.amazonaws.com/vagrant.virtualbox.box/ubuntu.cassandra2.1.2.box"
    load1.vm.network :private_network, ip: "192.168.10.21"
    load1.vm.hostname ="load1"
    load1.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1644"]
      vb.cpus = 1
    end
    config.vm.provision "ansible" do |ansible|
      ansible.host_key_checking = false
      ansible.groups = {
        "CassandraLoadgen" => ["load1"],
        "tag_Name_local_CassandraLoadgen" => ["load1"],
      }
      ansible.extra_vars = {
        login_user: "vagrant",
        collect_server_ip: "192.168.10.100",
        index: "1"
      }
      ansible.verbose = 'v'
      ansible.playbook = "prepare-loadgen.yaml"
    end
  end

end
