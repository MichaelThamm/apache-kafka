# apache-kafka

## Bash Scripts
* To run Kafka in single-broker mode, execute:
  * ```. bash-scripts/run.sh```

# Tutorials
* [zero-to-hero-kafka-connect](https://github.com/confluentinc/demo-scene/blob/master/kafka-connect-zero-to-hero/demo_zero-to-hero-with-kafka-connect.adoc)
* [debezium-kafka-connect](https://debezium.io/documentation/reference/stable/architecture.html)
* [install-microstack](https://microstack.run)

## Installing MicroStack
### Install Multipass
* sudo snap install multipass
  * This command installs Multipass, which is a tool to manage virtual machines (VMs) on your system.
### Get a fresh VM with Ubuntu 22.04 LTS
* multipass launch --name microstack --cpus 4 --memory 16G --disk 50G && multipass shell microstack
  * This command creates a new VM named "microstack" with specific CPU, memory, and disk specifications. It then opens a shell in that VM. Since this command creates a VM, any changes or tests you perform will be isolated within this VM.
### Install MicroStack
* sudo snap install openstack
  * This command installs MicroStack, which is a lightweight version of OpenStack designed for development and testing purposes. It installs OpenStack services in your VM.
### Prepare a machine
* sunbeam prepare-node-script | bash -x && newgrp snap_daemon
  * This command prepares the VM for hosting OpenStack services. It might install necessary dependencies and configure some settings within the VM. The newgrp snap_daemon command might change your group membership.
### Bootstrap OpenStack
* sunbeam cluster bootstrap --accept-defaults
  * This command initializes the OpenStack services within the VM. It sets up the necessary components to run OpenStack, such as databases, message queues, and identity services. This process is contained within the VM.
### Configure OpenStack
* sunbeam configure --accept-defaults --openrc demo-openrc
  * This command configures the OpenStack environment for use. It generates an OpenStack RC file (demo-openrc) that contains environment variables needed to interact with OpenStack services. Again, this process is contained within the VM.
### Launch a cloud instance
* sunbeam launch ubuntu -n test
  * This command launches a new Ubuntu cloud instance within the OpenStack environment. It's a way to test the functionality of OpenStack by creating and managing cloud instances. Any actions performed within this instance will be isolated within the OpenStack environment.
