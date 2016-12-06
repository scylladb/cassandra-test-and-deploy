# Ansible Scylla and Cassandra Cluster Stress

A framework for running and automating Scylla/Cassandra stress tests on Amazon EC2.

This repository contains Ansible playbooks and scripts for running Scylla/Cassandra **multi region** performance tests on EC2 with multiple DB servers and multiple cassandra-stress loaders, as well as adding, stopping and starting nodes.


### Introduction
The following will compare Scylla cluster to Cassandra cluster performance on EC2, using 6 loader servers
```
./ec2-setup-scylla.sh -e "cluster_nodes=2"
./ec2-setup-cassandra.sh -e "cluster_nodes=2"
./ec2-setup-loadgen.sh -e "load_nodes=6"
./ec2-stress.sh 1 -e "load_name=cassandra.v1" -e "server=Cassandra" -e "stress_options='-errors ignore'"
./ec2-stress.sh 1 -e "load_name=scylla.v1" -e "server=Scylla" -e "stress_options='-errors ignore'"
```
Note you will need more load nodes to stress Scylla.

Starting from Scylla 1.4, Scylla expose by default Prometheus metrics. More on [monitoring Scylla](https://github.com/scylladb/scylla-grafana-monitoring)

### Which Scylla version is running?
* Scylla AMI is used for Scylla DB servers. You can find, and change, Scylla AMI per region in `inventories/ec2/group_vars/all.yaml`
* scylla-tools package is used for cassandra-stress install on loader servers. You can find the repo version in `roles/loader/vars/main.yaml`

### Prerequisites

#### install
Make sure you installed the following:
* [ansible](http://docs.ansible.com/ansible/intro_installation.html)
* [python boto](https://github.com/boto/boto#installation)

#### config

* Configure EC2 credentials:

```sh
export AWS_ACCESS_KEY_ID=<...>
export AWS_SECRET_ACCESS_KEY=<...>
```

* Make sure your server use a unique name on EC2, by setting ANSIBLE_EC2_PREFIX
```
export ANSIBLE_EC2_PREFIX=tzach
export ANSIBLE_TIMEOUT=30
```

* Make sure you have a ssh-agent running:

```
eval `ssh-agent -s`
```

* By default, `~/.ssh/id_rsa.pub` will be used as your EC2 key. if you
  do not have such a key, [generate one](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) with `ssh-keygen`. to use a different key, override this with ```-e "public_key_path=your-path.pub"```

make sure permission are correct:
```
chmod 700 ~/.ssh
chmod 700 ~/.ssh/id_rsa.pub
```

* Add it to your agent
```sh
ssh-add ~/.ssh/id_rsa.pub
```
(use your key)


* Avoid prompting for SSH key confirmation by
```
export ANSIBLE_HOST_KEY_CHECKING=False
```
* Make sure you have boto version 2.34.0 or above. To check boto version:
```
pip show boto
```
Update boto if required
```
sudo pip install --upgrade boto
```

* The default EC2 regions are define in
```inventories/ec2/group_vars/all.yaml```, with the *AMI*, *security group*.
**You must update the security_group and vpc_subnet_id** to your own.

#### Create security group
**Do this only if you do not already have a security group you can use**
The following will create a EC2 security group called "cassandra-security-group", which is later used for all EC2 servers.
```
ansible-playbook -i inventories/ec2/ configure-security-group.yaml -e "security_group=cassandra-security-group" -e "region=your-ec2-region" -e "vpc_id=your-vpc"
```
Make sure to set one of the VPC subnet IDs on inventories/ec2/group_vars/all.yaml

You only need to run this once. Once security group exists, there is no need to repeat this step. You can use a different security group by adding ```-e "security_group=your_group_name"``` option to all ec2-setup-* scripts below.

#### Launch Scylla cluster
Scylla servers launch from Scylla AMI, base on Fedora 22 (login fedora)

```
./ec2-setup-scylla.sh <options>
```

  **options**
  * ```-e "cluster_nodes=2"``` - number of nodes **per region** (default 2)
  * ```-e "instance_type=c3.8xlarge"``` - type of EC2 instance
  * ```-e "ec2_multiregion=true"```- a multi region EC2 deployment

Server are created with EC2 name *DB*, and tag "server=Scylla"

#### Launch Cassandra cluster
Cassandra servers launch from AMI, base on Ubuntu 14 (login ubuntu)

```
./ec2-setup-cassandra.sh <options>
```

  **options**
  * ```-e "cluster_nodes=2"``` - number of nodes **per region**  (default 2)
  * ```-e "instance_type=m3.large"``` - type of EC2 instance
  * ```-e "num_tokens=6"``` - set number of vnode per server
  * ```-e ec2_multiregion=true``` - a multi region EC2 deployment

Server are created with EC2 name *DB*, and tag "server=Cassandra"

#### Launch Loaders
Loaders are launch from Scylla AMI, base on Fedora 22 (login fedora), including a version of cassandra-stress which only use CQL, not thrift.

```
./ec2-setup-loadgen.sh <options>
```

  **options**
  * ```-e "load_nodes=2"``` - number of loaders **per region** (default 2)
  * ```-e "instance_type=m3.large"``` - type of EC2 instance
  * ```-e "ycsb=true"``` - YCSB loader


#### Add nodes to existing cluster
```
./ec2-add-node-to-cluster.sh -e "server=Cassandra"
```
  **options**
  * ```-e "server=[Cassandra|Scylla]"```
  * ```-e "stopped=true"``` - start server is stopped state
  * ```-e "instance_type=m3.large"``` - type of EC2 instance
  * ```-e "cluster_nodes=2"``` - number of nodes to add (default is 2)
  * ```-e ec2_multiregion=true```- a multi region EC2 deployment

*Add node only works for Cassandra clusters*

#### Start stopped nodes (one by one)
```
./ec2-start-server.sh
```

### Run Cassandra Stress Load

```
./ec2-stress.sh <iterations> -e "load_name=late_night" -e "server=Scylla" <more options>
```

for multi region (update the regions and replication for your needs)
```
./ec2-stress.sh 1 -e "load_name=cassandra.multi.v1" -e "server=Cassandra" -e "stress_options='-schema \"replication(strategy=NetworkTopologyStrategy,us-east_test=1,us-west-2_test=1)\" keyspace=\"mykeyspace\"'" 
```

**Options**
All parameters are available at
[group_vars/all](https://github.com/cloudius-systems/ansible-cassandra-cluster-stress/blob/master/group_vars/all)

To override each of the parameter, use the ``-e "param=value"
notation. Examples below:

* ```-e "server=Cassandra"``` - test cassandra servers (default is scylla)
* ```-e "populate=2500000"``` - key population per loader (default is 1000000)
* ```-e "command=write"``` [read, write,mixed,..] setting stress command
* ```-e "stress_options='-schema \"replication(factor=2)\"'"```
* ```-e "stress_options='-errors ignore'"```
* ```-e "command_options='cl=LOCAL_ONE -mode native cql3'"```
* ```-e "command_options=duration=60m"```
* ```-e "threads=200"```
* ```-e "profile_dir=/tmp/cassandra-stress-profiles/" -e "profile_file=cust_a/users/users1.yaml" -e "command_options=ops\\(insert=1\\)"```
* ```-e "clean_data=true"``` - clean all data from DB servers and restart them before starting the stress
* ```-e "seq_populate=100"``` - populate different range per loader, using `-pop seq=1..100`,  `-pop seq=101..200` etc

Make sure **load name is unique**  so the new results will not
override an old run in the same day.

Load name can not not include *-* (dash)

### Run YCSB Load

(make to sure to create YCSB loaders in advance)

```
./ec2-stress-ycsb.sh <iterations> -e "load_name=late_night" -e "server=Scylla" <more options>
```

To override each of the parameter, use the ``-e "param=value"
notation. Examples below:
* ```-e "workload=workloada"``` Choose YCSB workload
* ```-e "ycsb-prepare=false"``` do *not* run YCSB prepare phase (defualt is true)
* ```-e "recordcount=30000"``` YCSB prepare recoreds count
* ```-e "prepere_options='-p recordcount=100000'"```
* ```-e "run_options='-p operationcount=1000000 -p cassandra.writeconsistencylevel=QUORUM -p cassandcra.readconsistencylevel=QUORUM'"```

### Results

The results are automatically collected and copy to your local
```/tmp/cassandra-results/``` directory, including summary files per load. 

### Stop and start nodes
Stop a server in the cluster

```
./ec2-stop-server.sh external_ip(s)
```

Stop and clean node data
```
./ec2-stop-server.sh external_ip -e "clean_data=true"
```

This will stop Cassandra service on this server, while keeping it in
the cluster.

Use ```./ec2-start-server.sh``` to start stopped servers, or just
update the **stopped** tag back to false.
The next stress test will restart the Cassandra service.

### Terminate Servers
```
./ec2-terminate.sh
```

## License
The Scylla/Cassandra Cluster Stress is distributed under the Apache License.
See LICENSE.TXT for more.
