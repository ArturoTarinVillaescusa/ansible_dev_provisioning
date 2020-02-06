
# CP-Ansible

## Introduction

Ansible provides a simple way to deploy, manage, and configure the Confluent Platform services. This repository provides playbooks and templates to easily spin up a Confluent Platform installation. Specifically this repository:

* Installs Confluent Platform packages.
* Starts services using systemd scripts.
* Provides configuration options for plaintext, SSL, SASL_SSL, and Kerberos.

The services that can be installed from this repository are:

* ZooKeeper
* Kafka
* Schema Registry
* REST Proxy
* Confluent Control Center
* Kafka Connect (distributed mode)
* KSQL Server

## Documentation

You can find the documentation for running CP-Ansible at https://docs.confluent.io/current/tutorials/cp-ansible/docs/index.html.

## Contributing

If you would like to contribute to the CP-Ansible project, please refer to the [CONTRIBUTE.md](https://github.com/confluentinc/cp-ansible/blob/5.3.0-post/CONTRIBUTING.md)

## License

[Apache 2.0](https://github.com/confluentinc/cp-ansible/blob/5.1.x/LICENSE.md) 



Change the hosts.yaml

arturotarin@QOSMIO-X70B:~/Documents/Mistral/2019-08-19  Secured Kafka cluster with ansible/cp-ansible
17:26:16 $ ansible-playbook -i hosts_example.yml all.yml --ask-become-pass -k --become --become-method=sudo


Use rentalcar-setup.yml instead of all.yml for minimum Kafka configuration:

(Kafka brokers, Zookeeper, Kafka Registry, Kafka Rest)

arturotarin@QOSMIO-X70B:~/Documents/Mistral/2019-09-19 Secured Kafka cluster with ansible By Paco/ansible
18:14:02 $ ansible-playbook -i environments/lab/kafka-lab-rentalcar-hosts.yml playbooks/kafka-rentalcar-setup.yml --ask-become-pass -k --become --become-method=sudo
SSH password: 
BECOME password[defaults to SSH password]: 
ERROR! failed to combine variables, expected dicts but got a 'dict' and a 'AnsibleUnicode': 
{}
"../../../../000_cross_env_vars"

